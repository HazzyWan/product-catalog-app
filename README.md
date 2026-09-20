# Product Catalog App

## Stack
Flutter

## How to Run
1. `flutter pub get`
2. `flutter run` (select a connected device/emulator)

## Architecture Decisions
- Split into three layers under `lib/data/`:
  - `models/` — Product data class with a `fromJson` factory for parsing API responses
  - `services/` — ProductApi handles raw HTTP calls to DummyJSON (list, detail, search)
  - `repositories/` — ProductRepository sits between the API and UI, managing pagination
    state (skip/limit) so screens don't need to track it themselves
- UI layer (presentation/) will only ever call ProductRepository, never ProductApi directly

## Search Approach
_(to fill in — client-side debounce vs API search endpoint, and why)_

## TODOs / Known Issues
_(to fill in)_

## AI Usage
Used Claude for guidance on Flutter/Android tooling setup, and to talk through the
data/service/repository layer split and pagination approach. All code typed and
understood line-by-line by me; comments in the code reflect my own understanding.