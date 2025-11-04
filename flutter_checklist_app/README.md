# Checklist App

A Flutter task management app built with clean architecture principles. Create, manage, and sync your tasks with an intuitive interface that works offline and syncs when online.

## Features

- Create, edit, and delete tasks
- Mark tasks as complete/incomplete
- Search and filter tasks
- Sort tasks by date, name, or status
- Offline-first architecture - works without internet
- Sync with remote API when connected
- Pull-to-refresh to sync data
- Mock data for quick start

## Screenshots

*Add screenshots here if you have them*

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS simulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flutter_checklist_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (Freezed and JSON serialization):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### First Run

On first launch, the app automatically loads sample daily chores to help you get started. You can clear these and add your own tasks, or use the menu options to reload mock data anytime.

## Architecture

This app follows clean architecture principles with clear separation of concerns across three main layers:

### Domain Layer
The core business logic and entities. This layer has no dependencies on external frameworks.

- **Entities**: `Task` - The core data model using Freezed for immutability
- **Repositories**: `TaskRepository` - Interface defining data operations

### Data Layer
Handles data persistence and network operations. Implements the repository interfaces from the domain layer.

- **Data Sources**:
  - `TaskLocalDataSource` - Hive-based local storage
  - `TaskRemoteDataSource` - API calls using Dio (currently simulated)
- **Repositories**: `TaskRepositoryImpl` - Coordinates between local and remote sources
- **Services**: `MockDataService` - Manages sample data

### Presentation Layer
UI components and state management using BLoC pattern.

- **Cubit**: `TaskCubit` - Manages task state and business logic
- **Pages**: 
  - `TaskListPage` - Main screen with task list
  - `TaskFormPage` - Create/edit task screen

### Core Layer
Shared utilities and infrastructure.

- **Network**: `ApiClient`, `ConnectivityChecker` - HTTP client and connectivity checks
- **DI**: `injection.dart` - Dependency injection setup using GetIt

## Architecture Decisions

This section explains the key architectural decisions made during development, the reasoning behind each choice, and how they contribute to the overall quality and maintainability of the codebase.

### Clean Architecture

Clean architecture was chosen as the foundational pattern for this application. This approach organizes the codebase into distinct layers with well-defined boundaries and dependency rules.

**Core Principles:**
- **Dependency Inversion**: Dependencies flow inward toward the domain layer. The domain layer (business logic) has no dependencies on external frameworks or libraries, while outer layers depend on inner ones.
- **Separation of Concerns**: Each layer has a single, well-defined responsibility. The domain layer contains business logic, the data layer handles persistence, and the presentation layer manages UI.
- **Testability**: By isolating business logic from infrastructure, each layer can be tested independently. Domain logic can be tested without UI or database dependencies.

**Implementation:**
The application is structured into three primary layers:
1. **Domain Layer**: Pure Dart code containing entities and repository interfaces. This layer defines the business rules and data contracts.
2. **Data Layer**: Implements repository interfaces using Hive for local storage and Dio for network operations. This layer is responsible for data transformation and persistence.
3. **Presentation Layer**: Contains UI components and state management using BLoC. This layer depends on the domain layer for business logic.

**Benefits:**
- Long-term maintainability as the codebase grows
- Easy to swap implementations (e.g., change database from Hive to SQLite)
- Clear boundaries make onboarding new developers easier
- Business logic remains independent of framework changes

**Trade-offs:**
- Initial setup requires more boilerplate code
- Slight learning curve for developers unfamiliar with clean architecture
- More files to navigate, but better organized

### Offline-First Strategy

The application implements an offline-first architecture, prioritizing local data storage and synchronization over real-time network operations.

**Approach:**
All data operations first write to local storage (Hive), ensuring immediate persistence and instant UI updates. Network synchronization happens asynchronously in the background, providing eventual consistency with the remote server.

**Implementation Details:**
- Local storage is the source of truth for the UI
- Create/update/delete operations write to local storage immediately
- Background sync operations push changes to remote API without blocking the UI
- Manual sync triggers (pull-to-refresh, sync button) fetch latest data from remote
- Network failures are handled gracefully without disrupting the user experience

**Benefits:**
- **Performance**: Local reads are instant, providing a snappy user experience
- **Reliability**: App works fully offline, ideal for mobile environments with unreliable connectivity
- **User Experience**: No loading spinners for basic operations, immediate feedback
- **Data Resilience**: Local data survives app restarts and network interruptions

**Trade-offs:**
- Requires conflict resolution logic when local and remote data diverge
- Additional complexity in sync logic
- Increased local storage usage

**Use Cases:**
This pattern is particularly valuable for mobile applications where network connectivity can be intermittent, and users expect immediate feedback regardless of connection status.

### State Management: BLoC Pattern

BLoC (Business Logic Component) pattern was selected for state management to maintain a clear separation between business logic and UI components.

**Architecture:**
The BLoC pattern treats the application as a stream of events. User interactions (events) flow into the BLoC, which processes them using business logic and emits new states. The UI listens to these state streams and rebuilds accordingly.

**Implementation:**
- `TaskCubit` extends `Cubit` from the flutter_bloc package, managing task-related state
- UI dispatches events (create task, update task, delete task) to the cubit
- Cubit processes events and emits new states
- UI rebuilds automatically when state changes

**Benefits:**
- **Separation of Concerns**: Business logic is isolated from UI code
- **Testability**: BLoC logic can be tested without UI dependencies
- **Predictability**: Unidirectional data flow makes state changes easier to reason about
- **Reusability**: Business logic can be reused across different UI implementations
- **Debugging**: Clear event-to-state flow makes tracking issues easier

**Alternative Considerations:**
While other patterns like Provider or Riverpod were considered, BLoC was chosen for its maturity, extensive documentation, and strong type safety. The pattern scales well as the application grows and provides excellent tooling for state inspection during development.

### Immutable Data Models with Freezed

Freezed was integrated to generate immutable data classes with comprehensive functionality, reducing boilerplate and preventing common mutability-related bugs.

**Why Immutability:**
Immutability ensures that data objects cannot be modified after creation, eliminating entire classes of bugs related to unexpected state changes. This is especially important in Flutter's reactive UI model, where state changes trigger rebuilds.

**Freezed Features:**
- **Automatic Code Generation**: Generates `copyWith`, `==`, `hashCode`, and `toString` methods
- **Union Types**: Supports pattern matching for different states (e.g., loading, success, error)
- **JSON Serialization**: Seamless integration with `json_serializable` for API communication
- **Type Safety**: Compile-time safety catches errors before runtime

**Implementation:**
The `Task` entity uses Freezed annotations, generating approximately 200 lines of boilerplate code automatically. This includes:
- Immutable constructors
- `copyWith` method for creating modified copies
- Value-based equality comparison
- JSON serialization/deserialization
- Pattern matching support

**Benefits:**
- **Reduced Boilerplate**: Eliminates repetitive code that would otherwise be error-prone
- **Type Safety**: Compile-time checks prevent runtime errors
- **Performance**: Generated code is optimized and efficient
- **Maintainability**: Changes to models automatically propagate to generated code

**Trade-offs:**
- Requires code generation step in build process
- Slight learning curve for Freezed syntax
- Generated files need to be committed to version control

### Repository Pattern

The repository pattern provides a clean abstraction over data sources, decoupling the presentation layer from specific storage or network implementations.

**Design:**
The repository acts as a mediator between the domain layer and data sources. It defines a contract (interface) in the domain layer and implements it in the data layer. This allows the business logic to remain agnostic about data persistence details.

**Implementation:**
- `TaskRepository` interface defined in the domain layer
- `TaskRepositoryImpl` in the data layer implements the interface
- Coordinates between `TaskLocalDataSource` (Hive) and `TaskRemoteDataSource` (API)
- Handles sync logic between local and remote data sources

**Benefits:**
- **Abstraction**: Presentation layer doesn't need to know data source details
- **Flexibility**: Easy to swap implementations (e.g., switch from Hive to SQLite)
- **Testability**: Can mock repository for unit tests
- **Single Responsibility**: Repository handles data coordination logic
- **Future-Proof**: Adding new data sources (e.g., cloud storage) doesn't affect other layers

**Sync Strategy:**
The repository implements a write-through strategy: writes go to local storage first (fast response), then sync to remote in the background (eventual consistency). Reads are always from local storage for performance. Manual sync operations fetch from remote and update local storage.

**Use Cases:**
This pattern is particularly valuable when multiple data sources exist (local storage, remote API, cache) and the application needs to coordinate between them seamlessly.

## Libraries Used

### State Management

**flutter_bloc (^9.0.0)**
- Used for state management with BLoC pattern
- Provides clean separation between business logic and UI
- Easy to test and maintain

### Data Persistence

**hive (^2.2.3) & hive_flutter (^1.1.0)**
- Fast, lightweight NoSQL database for local storage
- Perfect for offline-first apps
- Simple API and good performance
- No native dependencies, pure Dart

### Network

**dio (^5.7.0)**
- Powerful HTTP client for making API calls
- Better than `http` package with interceptors, request cancellation, and error handling
- Good TypeScript-like API that's easy to use

**connectivity_plus (^6.1.0)**
- Checks device connectivity status
- Used to prevent API calls when offline
- Provides stream of connectivity changes

### Code Generation

**freezed (^2.5.7) & freezed_annotation (^2.4.4)**
- Generates immutable data classes
- Reduces boilerplate for models
- Provides `copyWith`, `==`, `hashCode`, and `toString` automatically

**json_serializable (^6.9.0) & json_annotation (^4.9.0)**
- Generates JSON serialization code
- Works seamlessly with Freezed
- Type-safe JSON conversion

**build_runner (^2.4.13)**
- Runs code generators for Freezed and JSON serialization
- Required dev dependency for build process

### Dependency Injection

**get_it (^8.0.0)**
- Simple service locator for dependency injection
- Lazy initialization support
- No code generation needed
- Easy to use and understand

### Testing

**mockito (^5.4.4)**
- Creates mock objects for unit testing
- Helps test code in isolation
- Generates mock classes automatically

## Project Structure

```
lib/
├── core/
│   ├── di/
│   │   └── injection.dart          # Dependency injection setup
│   └── network/
│       ├── api_client.dart         # Dio wrapper with error handling
│       └── connectivity_checker.dart # Connectivity checks
├── data/
│   ├── datasources/
│   │   ├── task_local_datasource.dart    # Hive storage
│   │   └── task_remote_datasource.dart   # API calls
│   ├── mock_data/
│   │   └── mock_tasks.dart         # Sample data
│   ├── repositories/
│   │   └── task_repository_impl.dart     # Repository implementation
│   └── services/
│       └── mock_data_service.dart  # Mock data management
├── domain/
│   ├── entities/
│   │   └── task.dart              # Task entity (Freezed)
│   └── repositories/
│       └── task_repository.dart   # Repository interface
└── presentation/
    ├── cubit/
    │   └── task_cubit.dart        # State management
    └── pages/
        ├── task_list_page.dart    # Main screen
        └── task_form_page.dart    # Create/edit screen
```

## Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Code Generation

After making changes to Freezed models or JSON serializable classes, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes automatically:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Network Configuration

The app currently uses simulated API calls for demonstration. To connect to a real API:

1. Update the `baseUrl` in `lib/core/di/injection.dart`
2. Replace the simulation logic in `lib/data/datasources/task_remote_datasource.dart` with actual API calls

The `ApiClient` class handles all HTTP operations, error handling, and connectivity checks automatically.

## Contributing

Feel free to submit issues or pull requests. Make sure to:
- Follow the existing code style
- Add tests for new features
- Update documentation as needed

## License

*Add your license here*

## Acknowledgments

Built with Flutter and following clean architecture principles. Thanks to all the open-source package maintainers who made this possible.
