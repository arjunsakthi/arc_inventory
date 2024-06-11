# Arc Robotics Inventory App

The Arc Robotics Inventory App is designed to efficiently manage and track the inventory for the Arc Robotics team. It provides an intuitive interface to manage components, view inventory status, and update stock levels.

## Photos
<img src="https://github.com/arjunsakthi/arc_inventory/assets/75869725/9fcb624d-776a-4eb6-b20c-32e4dcdbb277" alt="App Screenshot" width="200"/>
<img src="https://github.com/arjunsakthi/arc_inventory/assets/75869725/7444d6c4-3f06-4ce6-8249-8f0b83200ca5" alt="App Screenshot" width="200"/>
<img src="https://github.com/arjunsakthi/arc_inventory/assets/75869725/c1e64786-c3d5-43cb-8a67-5c11225ea666" alt="App Screenshot" width="200"/>
<img src="https://github.com/arjunsakthi/arc_inventory/assets/75869725/e43d31d6-7eab-403c-a1fe-2599f975b884" alt="App Screenshot" width="200"/>
<img src="https://github.com/arjunsakthi/arc_inventory/assets/75869725/10bd75b3-b5b4-4757-8a59-f14bfdceae20" alt="App Screenshot" width="200"/>




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

## Internal Architecture and Functionality
Our Arc Robotics App is built to manage the inventory and tenant information efficiently using Firebase services. Here are the key components and functionalities:

### With Firebase Database:

### Tenant and Component Tracking: 
Maintains all information about the tenants and the components they borrowed, including date and time.
Data Modeling: Uses a model to store information in an easy-to-process and interpret format.
### Tenant Organization: 
Splits tenants based on the year, making the information more convenient to manage.
With Firebase Storage:
### Image Storage: 
Stores images of all members, logos, and blogs.
### Blog Management: 
Implements a strong and complex logic for downloading and previewing blogs in PDF format using an in-built PDF viewer with sufficient features.
### Member Section: 
Displays images from cloud storage as network images and shows positions underneath using a simple logic.
These features ensure robust data management and a user-friendly interface, enhancing the overall functionality and usability of the Arc Robotics App.

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
