# Repository Guidelines

## Project Structure & Module Organization
`coffix_app` is a Flutter mobile app with a Firebase Functions backend.

- `lib/`: app source code, organized by feature (`features/<feature>/{data,logic,presentation}`) plus shared `core/`, `domain/`, `data/`, and `presentation/` layers.
- `functions/`: TypeScript Cloud Functions API (`src/` source, compiled output in `lib/`).
- `test/`: Flutter tests.
- `assets/`: images, icons, and fonts.
- `docs/`: implementation notes and flow docs.
- Platform folders: `android/`, `ios/`, `web/`.

## Build, Test, and Development Commands
- `flutter pub get`: install Flutter dependencies.
- `flutter run -t lib/main_dev.dart`: run app with dev flavor.
- `flutter run -t lib/main_prod.dart`: run app with prod flavor.
- `flutter analyze`: static analysis using `flutter_lints`.
- `flutter test`: run Dart/Flutter tests.
- `dart run build_runner build --delete-conflicting-outputs`: regenerate `freezed`/`json_serializable` files.
- `npm --prefix functions ci`: install Functions dependencies.
- `npm --prefix functions run build`: compile TypeScript functions.
- `npm --prefix functions run serve`: build + run Firebase Functions emulator.

## Coding Style & Naming Conventions
- Follow Dart defaults: 2-space indentation, trailing commas where helpful, and run `dart format .` before opening a PR.
- Keep Flutter files in `snake_case.dart`; classes/widgets in `PascalCase`; methods/variables in `camelCase`.
- Keep feature boundaries clear: UI in `presentation`, state in `logic`, data access in `data`.
- In `functions/`, keep TypeScript modules small, typed, and organized by domain (`src/<domain>/service.ts`, `router.ts`, etc.).

## Testing Guidelines
- Place tests under `test/` with names ending in `_test.dart`.
- Prefer widget and state-management tests for new UI/business logic; mock network and Firebase boundaries.
- For Functions changes, at minimum run `npm --prefix functions run build` to catch type/runtime contract issues before deploy.

## Commit & Pull Request Guidelines
- Recent history uses short, imperative subjects (for example: `implement payment`, `update app bar`). Keep commit titles concise and action-oriented.
- PRs should include: purpose, key changes, test evidence (`flutter test`, `flutter analyze`, Functions build), and screenshots for UI updates.
- Link related issue/task IDs and call out env-specific changes (`dev` vs `prod`) when relevant.

## Security & Configuration Tips
- Do not commit secrets. Keep local values in `.env`, `.env.dev`, and `functions/.env` (see `functions/env.example`).
- Treat payment and credential handling as server-side only; never expose keys in Flutter client code.
