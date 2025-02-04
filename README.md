# Arc Robotics Inventory App 🚀

The **Arc Robotics Inventory App** is designed to streamline and optimize inventory management for the Arc Robotics team. It offers an intuitive interface for managing components, tracking inventory status, and updating stock levels in real-time. Whether you're tracking robotics components or updating stock levels, this app ensures efficient and organized inventory management. 📦

## Screenshots 📸

<p align="center">
  <img src="https://github.com/arjunsakthi/arc_inventory/assets/75869725/9fcb624d-776a-4eb6-b20c-32e4dcdbb277" alt="App Screenshot" width="200"/>
  <img src="https://github.com/arjunsakthi/arc_inventory/assets/75869725/7444d6c4-3f06-4ce6-8249-8f0b83200ca5" alt="App Screenshot" width="200"/>
  <img src="https://github.com/arjunsakthi/arc_inventory/assets/75869725/c1e64786-c3d5-43cb-8a67-5c11225ea666" alt="App Screenshot" width="200"/>
  <img src="https://github.com/arjunsakthi/arc_inventory/assets/75869725/e43d31d6-7eab-403c-a1fe-2599f975b884" alt="App Screenshot" width="200"/>
  <img src="https://github.com/arjunsakthi/arc_inventory/assets/75869725/10bd75b3-b5b4-4757-8a59-f14bfdceae20" alt="App Screenshot" width="200"/>
</p>

## Key Features 🌟

- **Efficient State Management**: 📱 Uses Riverpod for scalable and maintainable state management.
- **Firebase Authentication**: 🔒 Secure login and registration system powered by Firebase.
- **Real-time Database Integration**: 🔄 Seamless synchronization with Firebase Realtime Database for live updates.
- **Smooth UI/UX**: 🎨 Elegant and polished design with smooth transitions and animations.
- **Intuitive Interface**: 🖥️ User-friendly interface designed to simplify tasks and enhance the overall experience.

## Folder Structure 🗂️

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

## Architecture & Functionality 🏗️

### Firebase Integration 🔥:

- **Tenant & Component Tracking**: 📦 Tracks all tenant details and the components they have borrowed, including date and time.
- **Data Modeling**: 🗂️ Organizes data into structured models for easy processing.
- **Tenant Organization**: 🏢 Tenants are grouped by the year, improving organization and data management.

### Firebase Storage Integration 💾:

- **Image Storage**: 🖼️ Manages member images, team logos, and other important visuals via Firebase Storage.
- **Blog Management**: 📑 Supports downloading and previewing PDF blogs with an integrated PDF viewer.
- **Member Management**: 🧑‍🤝‍🧑 Displays member images stored on the cloud along with their positions.

These features provide a robust, scalable solution for inventory management while offering a seamless user experience. 🌈

## Installation 🛠️

To get started with the Arc Robotics Inventory App, follow these steps:

1. **Clone the repository**:
   ```sh
   git clone https://github.com/arjunsakthi/arc_inventory.git
   ```

2. **Navigate to the project directory**:
   ```sh
   cd arc_inventory
   ```

3. **Install dependencies**:
   ```sh
   flutter pub get
   ```

4. **Run the app**:
   ```sh
   flutter run
   ```

## Configuration 🔑

Before running the app, ensure you set up Firebase for your project:

1. Create a Firebase project and configure Firebase for your platform (iOS/Android).
2. **For Android**: Add the `google-services.json` file to the `android/app` directory.
3. **For iOS**: Add the `GoogleService-Info.plist` file to the `ios/Runner` directory.

## Usage 🎮

To use the app, you need to have **Flutter** installed on your machine. Follow the installation instructions above to get the app up and running on your local machine or emulator.

## License 📜

This project is licensed under the MIT License. For more details, see the [LICENSE](LICENSE) file.
