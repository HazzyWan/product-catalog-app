# Product Catalog App

A small product catalog app built for a technical assessment, using the DummyJSON API.

**A quick note before anything else:** this is my first time building a mobile app, and my first time working with Flutter and Dart. I used AI (Claude) as a guide throughout, mainly to help me understand Flutter and Dart concepts as I went, troubleshoot environment setup and build errors, and talk through architecture decisions before I implemented them myself. I typed out all the code myself, with comments explaining what each section and function does, which helped me actually understand it as I went rather than just copying something that worked. More detail on this is in the AI Usage section below.

## Stack
Flutter

## How to Run
1. `flutter pub get`
2. `flutter run` (select a connected device or emulator)

## Architecture Decisions
- `data/` layer: models (Product, with a fromJson factory), services (ProductApi handles the raw HTTP calls), and repositories (ProductRepository manages pagination state and sits between the API and the UI)
- `presentation/` layer: screens, widgets, providers, and a state pattern
- State pattern: ProductListState is a sealed class with four possibilities, Loading, Empty, Loaded, and Error. The UI is always in exactly one of these, which avoids scattered or contradictory boolean flags
- ProductListProvider (a ChangeNotifier) owns the current state and calls ProductRepository. UI widgets watch this provider and rebuild automatically whenever the state changes

## Search Approach
I used DummyJSON's search endpoint (`/products/search?q=`), triggered with a 500ms debounce after the user stops typing, so it doesn't fire a request on every keystroke. One thing worth noting, this endpoint matches across multiple fields (title, description, category, tags), not just the title, so results can sometimes include items whose title alone doesn't contain the search term.

## TODOs / Known Issues
- No unit tests yet (in progress, this was one of the optional bonuses)
- Search results don't support pagination. The search endpoint returns a flat list, so scrolling to the bottom of search results won't load more
- No dedicated "no internet connection" message. Network failures currently show the generic error state with a retry button, which works but doesn't distinguish connectivity issues from other kinds of failures
- No caching. Every screen open re-fetches from the network. Acceptable for this scope, but I'd add a local cache layer with more time
- As mentioned above, search matches DummyJSON's multi-field logic, so some results may look unrelated to the search term at first glance. This is expected API behavior, not a bug on my end

## AI Usage
I used Claude (Anthropic) throughout this project, mainly for guidance rather than having it generate the app for me. Specifically:
- Helping me set up and troubleshoot the Flutter and Android SDK environment (PATH configuration, emulator setup, build errors)
- Talking through architecture choices with me, like the data and presentation layer split, the sealed class state pattern, provider based state management, and the debounced search approach, before I implemented any of it
- Explaining Dart language concepts I hadn't used before, like Futures and async/await, named parameters, factory constructors, and sealed classes, and helping me write comments in the code so I could actually understand and explain every line in my walkthrough video
- Helping me debug a few build errors along the way, like an unsaved file and a missing import

Since this was my first time with Flutter and mobile development in general, I leaned on it more for learning and understanding than I might on a stack I already knew well.