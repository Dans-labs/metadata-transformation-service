# 🚀 Metadata Transformation Service (MTS)

![Python Version](https://img.shields.io/badge/python-3.8%2B-blue)
![FastAPI](https://img.shields.io/badge/FastAPI-0.68%2B-green)
[![License](https://img.shields.io/badge/license-MIT-orange)](LICENSE)
[![UV](https://img.shields.io/badge/packaging-UV-FFD43B)](https://github.com/astral-sh/uv)

The **Metadata Transformation Service (MTS)** is a high-performance FastAPI application for transforming and managing metadata across multiple formats. It supports advanced XSLT handling, Jinja2 templating, and RDF conversions — all packaged in a lightweight, blazing-fast API. MTS ensures compatibility with various repository standards, facilitating seamless metadata interoperability and content migration. By leveraging robust transformation technologies, it enables efficient, scalable integration across heterogeneous repository systems.

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

---

## 🎯 Running from PyCharm

### Setup

1. **Open the project in PyCharm:**
   - File → Open → `/Users/akmi/dev/work/dans/odissei-acp-poc`

2. **Configure Python Interpreter:**
   - PyCharm → Preferences (or File → Settings)
   - Project → Python Interpreter
   - Click ⚙️ → Add
   - Select "Existing Environment"
   - Choose: `/Users/akmi/dev/work/dans/odissei-acp-poc/services/mts/.venv/bin/python`
   - Click OK

3. **Install Dependencies:**
   - Open Terminal in PyCharm (View → Tool Windows → Terminal)
   - Run:
     ```bash
     cd services/mts
     uv sync
     ```

### Create Run Configuration

1. **Run → Edit Configurations...**
2. **Click + → Python**
3. **Fill in the following:**
   - **Name:** `MTS (Local)`
   - **Module name:** `src.main` (⚠️ NOT Script path)
   - **Working directory:** `/Users/akmi/dev/work/dans/odissei-acp-poc/services/mts`
   - **Python interpreter:** Select the MTS venv you set up above
   - **Environment variables:**
     ```
     BASE_DIR=/Users/akmi/dev/work/dans/odissei-acp-poc/services/mts;
     PYTHONPATH=/Users/akmi/dev/work/dans/odissei-acp-poc/services/mts;
     EXPOSE_PORT=1745;
     OTLP_GRPC_ENDPOINT=http://localhost:4317
     ```

4. **Click Apply → OK**

### Run MTS

- Click the **Run** button (▶️) or press **Ctrl+R** (macOS: **Cmd+R**)
- MTS will start on **http://localhost:1745**
- Swagger UI: **http://localhost:1745/docs**
- ReDoc UI: **http://localhost:1745/redoc**

### Debug Mode

- Click the **Debug** button (🐛) instead of Run to step through code
- Set breakpoints by clicking in the gutter next to line numbers

### Troubleshooting

- **ModuleNotFoundError: No module named 'src.mts'?**
  - Make sure you're using **Module name** `src.main`, NOT **Script path**
  - Verify **Working directory** is set to the `services/mts` folder

- **Port already in use?**
  - Change `EXPOSE_PORT` in environment variables to a different port (e.g., 1746)

- **Dependencies not found?**
  - Ensure Python interpreter is the MTS venv (check status bar at bottom-right)
  - Run `uv sync` again in the terminal

---
