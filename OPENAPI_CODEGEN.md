# OpenAPI Code Generation

## 🚀 How to Run
Run the generation script from the root directory:
```sh
./codegen-tool/generate.sh
```

## 📦 What it Generates
The script updates the following files in `AlineaStockNews/Generated/`:
- **`Client.swift`**: The network client containing methods to call API endpoints (e.g., `fetchArticles`).
- **`Types.swift`**: The Swift structs and enums matching your API models (e.g., `Article`, `PaginatedResponse`).

## 📂 Needed Files
- **`openapi.json`**: The API specification file.
- **`openapi-generator-config.yaml`**: Configuration for the generator (access levels, naming strategy).
- **`codegen-tool/`**: Helper package containing the build script.
