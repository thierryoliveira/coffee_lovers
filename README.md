# ☕ Coffee Lovers

A simple Flutter application that allows users to **discover random coffee images**, **favorite** the ones they love, and **access their favorites even when offline**.  
This project was built as part of a technical challenge for Very Good Ventures.

---

## ✨ Features

- Fetch a random coffee image from a public API
- Save the current image as favorite for offline access
- View a gallery of all previously favorited images
- Offline-first support for favorited images due to caching
- Clean architecture with Repository and Data Source layers
- State management using **Cubit (Bloc library)**

---

## 🧱 Architecture Overview
```
Presentation (Flutter UI + Cubits)
↓
Repository (Business Logic)
↓                    ↓
Remote Data Source    Local Data Source (Hive + cache)
(API requests)        (favorite image URLs)
```

---

## 🚀 Getting Started

### 1️⃣ Prerequisites

📌 This project is configured to use **FVM** for Flutter version management.

To install dependencies:

```sh
fvm flutter pub get
```

### 2️⃣ Running the App
```sh
fvm flutter run
```

### 3️⃣ Running Tests
```sh
fvm flutter test
```

## 🧪 Testing

The project contains Unit tests that ensure:
	•	Remote and local data layer behavior is correct
	•	State handling in Cubits works as expected
I would love to add a few golden tests as well (like a first try using the `alchemist` 🦄 instead of the usual `golden_tookit`), but I'm about to run out-of-time for sharing this project.

## Dependencies
* flutter_bloc: State management with Cubit
* http: Network requests
* hive: local persistence (favorite urls) - I took the opportunity to work by the first time with this specific dependency. Seems good :).
* cached_network_image: to deal with the image offline caching easily. There are multiple different ways to do the same, but it was pretty straightforward.

## 🔌 API

Images are fetched from:
```
https://coffee.alexflipnote.dev
```

The app uses the /random.json endpoint to retrieve image URLs.

## 📱 Platforms Supported
	•	iOS
	•	Android

No need for Desktop / Web support (as per challenge requirements).

## 🧹 Code Quality/Concerns
	•	Clear separation of concerns
	•	Bloc pattern for robust state flow
	•	Linter rules applied to enforce consistency

## 📄 Project Structure
```
lib/
 ├─ core/
 ├─ features/
 │   └─ coffee_image/
 │        ├─ data/
 │        ├─ domain/
 │        └─ presentation/
 └─ ...
 ```