# RapidWeave - Config-Driven App Builder

RapidWeave is a scalable, dynamic config-driven Flutter application. It allows you to build completely dynamic UIs from JSON configurations without writing hardcoded views. With support for flexible themes (like Healthcare, Business, etc.) and adaptive layouts, RapidWeave is inherently pixel-perfect across Web, Tablet, and Mobile.

---

## 🎯 Key Features
- **Clean Architecture:** Strict separation of data, domain models, and presentation.
- **Config-Driven UIs:** Describe entire screens via JSON.
- **Dynamic RenderEngine:** Renders abstract config properties into physical widgets (`DynamicCard`, `DynamicForm`, `DynamicLayout`).
- **Runtime Theme engine:** Switch layouts and color schemes on the fly automatically based on the user's template.
- **Fully Responsive:** Gracefully scales components and handles stacked/grid layouts based on screen dimensions.

---

## 📂 Project Structure (Clean Architecture)

```text
lib/
├── config/                  # Global Configuration loaders
├── core/
│   ├── network/             # Generic Dio ApiService
│   ├── providers/           # Global Riverpod state Notifiers (Theme/Template)
│   ├── routes/              # GoRouter definitions
│   └── theme/               # ThemeEngine logic for parsing JSON themes
├── data/
│   └── repositories/        # Connects models to FileSystem (loads JSON) or APIs
├── domain/
│   └── models/              # Immutable config models (ScreenConfig, ThemeConfig)
├── features/
│   └── dynamic_screen/      # Core renderer screen (DynamicPage) orchestrator
└── shared/
    └── widgets/             # Library of smart reusable dynamic components
```

---

## 🎨 How Configurations & Templates Work

RapidWeave uses JSON documents placed inside `assets/configs/` to map out your application.

### 1. Adjusting Theme/Brand Colors
To modify styling, locate the `theme_[name].json` file. 
*Example: `assets/configs/theme_healthcare.json`*

You can change:
- **`lightColors`** / **`darkColors`**: Modify `primary`, `background`, `surface`, etc., using hex codes.
- **`fontFamily`**: RapidWeave automatically pulls fonts dynamically via Google Fonts (e.g., `"Inter"`, `"Outfit"`, `"Roboto"`).
- **`defaultSpacing`** & **`defaultBorderRadius`**: Defines global padding and corner roundness.

### 2. Modifying Screen Layouts
To change the structure of a page (e.g., Dashboard or Login), edit its corresponding JSON file.
*Example: `assets/configs/dashboard_config.json`*

#### Understanding `DynamicLayout`:
- **`type: "layout"`**: Use this component to group items.
- **`strategy`**: Set to `"adaptive"`, `"column"`, `"row"`, or `"grid"`.
- **`stackedOnMobile`: true**: Automatically stacks content in a column when running on a mobile screen if using row/grid strategies.

#### Example Component:
```json
{
  "type": "card",
  "properties": {
    "title": "Total Users",
    "value": "12,345",
    "style": "elevated"  // Can also be "solid" or "glass" (for glassmorphism UI)
  }
}
```

---

## 🚀 Adding New UIs or Features

### Adding a new Screen
1. Create a new config file in `assets/configs/` (e.g. `assets/configs/profile_config.json`).
2. Set the root ID equal to the filename (e.g. `"id": "profile"`).
3. If it requires navigation, add a route in `lib/core/routes/app_router.dart`:
   ```dart
   GoRoute(
     path: '/profile',
     builder: (context, state) => const DynamicPage(screenId: 'profile'),
   ),
   ```

### Creating & Mapping a New Custom Component
To expand the app builder's capability (e.g., adding a Video Player component):
1. Build the widget in `lib/shared/widgets/dynamic_video.dart`.
2. Open `lib/shared/widgets/dynamic_renderer.dart`.
3. Add a new `case 'video':` in the core switch expression.
4. Pass the properties via the config definitions to the newly attached widget!

---

## 🏃 Running the Application

Ensure Flutter dependencies are installed correctly.

1. Fetch modules:
   ```bash
   flutter pub get
   ```
2. Run on Web (Recommended for Testing Adaptive Resizing):
   ```bash
   flutter run -d chrome
   ```
3. Runtime testing: In the app's top app-bar, utilize the `Theme/Dark Mode` toggle to see live configuration switches without reloading!
