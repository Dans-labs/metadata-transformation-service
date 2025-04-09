# Metadata Transformation Service (MTS)

![Python Version](https://img.shields.io/badge/python-3.8%2B-blue)
![FastAPI](https://img.shields.io/badge/FastAPI-0.68%2B-green)
[![License](https://img.shields.io/badge/license-MIT-orange)](LICENSE)
[![UV](https://img.shields.io/badge/packaging-UV-FFD43B)](https://github.com/astral-sh/uv)

The **Metadata Transformation Service (MTS)** is a high-performance FastAPI application designed for comprehensive metadata processing. It provides robust tools for transforming metadata across various formats including JSON, XML, and JSON-LD, with advanced XSLT management capabilities.

---

## ✨ Key Features

### 🔧 XSLT Management
- **Upload & Store**: Securely upload and store XSLT transformation files
- **List & Browse**: View all available XSLT transformations
- **Delete**: Remove unwanted or outdated transformations

### 🔄 Metadata Transformation
- **Multi-format Support**: Process JSON, XML, and JSON-LD inputs
- **XSLT Processing**: Apply complex transformations using stored XSLT files
- **Template-based**: Supports Jinja2 templates for flexible output generation

### 📊 RDF Conversion
- **JSON-LD to RDF**: Convert JSON-LD to various RDF formats:
  - RDF/XML
  - Turtle
  - N-Triples
  - N-Quads
  - Trig
  - JSON-LD (normalized)

### ⚡ UV Package Management
- **Blazing-fast installations** using UV (Rust-based Python package installer)
- **Modern dependency resolution** with conflict-free guarantees
- **Reduced installation times** through parallel downloads and caching

---

## 🛠 Installation

### Prerequisites
- Python 3.8+
- [UV](https://github.com/astral-sh/uv) (recommended for best performance)


### Setup with UV (Recommended)
1. Install UV (if not already installed):
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
    ```
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

