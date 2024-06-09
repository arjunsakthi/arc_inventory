# Arc Robotics Inventory App

The Arc Robotics Inventory App is designed to efficiently manage and track the inventory for the Arc Robotics team. It provides an intuitive interface to manage components, view inventory status, and update stock levels.

## Photos



## Features

- **State Management**: Used Riverpod for efficient state management.
- **Authentication**: Powered by Firebase for secure login and registration.
- **Backend Integration**: Fully integrated with Firebase for real-time database synchronization.
- **UI/UX Design**: Nice looking UI/UX with smooth animations.
- **User-Friendly Interface**: Simple and intuitive interface for ease of use.

## Folder Structure

```plaintext
├── assets
│   ├── images
│   
├── lib
│   ├── models
│   ├── screens
│   ├── utils
│   ├── docs
│   ├── resources
|   |   ├─ database
|   |   ├─ providers
│   └── widgets
└── test
```

### Assets
Contains images and icons used in the app.

### Models
Holds data model classes representing inventory items and user data.

### Providers
Manages state using Riverpod.

### Repositories
Handles data operations and interactions with Firebase Firestore.

### Screens
Contains the UI screens of the app.

### Utils
Utility classes and functions for general purposes.

### Widgets
Reusable UI components used across different screens.

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/arc-robotics-inventory-app.git
   ```
2. Navigate to the project directory:
   ```sh
   cd arc-robotics-inventory-app
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## Configuration

1. Set up Firebase for your project.
2. Add `google-services.json` to the `android/app` directory.
3. Add `GoogleService-Info.plist` to the `ios/Runner` directory.

## Usage

To use this app, you need to have Flutter installed on your machine. Follow the installation instructions above to set up the project and run it on your device or emulator.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to replace `yourusername` with your actual GitHub username and add any additional information as needed.
