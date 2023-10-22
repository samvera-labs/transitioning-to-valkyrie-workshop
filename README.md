# [Transitioning to Valkyrie](https://samveraconnect2023.sched.com/event/1OmBn)

This repository supports a workshop given at
[Samvera Connect 2023](https://samvera.atlassian.net/wiki/spaces/samvera/pages/2174877699/Samvera+Connect+2023).

Over the past several releases, Hyrax internals have become increasingly patterned after Valkyrie. As the engine codebase has been adapted, new interfaces for applications have been introduced leveraging these patterns. We’ll go over these patterns, how they differ from previous patterns, and how to use them to customize your Hyrax application.

This workshop assumes a general familiarity with Object Orientation and Ruby programming, and some hands-on experience with the Valkyrie data mapper library.

## Learning Outcomes

We will learn:

1. Familiarity with general design patterns for Valkyrie and Dry.rb applications.
   1. Understand why Hyrax has moved toward Valkyrie (and the DataMapper pattern);
   1. Know how to use Configurable Metadata for defining Hyrax models;
   1. Understand support objects for data interactions in Hyrax and their customization;
      1. Data Validation with ChangeSets & Forms
      1. Indexers
1. Familiarity with patterns applied in Hyrax 4 and common integration points for applications
   1. Custom Queries
   1. Transactions
      1. As a replacement for the ActorStack
      1. Patterns for overriding Hyrax's default transactions.
   1. Hyrax's Event Bus
      1. Old callback model and its limitations.
      1. Writing and subscribing listeners.
1. Ideas about how to apply Hyrax patterns to improve maintainability of Hyrax 3.x and 4.x applications

## Getting Started

This repository includes a Hyrax 5.x/Rails application and a `docker-compose.yml` intended to run that application and its dependencies. We'll use this application as a general workspace throughout the workshop and as the base for our exercises.

To ensure you can run the application, do:

```sh
git clone git@github.com:samvera-labs/transitioning-to-valkyrie-workshop.git
docker pull ghcr.io/samvera/transitioning-to-valkyrie-workshop:2023-10-23
docker compose up
docker compose exec app rspec # expect 159 examples, 0 failures, 2 pending
```

## Agenda

### Introduction (13:15 pm)

The goal of this workshop is to familiarize you with how Hyrax 5.0 supports managing realistic application complexity with Valkyrie. These patterns have been present since the 3.x series (and in some cases, since 2.x), and have had some time to gain maturity. Stripping away ActiveFedora in Hyrax 5 means the engine is leaning heavily on these patterns to manage its complexity, and application developers should be aware of these patterns as options for leaning on stable engine features to manage their own.

The patterns we're looking at often replace older patterns from the Sufia/Hyrax 1.x era, including:

  - `HydraEditor::Form`;
  - `#to_solr` and `ActiveFedora::IndexingService`;
  - the (little known) `Hyrax::Callbacks`;
  - the "Actor Stack".

#### Some shortcuts:

```ruby
Hyrax.persister
Hyrax.query_service
Hyrax.custom_queries
Hyrax.index_adapter
Hyrax.storage_adapter
```

#### Resources

  * [Valkyrie Wiki](https://github.com/samvera/valkyrie/wiki/)
  * [Hyrax Valkyrie Usage Guide](https://github.com/samvera/hyrax/wiki/Hyrax-Valkyrie-Usage-Guide)
  * [RubyDocs / YARD annotations](https://rubydoc.info/gems/hyrax/Hyrax/)

### Models, Forms & Indexers (13:30)

#### A Default ChangeSet

To get a default/basic `ChangeSet` for any model, use `Hyrax::ChangeSet.for(my_model)`.

```ruby
work       = Monograph.new
change_set = Hyrax::ChangeSet.for(work)

change_set.validate(title: ["Comet in Moominland"])

change_set.title # => ["Comet in Moominland"]
work.title = []

change_set.sync
work.title # => ["Comet in Moominland"]
```

Note that you can always use a different `ChangeSet` class for your models, and your use cases may call for this. E.g. you may want to validate or coerce changes in specific ways in some contexts, but not in others; consider validating user input for new objects, as opposed to validating objects migrating from a legacy system.

#### ChangeSet style forms

Similarly, the pattern for getting the default Form for a given object is `Hyrax::Forms::ResourceForm.for(my_model)`. Forms are `ChangeSets`, with some added behavior to support the assumptions about Forms made by Hyrax's Controllers and Views.

```ruby
work = Monograph.new
form = Hyrax::Forms::ResourceForm.for(work)

form.class < Valkyrie::ChangeSet # => true
```

When using the model generator (`rails generate hyrax:work_resource Monograph`), a `Hyrax::Form` is generated for each model into `app/forms`. You can customize the form used by `WorksControllerBehavior` and related code by editing this class.

#### Indexers

Hyrax handles indexing by providing a specialized write-only metadata adapter to write data to Solr. That adapter passes each Valkyrie::Resource through an "indexer" to create a Solr document Hash to index. Much like Forms, these indexers are generated into your application, and there is a `#for` factory method to find the indexer for your current model.

```ruby
Hyrax::ValkyrieIndexer.for(resource: work).to_solr
```

Customization follows the same `#to_solr` pattern from the Sufia days:

```ruby
class MyIndexer < Hyrax::ValkyrieWorkIndexer
  def to_solr
    super.tap do |index_document|
      index_document[:upcased_title_tesim]   = resource.title.map(&:upcase)
    end
  end
end
```

#### Exercise 1: Model Customization

Add a field to the `Monograph` model to store ISBN as a string. Add validation for the `MonographForm` against the regex: `/(?=(?:\D*\d){10}(?:(?:\D*\d){3})?$)[\d-]+/`, add indexing to `MonographIndexer`.

```sh
# Make these tests pass:
git checkout models-exercise
docker compose exec app rspec
```


#### Resources

  - [Valkyrie ChangeSets](https://github.com/samvera/valkyrie/wiki/ChangeSets-and-Dirty-Tracking)
  - [Reform Documentation](https://trailblazer.to/2.0/gems/reform)

### Configurable Metadata (14:00)

Hyrax supports YAML driven configuration!

As an alternate solution to exercise 1, we can do this (and then add validation to the form):

```yaml
# config/metadata/monograph.yaml
attributes:
  # ...
  isbn:
    type: string
    index_keys:
      - "isbn_sim"
```

When we see code like `include Hyrax::Schema(:monograph)` and `include Hyrax::Indexer(:monograph)` in Hyrax, or generated into our application, this is to support the configurable metadata.

### Dry-Events & Hyrax's Event Bus (14:10)

#### Legacy "Callbacks"

[`Hyrax::Callbacks`](https://www.rubydoc.info/github/samvera/hyrax/Hyrax/Callbacks) allowed a user to set a block as a named callback method, which would then be triggered by engine or application code:

```ruby
# to register
Hyrax.config.callback.set(:after_create_concern) do |curation_concern, user|
  ContentDepositEventJob.perform_later(curation_concern, user)
end

# from application code
Hyrax.config.callback.run(:after_create_concern, curation_concern, user)
```

Hyrax 3.0.0 and beyond improve on this interface with a thread-safe, topic based publish/subscribe system. This allows multiple "listeners" to subscribe to the same "topics" (you can also understand these as event streams or channels).

#### Hyrax's Promises About Events

Whenever Hyrax performs one of the actions associated with a named Event, it promises to push an event to the Publisher with a payload. The Event payloads are specific to each event type/topic, but usually contain the object acted on and the user responsible for triggering the Event.

If an application subscribes a listener to an topic, it should be able to rely on:

  - an event being published whenever relevant behaviors take place (e.g. when persisted metadata for an Object is updated, `object.metadata.updated` is published).
)
  - a consistent payload per topic.

If an application performs a relevant behavior, it __SHOULD__ publish an event on the related topic. This will take advantage of both the default and locally configured listeners.

#### Implementing Listeners

Define a class with a listener method, and subscribe it to the Publisher:

```ruby
class MyCustomListener
  def on_object_deposited(event)
    # do something here
  end
end

Hyrax.publisher.subscribe(MyCustomListener.new)
```

#### Publishing Events

```ruby
Hyrax.publisher.publish('object.deposited', object: deposited_object, user: depositing_user)
```

#### Exercise 2: Custom Listener

Write and subcribe a listner that logs level `:info` to `Hyrax.logger` whenever an `object.deposited` or `object.metadata.updated` event is published.


```sh
# Make these tests pass:
git checkout events-exercise
docker compose exec app bundle exec rspec
```

If you have time, make another listener that does something more complex! (or take a long break)

#### Resources

  * [Hyrax's Event Bus](https://github.com/samvera/hyrax/wiki/Hyrax's-Event-Bus-(Hyrax::Publisher))
  * [DRY Events](https://dry-rb.org/gems/dry-events/)
  * [Hyrax::Publisher](https://rubydoc.info/gems/hyrax/Hyrax/Publisher)

### Break (14:40)

### Custom Queries (15:00)

  - Custom Queries in Valkyrie;
  - Overview of Custom Queries in Hyrax;
  - When to think about developing Custom Queries?
    - When using a metadata adapter supported by Hyrax and queries are slow for your application;
    - When using an unsupported adapter and you'd like to optimize query performance;
    - When your app is performing complex or multi-step queries and you'd like to optimize query performance.

#### Resources

  - [Custom Queries (Valkyrie)](https://github.com/samvera/valkyrie/wiki/Queries#custom-queries)
  - [Custom Queries in Hyrax](https://github.com/samvera/hyrax/wiki/Hyrax-Valkyrie-Usage-Guide#custom-queries)
  - [Custom Queries Development Pattern](https://github.com/samvera/hyrax/wiki/Custom-Queries-Development-Pattern)

### Transactions (15:15)

#### Exercise 3: Transactions

```sh
git checkout transactions-exercise
docker compose exec app bundle exec rspec
```

#### Resources

  - [The Result Object (monad)](https://dry-rb.org/gems/dry-monads/1.6/result/)

### Wrap-up (16:00)
