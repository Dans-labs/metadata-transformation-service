import logging
import os
import sys

# Add the src directory to the Python path
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from contextlib import asynccontextmanager

import uvicorn
from akmi_utils import commons as a_commons
from fastapi import FastAPI, HTTPException, Depends, status, Request
from fastapi.responses import JSONResponse
from fastapi.security import HTTPBearer
from starlette.exceptions import HTTPException as StarletteHTTPException
from starlette.middleware.cors import CORSMiddleware
from src.mts import protected, public
from src.mts.commons import settings, initialize_xslt_proc, initialize_templates, data, project_details


api_keys = [
    settings.METADATA_TRANSFORMER_SERVICE_API_KEY
]  # Todo: This is encrypted in the .secrets.toml

security = HTTPBearer()

APP_NAME = os.environ.get("APP_NAME", project_details['title'])
EXPOSE_PORT = os.environ.get("EXPOSE_PORT", 1745)
OTLP_GRPC_ENDPOINT = os.environ.get("OTLP_GRPC_ENDPOINT", "http://localhost:4317")

def api_key_auth(api_key: str = Depends(security)):
    if api_key not in api_keys:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Forbidden"
        )

@asynccontextmanager
async def lifespan(application: FastAPI):
    logging.info('start up - lifespan')
    data.clear()
    initialize_templates()
    initialize_xslt_proc()
    yield

app = FastAPI(title=project_details['title'], description=project_details['description'],
              version=project_details['version'], lifespan=lifespan)

LOG_FILE = settings.LOG_FILE
log_config = uvicorn.config.LOGGING_CONFIG

if not settings.otlp_enable:
    logging.basicConfig(filename=LOG_FILE, level=settings.LOG_LEVEL,
                        format=settings.LOG_FORMAT)
else:
    a_commons.set_otlp(app, APP_NAME, OTLP_GRPC_ENDPOINT, LOG_FILE, log_config)

@app.exception_handler(StarletteHTTPException)
async def custom_404_handler(request: Request, exc: StarletteHTTPException):
    if exc.status_code == 404:
        logging.error(f"404 Not Found: {request.url}")
        return JSONResponse(
            status_code=404,
            content={"message": "Endpoint not found"}
        )
    logging.error(f"HTTP Exception: {exc.status_code} - {exc.detail}")
    return JSONResponse(
        status_code=exc.status_code,
        content={"message": exc.detail}
    )

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(
    public.router,
    tags=["Public"],
    prefix=""
)

app.include_router(
    protected.router,
    prefix="",
    dependencies=[Depends(api_key_auth)]
)

if __name__ == "__main__":
    logging.info("MTS: Starting the app __main__")
    uvicorn.run(app, host="0.0.0.0", port=EXPOSE_PORT, log_config=log_config)