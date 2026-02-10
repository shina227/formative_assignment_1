# ALU Student Academic Platform

## Overview

The ALU Student Academic Platform is a Flutter mobile application designed to help students manage assignments, academic sessions, and attendance through a single, unified dashboard. It enhances organization, tracks academic progress, and ensures timely awareness of upcoming responsibilities.

## Core Features

### Dashboard

- Displays current date and academic context
- Shows today’s sessions, upcoming assignments, attendance percentage, and pending tasks

### Assignments Management

- Create, edit, delete, and mark assignments as completed
- Track due dates and priority levels

### Session Scheduling

- Add, update, and remove academic sessions
- View weekly schedule overview

### Attendance Tracking

- Record present/absent status per session
- Automatic attendance percentage calculation
- Alert when attendance falls below 75%

### Navigation

- Bottom navigation between Dashboard, Assignments, and Schedule screens

## Project Architecture

The project follows a modular Flutter structure:

```
lib/
├── screens/   # Application UI screens
├── models/    # Data models and structures
├── services/  # State management and business logic
├── utils/     # Shared constants, colors, helpers
├── widgets/   # Reusable UI components
└── main.dart  # App entry point, theme, and routing
```

This architecture ensures clean separation of concerns, scalability, and maintainability.

## Setup & Installation

### Requirements

- Flutter SDK
- Android Studio or VS Code with Flutter extensions
- Emulator or physical mobile device

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/shina227/formative_assignment_1.git
   ```

2. Navigate into the project directory:

```bash
    cd formative_assignment_1
```

3. Install dependencies:

```bash
    flutter pub get
```

4. Run the application:

```bash
    flutter run
```

## Contribution Guidelines

- Each team member worked on a separate feature
- Changes were integrated using pull requests and code review
- Commits are clear, meaningful, and traceable
- All members contributed to implementation, documentation, and demo explanation

## Technologies Used

- Flutter (Dart)
- Provider state management
- Material Design UI components
- Git & GitHub collaboration

## Reflection Summary

The development process involved challenges in navigation, state management, UI consistency, and Git collaboration. Resolving these strengthened the team’s debugging ability, modular design thinking, and collaborative workflow practices.
