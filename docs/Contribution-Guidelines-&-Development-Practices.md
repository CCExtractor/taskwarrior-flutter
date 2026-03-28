# Contribution Guidelines

You can contribute to **Taskwarrior-Flutter** by:

- Reporting issues or bugs you find.
- Proposing improvements to the project.
- Forking the repository, modifying the code, and creating a Pull Request (PR).

Check [CONTRIBUTING.md](https://github.com/CCExtractor/taskwarrior-flutter/blob/main/CONTRIBUTING.md) for more details.

---

## Commit conventions

When opening PRs, **please specify the commit type** using the following conventions:

| Type | Description |
|------|-------------|
| `feat` | A new feature you're proposing |
| `fix` | A bug fix in the project |
| `style` | UI/UX improvements or styling updates |
| `test` | Testing-related updates |
| `docs` | Documentation updates |
| `refactor` | Code refactoring and maintenance |

---

## Development Practices

**Flutter Version**

Use **Flutter 3.29.2** or later for development (documentation updated 23 Feb 2026):
```text
Flutter 3.29.2 • channel stable
Framework • revision 90673a4eef • 2026-02-18 (framework revision date)
Dart 3.7.2 • DevTools 2.42.3 • released 2025-03-12
```

**File Naming Convention**

The project follows [snake_case](https://en.wikipedia.org/wiki/Snake_case) naming — this must be followed without fail.

**Examples** :
* File names   : services_info.dart, dev_api_service.dart, home_view.dart
* Folder names : api, disk_explorer, smart_widgets

**UI/UX Constants**

Colors, dimensions, and any UI constants must be defined in the respective theme file:
`/lib/app/utils/themes/themes.dart`

**Documentation**

Document all functions, classes, and logic you implement. Follow the [Effective Dart Documentation](https://dart.dev/guides/language/effective-dart/documentation) guidelines without fail.

---

## Community

Join the CCExtractor community on **Zulip** to propose improvements and connect with other contributors.

- 💬 [Join CCExtractor on Zulip](https://ccextractor.org/public/general/support)