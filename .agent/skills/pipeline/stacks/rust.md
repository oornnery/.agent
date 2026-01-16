# Stack: Rust

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

```
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
