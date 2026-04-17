# RapidWeave - Config-Driven App Builder

RapidWeave is a professional, template-first, config-driven Flutter application. It separates architectural "Brand Identities" (Native Templates) from dynamic content and style overrides (JSON), allowing for pixel-perfect, highly maintainable apps that scale across Web, Tablet, and Mobile.

---

## 🎯 Key Architecture
RapidWeave follows a **Hybrid-Dynamic Architecture**:
- **Hardcoded Soul (Templates):** Each template (Healthcare, Business) defines its signature aesthetic (curves, specific semantic colors, custom design tokens) in native code for maximum performance and "premium" feel.
- **Dynamic Skin (JSON Overrides):** Any brand property defined in assets can precisely override the template's defaults at runtime.
- **Config-Driven Logic:** Screen structures, form fields, and validation rules are entirely defined in JSON.

---

## 📂 Project Structure (Clean Architecture)

```text
lib/
├── core/
│   ├── providers/           # AppState, ThemeMode, and Template state
│   ├── theme/               # ThemeEngine (Material 3) & ThemeExtensions
├── data/
│   └── repositories/        # Loading JSON from assets/local storage
├── domain/
│   └── models/              # Immutable configs (ScreenConfig, ThemeConfig)
├── templates/               # Native Template definitions (Registry/Factory)
│   ├── healthcare/          # Specialized UI (MedicalAuthScreen, Hexagons)
│   ├── business/            # Specialized UI (BusinessAuthScreen, Liquid UI)
│   └── registry/            # Abstract contract for Templates
├── shared/
│   └── widgets/             # Reusable dynamic components (DynamicForm, LiquidButtons)
└── main.dart                # Application entry and ProviderScope
```

---

## 🎨 Design System & Workflow

The system uses a **Top-Down Merging Strategy**:
1. **Template Base**: The `TemplateFactory` provides the default `ThemeConfig` and `ThemeExtension` (e.g., glassmorphism tokens).
2. **JSON Override**: The `ConfigRepository` looks for `assets/configs/theme_{templateId}.json`.
3. **Merge**: The `app_state_provider` deep-merges the JSON values over the template defaults.
4. **Engine**: The `ThemeEngine` generates a cohesive `ThemeData` including semantic colors (Success, Info, Warning).

### 1. Adjusting Theme/Brand Colors
To modify styling for a specific template, edit:
*Example: `assets/configs/theme_healthcare.json`*

```json
{
  "lightColors": {
    "primary": "#00796B",
    "background": "#F1F8F7",
    "textPrimary": "#1B2F2A"
  },
  "defaultBorderRadius": 20.0
}
```

### 2. Modifying Screen Layouts & Forms
Screens are described in functional JSON files. 
*Example: `assets/configs/login_config.json`*

Forms are handled by the `DynamicForm` widget, which supports:
- **Field Types**: `email`, `password`, `text`, `phone`.
- **Validation Rules**: `required`, `email`, `min_length`, `match` (for password confirmation).
- **Responsive Logic**: Spacing, sizing, and visibility toggles are adapted per template.

---

## 🚀 Development Workflow

### Adding a New Template
1. Create a folder in `lib/templates/[new_template]`.
2. Implement the `TemplateRegistry` interface.
3. Define its **Brand Identity** (colors, typography, corners) in its `getThemeConfig()` implementation.
4. Register it in the `TemplateFactory`.

### Expanding the Design System
1. Add new semantic tokens to `ThemeColors` in `lib/domain/models/theme_config.dart`.
2. Map them to `ColorScheme` in `lib/core/theme/theme_engine.dart`.
3. (Optional) Add unique "Signature Tokens" (e.g. `brandAccent`) to `TemplateColors` extension in `lib/core/theme/template_theme_extension.dart`.

---

## 🏃 Running the Application

1. **Setup**: `flutter pub get`
2. **Launch**: `flutter run -d chrome` (Recommended for testing responsive scaling)
3. **Template Discovery**: Use the `activeTemplateProvider` in the UI to switch between Healthcare and Business themes live.

---

## 🛠 Tech Stack
- **Framework:** Flutter 3.x
- **State Management:** Riverpod 2.x
- **Animation:** flutter_animate
- **Theming:** Material 3 + ThemeExtensions
- **Routing:** GoRouter
- **Typography:** Google Fonts
