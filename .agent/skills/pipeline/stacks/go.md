# Stack: Go

## Package Manager
- **Tool**: go mod
- **Lock file**: `go.sum`
- **Config**: `go.mod`

## Commands

### Initialize Module
```bash
go mod init github.com/user/project
```

### Add Dependencies
```bash
go get <package>
go mod tidy
```

### Format
```bash
go fmt ./...
gofmt -w .
```

### Lint
```bash
go vet ./...
golangci-lint run
```

### Typecheck
Go is statically typed, so compile = typecheck:
```bash
go build ./...
```

### Run Tests
```bash
# Quick run
go test ./...

# Verbose
go test -v ./...

# Coverage
go test -cover ./...
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

### Run Application
```bash
go run .
go run cmd/app/main.go
```

### Build
```bash
go build -o bin/app .
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
      - uses: actions/setup-go@v5
        with:
          go-version: '1.22'
      - run: go mod download
      - run: go fmt ./...
      - run: go vet ./...
      - uses: golangci/golangci-lint-action@v4
      - run: go test -v ./...
```

## File Structure

```
project/
├── go.mod
├── go.sum
├── main.go
├── cmd/
│   └── app/
│       └── main.go
├── internal/
│   ├── handler/
│   └── service/
└── pkg/
    └── utils/
```
