# Dbnus - Jaspr Web App

Modern web application built with the [Jaspr](https://docs.jaspr.site/) web framework for Dart (Server-Side Rendering / Server Mode).

---

## 🚀 Prerequisites

1. **Dart SDK**: `^3.10.0`
2. **Jaspr CLI**: Install globally using:
   ```bash
   dart pub global activate jaspr_cli
   ```

---

## 🌍 Flavors & Environments

The application supports three environments managed via compile-time environment defines (`ENV`):

| Flavor | Environment Flag | Title |
|---|---|---|
| **Development** | `--dart-define=ENV=dev` | `Dev Dbnus` |
| **Staging** | `--dart-define=ENV=stg` | `Stg Dbnus` |
| **Production** (default) | `--dart-define=ENV=prod` | `Dbnus` |

---

## 🛠️ Running the Project

### Using the Jaspr CLI

Start the local development server with live reload:

```bash
# Development (Recommended for local dev)
jaspr serve --dart-define=ENV=dev

# Staging
jaspr serve --dart-define=ENV=stg

# Production
jaspr serve --dart-define=ENV=prod
```

The development server will be available at `http://localhost:8080`.

### Using VS Code

Launch configurations are pre-configured in `.vscode/launch.json`. Open the **Run and Debug** panel (`Ctrl+Shift+D` / `Cmd+Shift+D`) and select:
- `Jaspr (dev)`
- `Jaspr (stg)`
- `Jaspr (prod)`

---

## 📦 Building for Production

To build the standalone bundle for deployment:

```bash
# Build with environment define
jaspr build --dart-define=ENV=prod
```

The build output will be generated inside the `build/jaspr/` directory.

---

## 📂 Project Structure

```text
├── .vscode/             # VS Code launch & debugger settings
├── lib/
│   ├── app.dart         # Root component with routing
│   ├── flavors.dart     # Flavor configuration and environment loader
│   ├── main.client.dart # Client-side entrypoint
│   ├── main.server.dart # Server-side entrypoint
│   ├── core/            # Core utilities, API clients, configs & storage
│   ├── features/        # Feature modules (dashboard, bio_data, leader_board, order)
│   ├── navigation/      # Routing logic and route definitions
│   └── shared/          # Reusable UI components, extensions, theme & widgets
├── web/                 # Static web assets, styles, scripts, templates
└── pubspec.yaml         # Project dependencies and Jaspr configuration
```
