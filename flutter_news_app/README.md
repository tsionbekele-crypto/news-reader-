# Flutter News Reader - Assignment 2 (Track B)

## Student Information
- **Name:** [Tsion Bekele]
- **Student ID:** [ATE/1224/15]
- **Course:** Mobile Application Development (Undergraduate)
- **Institution:** Addis Ababa University

## Project Description
A fully functional Flutter application that connects to the [NewsAPI.org](https://newsapi.org) REST API. The app allows users to browse top headlines from multiple countries and search for news articles by keyword. It implements robust error handling, immutable data models, and a clean service-oriented architecture.

### Key Features
- **Headlines by Country:** Interactive dropdown to switch news regions.
- **Global Search:** Keyword search across all global news sources.
- **Article Details:** Rich view of news content with external link support.
- **Robust Error Handling:** Specific UI feedback for timeouts, connection loss, and API errors.
- **Clean Architecture:** Separation of concerns between UI, Models, and Services.

## Setup Instructions

### 1. Requirements
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- NewsAPI account (Free key from [newsapi.org](https://newsapi.org))

### 2. Environment Configuration
API keys are handled securely and are NOT committed to version control.
1. Create a file named `.env` in the root of the project.
2. Add your API key using the following format:
   ```env
   NEWSAPI_KEY="YOUR_API_KEY_HERE"
   ```
3. Ensure `.env` is listed in your `.gitignore`.

### 3. Running the App
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter run` on a connected emulator or device.

## API Endpoints Used
- `GET /v2/top-headlines?country={cc}&apiKey={key}`: For the home screen.
- `GET /v2/everything?q={query}&apiKey={key}&pageSize=20`: For the search screen.

## Technical Highlights
- **Service Layer:** `NewsApiService` handles all HTTP logic with a consistent 10s timeout.
- **Model Layer:** `Article` model uses `factory fromJson` for safe parsing and `copyWith` for immutability.
- **State Management:** `FutureBuilder` is used to manage and display all 4 asynchronous states (waiting, error, data, no-data).
- **Error Handling:** Custom `ApiException` wrapper for structured error response propagation.

## Known Limitations
- Free tier of NewsAPI allows a limited number of requests per day.
- NewsAPI (Free) does not allow searching within the last hour in some regions.


