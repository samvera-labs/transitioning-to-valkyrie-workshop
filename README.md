# [Transitioning to Valkyrie](https://samveraconnect2023.sched.com/event/1OmBn)

This repository supports a workshop given at
[Samvera Connect 2023](https://samvera.atlassian.net/wiki/spaces/samvera/pages/2174877699/Samvera+Connect+2023).

Valkyrie is a data persistence library which provides a common interface to multiple backends. There are a growing number of Samvera applications that use Valkyrie including Hyrax. This workshop will introduce core concepts and how they differ from ActiveFedora, ActiveRecord, and ActiveStorage. We’ll build a simple rails application that uses Valkyrie to write metadata to a postgres database and store files on disk.

This workshop assumes a general familiarity with Object Orientation and Ruby programming. Participants will need a laptop with a working docker/docker compose setup. We'll provide preparation instructions to registered attendees in advance of the workshop.

## Learning Outcomes

We will learn:
1. Familiarity with general design patterns for Valkyrie and Dry.rb applications.
   1. Why DataMapper?
   1. Metadata as Configuration
   1. ChangeSets & Forms
   1. Indexers
   1. AccessControlList
1. Familiarity with patterns applied in Hyrax 4 and common integration points for applications
   1. Custom Queries
   1. Transactions
      1. As a replacement for the ActorStack
      1. Patterns for overriding Hyrax's default transactions.
   1. Hyrax's Event Bus
      1. Old callback model and its limitations.
      1. Writing and subscribing listeners.
1. Ideas about how to apply Hyrax patterns to improve maintainability of Hyrax 3.x and 4.x applications

## Prerequisites

**Please ensure you can do the following prior to the workshop:**

```sh
```

## Agenda

???


## Resources

  * [Hyrax Valkyrie Usage Guide](https://github.com/samvera/hyrax/wiki/Hyrax-Valkyrie-Usage-Guide)
  * [Hyrax's Event Bus](https://github.com/samvera/hyrax/wiki/Hyrax's-Event-Bus-(Hyrax::Publisher))
