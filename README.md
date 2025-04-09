# 🚀 Metadata Transformation Service (MTS)

![Python Version](https://img.shields.io/badge/python-3.8%2B-blue)
![FastAPI](https://img.shields.io/badge/FastAPI-0.68%2B-green)
[![License](https://img.shields.io/badge/license-MIT-orange)](LICENSE)
[![UV](https://img.shields.io/badge/packaging-UV-FFD43B)](https://github.com/astral-sh/uv)

The **Metadata Transformation Service (MTS)** is a high-performance FastAPI application for transforming and managing metadata across multiple formats. It supports advanced XSLT handling, Jinja2 templating, and RDF conversions — all packaged in a lightweight, blazing-fast API.

---

## ✨ Features

### 🔧 XSLT Management
- **Upload & Store** — Securely upload and store XSLT transformation files.
- **List & Browse** — View and organize available XSLT transformations.
- **Delete** — Remove outdated or unnecessary transformations.

### 🔄 Metadata Transformation
- **Multi-Format Support** — Process metadata in JSON, XML, and JSON-LD.
- **XSLT Processing** — Apply powerful XSLT transformations to XML data.
- **Jinja2 Templates** — Generate flexible output using customizable templates.

### 🌐 RDF Conversion
- **From JSON-LD to RDF** — Seamlessly convert JSON-LD into RDF formats:
  - RDF/XML
  - Turtle
  - N-Triples
  - N-Quads
  - Trig
  - Normalized JSON-LD

### ⚡ Lightning-Fast Dependency Management with UV
- **Rust-powered** installations using [UV](https://github.com/astral-sh/uv).
- **Fast & Modern** resolution of dependencies with conflict avoidance.
- **Parallel Downloads** and caching for drastically reduced setup times.

---

## 🛠 Installation

### Prerequisites
- Python 3.8 or newer
- [UV](https://github.com/astral-sh/uv) (recommended)

### 🚀 Quick Start with UV (Recommended)

1. **Install UV**:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh

2. Clone the repository:
   ```bash
   git clone https://github.com/your-organization/metadata-transformation-service.git
   cd metadata-transformation-service
    ```
3. Create virtual environment and install dependencies:
    ```bash
   uv venv .venv
   source .venv/bin/activate  # On Windows use `.venv\Scripts\activate`
   uv sync
    ```
4. Run the application: 
    ```bash
    uv run main.py
     ```
5. Access the API at `http://localhost:1745/docs` for Swagger UI.
6. Access the API at `http://localhost:1745/redoc` for ReDoc UI.
7. Access the API at `http://localhost:1745/openapi.json` for OpenAPI JSON.

