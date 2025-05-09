# Flutter Clean Architecture & TDD Practice

This Flutter project is a work-in-progress based on the YouTube playlist: [Clean Architecture & TDD - Reso Coder](https://www.youtube.com/watch?v=KjE2IDphA_U&list=PLB6lc7nQ1n4iYGE_khpXRdJkJEp9WOech). The goal of this project is to learn and apply Clean Architecture principles, Test-Driven Development (TDD), and best practices for scalable Flutter applications.

## 🚀 Project Goals

* Understand the structure of Clean Architecture in a Flutter context
* Practice writing unit, widget, and integration tests
* Learn to separate concerns via layers: `Presentation`, `Domain`, and `Data`
* Implement Dependency Injection and SOLID principles


## 🔗 Architecture Overview

```
lib/
├── core/              # Shared code like error handling and utilities
├── features/          # Feature-specific folders
│   └── number_trivia/ # Example feature from the tutorial
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## 📊 Tech Stack

* Flutter
* Dart
* Mockito
* Equatable
* Dartz (functional programming helpers)
* TDD (Test-Driven Development)
* Clean Architecture

## 📚 Learning Source

* 📺 YouTube Playlist: [Clean Architecture TDD in Flutter by Reso Coder](https://www.youtube.com/watch?v=KjE2IDphA_U&list=PLB6lc7nQ1n4iYGE_khpXRdJkJEp9WOech)
* 📘 [Reso Coder Blog](https://resocoder.com/clean-architecture-tdd/)

## 📄 License

This project is intended for learning and practice purposes. Credit to Reso Coder for the tutorial content.

---
