---
description: "This rule provides the overall architecture and MUST follow when building the project"
alwaysApply: false
---

# Architecture Overview

This document provides a high-level overview of the Flutter application architecture. The project follows a modular, feature-first approach combined with Clean Architecture principles and Atomic Design for the UI layer.

## Core Philosophy

The architecture aims for:

- **Separation of Concerns:** Distinct layers for data, business logic, and UI.
- **Scalability:** Features are self-contained modules, making it easy to add new functionality without impacting existing code.
- **Reusability:** UI components are built using Atomic Design principles, promoting consistency and reducing code duplication.
- **Testability:** Logic is decoupled from the UI and external dependencies (API, Database), making unit testing straightforward.

## High-Level Structure

The codebase is organized into the following primary directories:

```
lib/
├── core/           # Shared utilities, services, configuration, and base classes.
├── features/       # Feature-specific code (logic, data, domain, UI).
├── data/           # Repository Interfaces (Abstract definitions).
├── domain/         # Global Domain Logic (Use Cases).
├── presentation/   # Generic UI Components (Atomic Design).
├── l10n/           # Localization files.
└── main.dart       # App entry point.
```

---

## detailed Breakdown

### 1. Core (`lib/core`)

Contains application-wide utilities and infrastructure code.

- **`api/`**: Network layer configuration (Dio client, Interceptors, OpenAPI generated code).
- **`di/`**: Dependency Injection setup (`GetIt` service locator).
- **`routes/`**: Navigation logic (`AppRouter`).
- **`services/`**: Infrastructure services (Storage, Permissions, Analytics, etc.).
- **`theme/`**: App theming (Colors, Typography).
- **`utils/`**: Helper functions and extensions.

<!--
- **`widgets/`**: Core reusable widgets not specific to the design system. -->

### 2. Features (`lib/features`)

Each feature is a self-contained module. A typical feature structure looks like this:

```
features/<feature_name>/
├── data/           # Repository Implementations (API calls, Local storage).
├── domain/         # Feature-specific Use Cases.
├── logic/          # State Management (Cubits/Blocs).
├── presentation/   # Feature-specific UI.
│   ├── pages/      # Screens/Pages for this feature.
│   └── widgets/    # Widgets specific only to this feature.
```

- **Logic:** Handles UI state using **Cubit (Bloc)**.
- **Data:** Implements the repository interfaces defined in `lib/data`.
- **Domain:** Contains business logic encapsulated in Use Cases.
- **Presentation:** Screens and specific widgets.

### 3. Data Layer (`lib/data`)

- **`repositories/`**: Defines the **Interfaces** (Abstract Classes) for repositories.
  - _Note: This is a specific convention where interfaces live in `data` while implementations live in `features/data`._

### 4. Domain Layer (`lib/domain`)

- **`usecases/`**: Contains global business logic that spans multiple features or doesn't belong to a single feature.
`
### 5. Presentation Layer (`lib/presentation`)

Implements the **Atomic Design System** for reusable UI components:

- **`atoms/`**: Basic building blocks (Buttons, Text, Inputs, Icons).
- **`molecules/`**: Groups of atoms (Form fields with labels, Cards).
- **`organisms/`**: Complex UI sections (Headers, Lists, specialized widgets).

---

## Key Patterns & Technologies

### State Management

- **Pattern:** **BLoC / Cubit**
- **Usage:** Logic layer manages state, UI layer listens to state changes.
- **See also:** [State Management Guide](state_management.md) _(Coming Soon)_

### Dependency Injection (DI)

- **Library:** `get_it`
- **Setup:** Manual registration in `lib/core/di/service_locator.dart`.
- **Usage:** Injected into Cubits and Use Cases.

### Navigation

- **Library:** Custom `AppRouter` (GoRouter).
- **Pattern:** Centralized routing logic.

### Localization

- **Library:** `flutter_localizations`
- **Files:** `lib/l10n/` (ARB files).
