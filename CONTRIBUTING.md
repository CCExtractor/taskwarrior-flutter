<!-- CONTRIBUTING -->

# Contributing to Taskwarrior Mobile App

Thanks for your interest in contributing! By participating you agree to follow
our [Code of Conduct](CODE_OF_CONDUCT.md).

## Setup

Get the app building and running locally first. Full instructions (FVM, the
pinned Flutter SDK, Android/iOS, optional Rust, and files you should not edit)
are in **[SETUP.md](SETUP.md)**.

If you get stuck or need help, ask on the
[Zulip community](https://ccextractor.org/public/general/support/).

## Ways to Contribute

Bug reports, feature ideas, docs, translations, tests, UI/UX feedback, and code
are all welcome.

## Issue-First Policy

> **Do not open a pull request unless there is an issue for it, and a
> maintainer has validated and assigned it to you.**

1. Open an issue (or find the existing one).
2. Wait for a maintainer to validate it and assign it to you.
3. Only then open a PR, linked to that issue.

Unsolicited PRs, especially large ones with no linked issue, may be closed
without review. Maintainers are listed in [AUTHORS.md](AUTHORS.md).

## Raising an Issue

Search existing issues first to avoid duplicates. Questions and general
discussion belong on [Zulip](https://ccextractor.org/public/general/support/),
not the issue tracker.

Open an issue using the matching template:

| Template | Use it for | Label |
| --- | --- | --- |
| **Bug Report 🐛** | Something is broken | `bug` |
| **Feature Request 🚀** | A new feature or improvement | `enhancement` |

**Bug Report:** describe the issue, steps to reproduce, expected result,
screenshots (optional), contact, and whether you want to work on it.

**Feature Request:** describe the idea, how you would implement it, mockups
(optional), contact, and whether you want to work on it.

Fill the template completely. Incomplete, duplicate, or out-of-scope issues may
be closed.

## Submitting a Pull Request

Once your issue is assigned to you:

1. Branch off the latest `main`:
   ```bash
   git checkout main && git pull
   git checkout -b fix/short-descriptive-name
   ```
2. Make your changes, then run the checks (see below).
3. Commit using the prefixes in [Commit Conventions](#commit-conventions).
4. Push and open the PR against **`main`**, filling in the
   [PR template](.github/pull_request_template.md). Link the issue with
   `Fixes #<issue_no>`; a linked issue is mandatory.
5. Respond to review. Stale or unassigned PRs may be closed.

PR template checklist:

- [ ] Tests have been added or updated to cover the changes
- [ ] Documentation has been updated to reflect the changes
- [ ] Code follows the established coding style guidelines
- [ ] All tests are passing

## Rules

- **Issue first, always.** No PR without an approved, assigned issue.
- **One issue, one PR.** Raise a separate issue for unrelated fixes.
- **Don't self-assign.** Wait for a maintainer to assign you.
- **Keep PRs small and focused.** Large "while I was in there" PRs will be
  asked to split.
- **Don't spam PRs.** Low-quality, trivial, or duplicate PRs will be closed.
- **Don't reformat unrelated code.** Keep the diff about the issue.
- **Don't commit generated files or build output** (see [SETUP.md](SETUP.md)).
- **No AI-generated spam.** You are responsible for every line you submit.
- **Test your change.** Run the app; "it compiles" is not enough.
- **Be civil and on-topic.** Prefer the issue/PR over DMs.

## Commit Conventions

Prefix commits and PR titles:

```
feat: a new feature
fix:  a bug fix
test: testing changes
docs: documentation changes
```

Branch names: `feature/<name>`, `fix/<name>`, or `docs/<name>`.

## Checks Before Pushing

```bash
fvm flutter analyze --no-fatal-warnings --no-fatal-infos
fvm flutter test
```

Match the surrounding code style. The project uses the GetX pattern (bindings /
controllers / views); see [docs/Architecture.md](docs/Architecture.md).

## Review Process

A maintainer triages and assigns the issue, reviews the PR once CI is green,
and merges it into `main`. Reviewers are volunteers, so please be patient.

---

Thank you for contributing! 💜
