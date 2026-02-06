---
name: python-textual
description: Build terminal user interfaces with Textual, including app structure, widgets, reactive state, async work, and testing.
---

# Textual Skill

Use this skill for Python terminal applications with rich interactive UI.

## Documentation

- Textual Docs: <https://textual.textualize.io/>
- Textual CSS: <https://textual.textualize.io/guide/CSS/>
- Widgets Reference: <https://textual.textualize.io/widgets/>

## Scope

- Textual app structure and screen composition
- Widgets, layouts, and CSS styling
- Reactive state and message/event handling
- Background async tasks and safe UI updates
- Testing with Textual test utilities

## Install

```bash
uv add textual rich
```

## App Structure and Components

```python
from textual.app import App, ComposeResult
from textual.containers import Container, Horizontal, Vertical
from textual.reactive import reactive
from textual.widgets import (
    Button,
    DataTable,
    Footer,
    Header,
    Input,
    Log,
    ProgressBar,
    Static,
)


class UsersApp(App[None]):
    CSS_PATH = "app.tcss"
    BINDINGS = [
        ("q", "quit", "Quit"),
        ("r", "reload", "Reload"),
        ("ctrl+l", "clear_log", "Clear Log"),
    ]
    query = reactive("")

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        with Container(id="toolbar"):
            yield Input(placeholder="Search users...", id="search")
            yield Button("Reload", id="reload", classes="-primary")
        with Horizontal(id="content"):
            yield DataTable(id="users-table")
            with Vertical(id="side"):
                yield Static("Activity", classes="title")
                yield ProgressBar(total=100, id="progress")
                yield Log(id="activity-log", auto_scroll=True)
        yield Footer()
```

## `app.tcss` Logic (`CSS_PATH = "app.tcss"`)

`CSS_PATH` tells Textual to load a stylesheet from your app module directory.

- `CSS_PATH = "app.tcss"`: single stylesheet for the app.
- Keep IDs (`#id`) for structural layout and classes (`.class`) for reusable style.
- Prefer one root layout in `Screen` and keep widget-specific tweaks near their IDs/classes.

Example `app.tcss`:

```css
Screen {
  layout: vertical;
}

#toolbar {
  dock: top;
  height: 3;
  padding: 0 1;
  background: $surface;
}

#content {
  height: 1fr;
  layout: horizontal;
}

#users-table {
  width: 2fr;
}

#side {
  width: 1fr;
  border-left: round $accent;
  padding: 1;
}

.title {
  text-style: bold;
  margin-bottom: 1;
}

Button.-primary {
  background: $success;
  color: $text;
}
```

## Event and State Patterns

```python
from textual.widgets import Button, Input
from textual.app import App


class UsersApp(App[None]):
    query = reactive("")

    def watch_query(self, value: str) -> None:
        self.refresh_table(value)

    def on_input_changed(self, event: Input.Changed) -> None:
        if event.input.id == "search":
            self.query = event.value

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "reload":
            self.action_reload()
```

## Async Work Pattern

- Keep network and disk I/O outside `compose` and event handlers.
- Use workers/background jobs and update widgets after completion.

```python
import httpx
from textual import work
from textual.app import App


class UsersApp(App[None]):
    def action_reload(self) -> None:
        self.load_users()

    @work(thread=True, exclusive=True)
    def load_users(self) -> None:
        response = httpx.get("https://api.example.com/users", timeout=10.0)
        response.raise_for_status()
        self.call_from_thread(self.set_users, response.json())
```

## Minimal Test Pattern

```python
import pytest
from textual.widgets import Input


@pytest.mark.asyncio
async def test_app_search_input_exists() -> None:
    app = UsersApp()
    async with app.run_test() as pilot:
        await pilot.pause()
        assert app.query_one("#search", Input) is not None
```

## Guardrails

- Keep app state typed and explicit.
- Avoid blocking calls on the UI loop.
- Separate domain/service logic from widget event handlers.
- Keep keyboard bindings documented and consistent.
- Keep `app.tcss` as canonical layout source; avoid scattering layout rules in Python code.
