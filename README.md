# PalmBook Flutter App

A Flutter application for exploring and managing books from the Gutendex API. Supports search, detail view, like/unlike, and a favorites list, built with Clean Architecture and BLoC.

---

## ✨ Features

- **Book List**: Browse books from the Gutendex API.
- **Search**: Find books by title or author.
- **Book Detail**: View cover, author, description, and download count.
- **Like/Unlike**: Save or remove favorite books (locally stored).
- **Favorites List**: See all liked books.
- **Navigation**: Home, Detail, and Liked screens.
- **State Management**: Powered by BLoC (flutter_bloc).
- **Error Handling**: Handles API, connection, and cache errors.
- **Comprehensive Testing**: Unit, widget, and integration tests.

---

## 🛠️ Tech Stack

- **Flutter** (UI, cross-platform)
- **BLoC** (flutter_bloc) — state management
- **Clean Architecture** (data, domain, presentation separation)
- **Dartz** — functional programming (Either, Option)
- **GetIt** — dependency injection
- **Provider** — widget tree injection
- **SharedPreferences** — local storage (liked books)
- **HTTP** — Gutendex API access
- **CachedNetworkImage** — book cover images
- **Mockito, bloc_test** — testing

---

## 🏗️ Architecture

Clean Architecture with 3 main layers:
- **Data Layer**: Data sources (remote/local), models, repository implementations
- **Domain Layer**: Entities, repository contracts, (optionally use cases)
- **Presentation Layer**: BLoC, UI/widgets, events/states

State management uses the BLoC pattern. Dependency injection is handled by GetIt.

---

## 📁 Folder Structure

```
lib/
  core/                # Widgets, utils, theme, error, constants
  features/
    book/              # Main book features (list, search, detail)
      data/            # Data sources, models, repository impl
      domain/          # Entities, repository contracts
      presentation/    # BLoC, events, states, screens
    liked/             # Favorite books (local)
    detail/            # Book detail feature
  injection_container.dart
  app.dart
  main.dart
test/                  # Unit, widget, integration tests
```

---

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/VamosIna/palmbook.git
   cd palmbook
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Testing**
   - Generate mock files (once):
     ```bash
     flutter pub run build_runner build --delete-conflicting-outputs
     ```
   - Run all tests:
     ```bash
     flutter test
     ```

---

## 🧪 Testing

- **Unit Tests**: BLoC, repository, data source
- **Widget Tests**: UI components, state-based rendering
- **Integration Tests**: User flows, navigation, like/unlike
- All tests are scaffolded in the `test/` folder.

### Sample Test Results

Below is a sample output from running the test suite with mocks generated:

```
00:00 +0: BookBloc emits [BookLoading, BookLoaded] when FetchBooks is added and repository returns books
00:00 +1: BookBloc emits [BookLoading, BookEmpty] when FetchBooks is added and repository returns empty list
00:00 +2: BookBloc emits [BookLoading, BookError] when FetchBooks is added and repository returns failure
00:00 +3: LikedBloc emits [LikedLoading, LikedLoaded] when LoadLikedBooks is added and repository returns books
00:00 +4: LikedBloc emits [LikedLoading, LikedLoaded] when LoadLikedBooks is added and repository returns empty list
00:00 +5: LikedBloc emits [LikedLoading, LikedError] when LoadLikedBooks is added and repository returns failure
00:00 +6: DetailBloc emits [BookLiked(isLiked: true)] when CheckIfLiked is added and book is liked
00:00 +7: DetailBloc emits [BookLiked(isLiked: false)] when CheckIfLiked is added and book is not liked
00:00 +8: DetailBloc emits [DetailError] when CheckIfLiked is added and repository returns failure
00:00 +9: DetailBloc emits [LikeUpdating, BookLiked] when ToggleLike is added and repository returns success
00:00 +10: DetailBloc emits [LikeUpdating, DetailError] when ToggleLike is added and repository returns failure
00:00 +11: BookRepositoryImpl should return Right(List<Book>) when remote data source returns books
00:00 +12: BookRepositoryImpl should return Left(ServerFailure) when remote data source throws ServerException
00:00 +13: LikedRepositoryImpl should return Right(List<Book>) when local data source returns books
00:00 +14: LikedRepositoryImpl should return Left(CacheFailure) when local data source throws CacheException
00:00 +15: LikedRepositoryImpl should add book if not liked and return Right(void) on toggleLikeStatus
00:00 +16: LikedRepositoryImpl should remove book if already liked and return Right(void) on toggleLikeStatus
00:00 +17: LikedRepositoryImpl should return Left(CacheFailure) when local data source throws CacheException on toggleLikeStatus
00:00 +18: All tests passed!
```

---

## 🌐 API

- [Gutendex API](https://gutendex.com/) — book data source

---

## 👨‍💻 Credits

- Created by [VamosIna](https://github.com/VamosIna)
- Architecture, template, and testing by the development team

---

## 📄 License

MIT License
