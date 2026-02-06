---
name: rust
description: Rust toolchain skill for cargo-based build, fmt, clippy, tests, and CI workflows.
---

# Rust Skill

Use this skill for Rust project workflows managed by cargo.

## Scope

- Cargo dependency and package lifecycle
- Formatting (`cargo fmt`) and linting (`clippy`)
- Build/check/test command patterns
- CI parity

## Guardrails

- Enforce `cargo fmt --check` and `clippy` in quality gates
- Prefer `cargo check` for fast iteration and `cargo test` for validation

## Guide

## Stack: Rust

## Package Manager

- **Tool**: cargo
- **Lock file**: `Cargo.lock`
- **Config**: `Cargo.toml`

## Commands

### Initialize Project

```bash
cargo new project-name
cargo init
```

### Add Dependencies

```bash
cargo add <crate>
cargo add --dev <crate>
```

### Format

```bash
cargo fmt
cargo fmt --check
```

### Lint

```bash
cargo clippy
cargo clippy -- -D warnings
```

### Typecheck / Build

```bash
cargo check
cargo build
cargo build --release
```

### Run Tests

```bash
# Quick run
cargo test

# Verbose
cargo test -- --nocapture

# Specific test
cargo test test_name

# Doc tests
cargo test --doc
```

### Run Application

```bash
cargo run
cargo run --release
```

## CI Pipeline (GitHub Actions)

```yaml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
        with:
          components: rustfmt, clippy
      - run: cargo fmt --check
      - run: cargo clippy -- -D warnings
      - run: cargo test
```

## File Structure

```text
project/
├── Cargo.toml
├── Cargo.lock
├── src/
│   ├── main.rs
│   └── lib.rs
├── tests/
│   └── integration_test.rs
└── benches/
    └── benchmark.rs
```
