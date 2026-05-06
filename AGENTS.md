# AGENTS.md — ISPM Attendance Flutter App

An attendance tracking system for educational institutions using QR code validation, built with Clean Architecture and BLoC state management.

## Architecture Overview

**Clean Architecture + BLoC Pattern** — Each feature follows 3 layers:
- `domain/` — Business logic (entities, abstract repositories, use cases)
- `data/` — External communication (repositories, DAOs, HTTP clients)
- `presentation/` — UI (pages, BLoCs, events, states, widgets)

**Shared Core** — `lib/core/` contains:
- `di/injection_container.dart` — GetIt service locator setup (run ONCE in `main()`)
- `config/app_config.dart` — Centralized API endpoint via `--dart-define=BASE_URL=...`
- `theme/app_theme.dart` — ISPMTheme.dark (login) / ISPMTheme.light (rest), ISPM green color scheme
- `presentation/widgets/` — Reusable UI components

**Key Features**:
- `auth/` — Login, biometrics, password change, JWT token storage
- `attendance/` — QR code scanning/generation, validation via Node.js API
- `schedule/` — Display professor's course schedule
- `stats/` — Attendance statistics and analytics
- `notifications/`, `profile/`, `admin/` — Additional modules

## Critical Workflows

### 1. App Initialization → Auth Check
```dart
// main.dart:main() calls:
await di.init();  // ← DI setup (once, in injection_container.dart)
runApp(ISPMApp());

// ISPMApp.build() -> MultiBlocProvider:
AuthBloc()..add(CheckAuthStatusEvent())  // ← Checks session at startup
```

**Flow**: `CheckAuthStatusEvent` → `_onCheckAuthStatus()` → checks `AuthRepository.getCurrentUser()` → emits `AuthAuthenticated`, `AuthRequiresPasswordChange`, or `AuthUnauthenticated`.

### 2. QR Validation Attendance Flow
```
Scanner Page → QrData (token:professorId:courseId)
           → AttendanceBloc.add(ValidateQrEvent(...))
           → repository.validateAttendance()
           → POST /api/attendance/validate (Bearer JWT)
           → Success: emit AttendanceValidationSuccess(professorData)
           → Error: emit AttendanceError(message)
```

### 3. State Management Registration
- **Singletons** (repositories, DAOs, HTTP clients) — `registerLazySingleton()`
- **Factories** (BLoCs) — `registerFactory()` — new instance per push/feature
- **Lazy** — instances created on first access

Key: **Always use `di.sl<Type>()` to resolve from GetIt**, never `new` directly.

## Dependency Injection Pattern

```dart
// injection_container.dart structure:
// 1. External packages (http.Client, FlutterSecureStorage)
// 2. DAOs (AuthLocalDao)
// 3. Repositories (interfaces → implementations)
// 4. BLoCs (via registerFactory)

// Usage in main.dart:
final authBloc = di.sl<AuthBloc>();

// ✅ DO: Get from container
sl.registerSingleton<MyService>(...);
final service = sl<MyService>();

// ❌ DON'T: Create directly
final service = MyService(...);
```

## API Integration & Security

**Backend**: Node.js REST API at `AppConfig.baseUrl` (default: `http://192.168.43.207:3000`)

**Override via CLI**:
```bash
flutter run --dart-define=BASE_URL=http://your-server:3000
```

**Authentication**:
- Login: POST `/api/auth/login` (email, password) → returns JWT token
- Token stored in `FlutterSecureStorage` under key `'jwt_token'`
- All requests use `Authorization: Bearer <jwt_token>` header
- First login trigger: `user.isFirstLogin = true` → force password change

**Error Handling**:
```dart
// Repositories catch HTTP errors and throw Exception(message)
// BLoCs catch and emit *Error state with cleaned message
if (response.statusCode != 200) {
  final errorData = jsonDecode(response.body);
  throw Exception(errorData['error'] ?? 'Generic error');
}
```

## Theme & Design System

**ISPMColors** (defined in `app_theme.dart`):
- Primary: `greenDark=#1E7A1E`, `green=#2EAA2E` (ISPM signature)
- Base: `black=#111111`, `grey900` (dark backgrounds)
- Semantic: `error=#D32F2F`, `success=#2EAA2E`
- Font: **Poppins** (all weights 500–800 in `assets/fonts/`)

**Theme Context**:
- Login page & auth screens → `ISPMTheme.dark` (wrapped via `Theme(data: ISPMTheme.dark, ...)`)
- App home & main screens → `ISPMTheme.light` (Material 3, light backgrounds)
- Transitions: fade + subtle 0.04px slide (280ms) in `_ispmPageRoute()`

## Event–State Pattern (BLoC)

Each feature BLoC follows:
```dart
// events/ — Immutable commands (use equatable if comparing):
class MyEvent extends Equatable { ... }

// states/ — Immutable result states:
abstract class MyState {}
class MyLoading extends MyState {}
class MySuccess extends MyState { final data; }
class MyError extends MyState { final message; }

// BLoC — Wire events to handlers:
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyInitial()) {
    on<MyEvent>(_onMyEvent);
  }
  Future<void> _onMyEvent(MyEvent event, Emitter<MyState> emit) async {
    emit(MyLoading());
    try {
      final result = await repository.fetch();
      emit(MySuccess(result));
    } catch (e) {
      emit(MyError(e.toString()));
    }
  }
}
```

## Data Persistence

- **JWT Token**: `FlutterSecureStorage` (Android Keystore, iOS Keychain)
- **Local SQL Data**: `sqflite` (prepared but not fully integrated in all features)
- **In-Memory**: BLoC state for current session

**Key Pattern**:
```dart
final jwtToken = await secureStorage.read(key: 'jwt_token');
if (jwtToken == null) throw Exception('Not authenticated');
// Use jwtToken in API header
```

## Build & Run

**Prerequisites**:
- Flutter 3.9.2+, Dart 3.9.2+
- Android SDK (gradle 8.x) or iOS toolchain

**Commands**:
```bash
flutter pub get                                              # Install deps
flutter run                                                 # Debug (default API)
flutter run --dart-define=BASE_URL=http://localhost:3000   # Custom API
flutter build apk --release                                 # Android release
flutter analyze                                             # Lint check
flutter test                                                # Run tests (minimal coverage)
```

**Device Orientation**: Portrait only (enforced in `main.dart` via `setPreferredOrientations`)

**Status Bar**: Transparent, light icons (dark app aesthetic)

## Common Patterns & Conventions

| Pattern | Example | Location |
|---------|---------|----------|
| **Enum-like States** | `AuthInitial()`, `AuthLoading()`, `AuthAuthenticated(user)` | `features/*/presentation/blocs/*_state.dart` |
| **Private BLoC Methods** | `_onLoginRequested()` named with underscore | `features/*/presentation/blocs/*_bloc.dart` |
| **Repository Abstraction** | `abstract class AuthRepository` in domain | `features/*/domain/repositories/*.dart` |
| **Entity Value Equality** | Use `Equatable` mixin for entities/events/states | All domain entities |
| **Error Messages** | Clean via `.replaceAll('Exception: ', '')` | BLoC emit handlers |
| **Config Injection** | Via `--dart-define` or `String.fromEnvironment()` | `lib/core/config/app_config.dart` |
| **Widget Tree Hierarchy** | `MultiBlocProvider` at app root → nested `BlocBuilder` in pages | `main.dart` + feature pages |

## When Adding a New Feature

1. **Create folder**: `lib/features/your_feature/{data,domain,presentation}/`
2. **Define entity** + **abstract repository** in `domain/`
3. **Implement repository** + **data source** (HTTP/storage) in `data/`
4. **Create BLoC** + events/states in `presentation/blocs/`
5. **Register in DI**: `injection_container.dart`
   ```dart
   sl.registerLazySingleton<YourRepository>(() => YourRepositoryImpl(...));
   sl.registerFactory(() => YourBloc(repository: sl()));
   ```
6. **Add provider** in `main.dart` MultiBlocProvider if global
7. **Create pages** + **widgets** in `presentation/pages/` and `presentation/widgets/`
8. **Add routes** in `main.dart` onGenerateRoute & routes map

## Testing Notes

- **Widget tests** in `test/widget_test.dart` (basic scaffolding)
- **Unit tests** for repositories + BLoCs recommended but not required
- **Run**: `flutter test`

## Codebase Statistics

- **Languages**: Dart (primary), Kotlin/Swift (Android/iOS wrappers)
- **Key Dependencies**: flutter_bloc, http, get_it, flutter_secure_storage, sqflite, qr_flutter, mobile_scanner
- **Lines of Code Request**: 3,000–5,000 (core + features)

---

**Last Updated**: 2026-05-06  
**Maintainers**: AI Agents + Development Team

