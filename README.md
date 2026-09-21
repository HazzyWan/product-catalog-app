# Product Catalog App

## Stack
Flutter

## How to Run
1. `flutter pub get`
2. `flutter run` (select a connected device/emulator)

## Architecture Decisions
- `data/` layer: models (Product + fromJson), services (ProductApi handles raw HTTP
  calls), repositories (ProductRepository manages pagination state, sits between
  API and UI)
- `presentation/` layer: screens, widgets, providers, and a state pattern
- State pattern: ProductListState is a sealed class with four possibilities
  (Loading/Empty/Loaded/Error) — the UI is always in exactly one of these,
  avoiding scattered/contradictory boolean flags
- ProductListProvider (a ChangeNotifier) owns the current state and calls
  ProductRepository; UI widgets watch this provider and rebuild automatically
  when state changes

## Search Approach
Using DummyJSON's search endpoint (`/products/search?q=`), triggered with a 500ms
debounce after the user stops typing — avoids firing a request on every keystroke.
Note: this endpoint matches across multiple fields (title, description, category,
tags), not just the title — so results may include items whose title alone doesn't
contain the search term.

## TODOs / Known Issues
_(to fill in)_

## AI Usage
Used Claude for guidance on Flutter/Android tooling setup, and to talk through the
data/service/repository layer split and pagination approach. All code typed and
understood line-by-line by me; comments in the code reflect my own understanding.