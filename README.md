# Posts & Details

Build a Flutter app that fetches data from a public REST API, uses a modular architecture, and manages state with a predictable pattern. Prioritize clean code, separation of concerns, and solid UX for loading/error states.

- **Timebox**: 1 week focused work
- **State Management**: BLoC/Cubit
---

## Problem Statement
Create a "Posts & Details" app backed by `https://jsonplaceholder.typicode.com`.

### Core Features
1) **List Posts**
   - Fetch posts from `/posts`
   - Show list with title and a short preview of the body
   - Pull-to-refresh to re-fetch

2) **Post Details**
   - On tap, navigate to a details screen
   - Show full title, body
   - Fetch and display post author (from `/users/:id`) and number of comments (from `/posts/:id/comments`)

3) **Loading, Error, Empty States**
   - Show appropriate UI for loading
   - Display and recover from errors (e.g., retry)
   - Handle empty list or no results

---

## Architecture Requirements
- Use a clear, layered structure:
- Abstract API calls behind a repository; the UI should not depend on HTTP details
- Keep widgets small and focused; avoid business logic in UI code
- Prefer dependency injection (e.g., simple constructors, or a lightweight locator)

---

## State Management Requirements
- Use exactly one primary approach: **BLoC/Cubit**
- Represent states explicitly (e.g., loading/success/error) and model transitions
---

## API & Data Requirements
- Use `http` (or `dio`) with proper error handling and timeouts
- Parse JSON into typed models
- Add minimal mapping between DTOs and domain models (if you separate layers)

---

## Testing (Minimum)
- At least 1-2 meaningful tests, e.g.:
  - Repository: returns parsed models and propagates failures
  - State management: transitions for load success/error
  - Widget test: renders loading and then list on success (mock repository)

---

## Nice-to-Have (Optional)
- Basic search/filter on the list (client-side)
- Pagination or "load more"
- Theming and dark mode support

---

## Submission Checklist
- [ ] App runs with `flutter run`
- [ ] Tests run with `flutter test` and pass locally
- [ ] No hard-coded secrets; API base URLs configurable if needed

[:arrow_left: Go back to main branch](https://github.com/OttrTechnology/flutter-assessment#getting-started)
