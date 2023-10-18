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

## Prerequisites

**Please ensure you can do the following prior to the workshop:**

```sh
```

## Agenda

### The Problem (13:15 pm)

 - TK: I still have a complex application, but now I'm not bundling that complexity into my models. The complexity has to go somewhere. In _Dive Into Valkyrie_, we put that complexity into the controller (count the dependencies in the controller). This has some trade offs: I get all the flexibility that Valkyrie/Data Mapper promises but, in practice, I write more controllers than I write models.

### Forms & Indexers (13:30)

### Configurable Metadata (14:00)

### Dry-Events & Hyrax's Event Bus (14:30)

### Break (15:00)

### Custom Queries (15:15)

### Transactions (15:30)

### Wrap-up (16:00)

## Resources

  * [Hyrax Valkyrie Usage Guide](https://github.com/samvera/hyrax/wiki/Hyrax-Valkyrie-Usage-Guide)
  * [Hyrax's Event Bus](https://github.com/samvera/hyrax/wiki/Hyrax's-Event-Bus-(Hyrax::Publisher))
