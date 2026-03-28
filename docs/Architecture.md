The architecture used in this project is [GetX Architecture](https://pub.dev/packages/get), which organizes the codebase into three core layers:

# How GetX Architecture Works

Each module in the project follows a consistent three-layer structure:

**Bindings** — Handles dependency injection. Each screen has a binding class that registers its controller before the view is loaded, ensuring everything is available when needed.

**Controllers** — The brain of each screen. Controllers manage state, business logic, and interactions with services. They extend `GetxController` and expose reactive variables that the view observes.

**Views** — Pure UI. Views observe the controller's state and rebuild only when relevant data changes. They contain no business logic.

Every module under `lib/app/modules/` follows this pattern:
```
module_name/
├── bindings/    # Dependency injection
├── controllers/ # State & business logic
└── views/       # UI widgets
```

## Key Rules

- Views should **never** directly call services — always go through the controller.
- Views should contain **zero business logic** — only render what the controller exposes.
- Controllers should **not** depend on other controllers.
- Controllers **may be reused** across views if they share the same functionality.
- Services are **globally accessible** and shared across all controllers.

## Architecture Diagram

![GetX Architecture](https://user-images.githubusercontent.com/81030284/191010071-7c71c4a9-5515-43c0-b3c9-0eabf9cf2544.png)

Since services are global, a multi-screen app shares them while each screen gets its own controller and view:

![Multi-screen structure](https://user-images.githubusercontent.com/81030284/191010185-83bad438-4852-449d-b8f8-b8ec18d3d193.png)

# Project Structure
```
lib/
├── app/
│   ├── models/
│   ├── modules/
│   │   ├── about/
│   │   ├── detailRoute/
│   │   ├── home/
│   │   ├── logs/
│   │   ├── manageTaskServer/
│   │   ├── manage_task_champion_creds/
│   │   ├── onboarding/
│   │   ├── permission/
│   │   ├── profile/
│   │   ├── reports/
│   │   ├── settings/
│   │   ├── splash/
│   │   └── taskc_details/
│   ├── routes/
│   ├── services/
│   ├── tour/
│   ├── utils/
│   │   ├── add_task_dialogue/
│   │   ├── app_settings/
│   │   ├── constants/
│   │   ├── debug_logger/
│   │   ├── gen/
│   │   ├── home_path/
│   │   ├── language/
│   │   ├── permissions/
│   │   ├── taskc/
│   │   ├── taskchampion/
│   │   ├── taskfunctions/
│   │   ├── taskserver/
│   │   └── themes/
│   └── v3/
│       ├── champion/
│       ├── db/
│       ├── models/
│       └── net/
├── rust_bridge/
└── main.dart
```

# Resources

- [GetX Package](https://pub.dev/packages/get)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [GetX State Management Guide](https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md)