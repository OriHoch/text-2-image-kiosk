from fastapi import FastAPI, Request
from starlette.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse, FileResponse


app = FastAPI()
templates = Jinja2Templates(directory="templates")


app.mount("/assets", StaticFiles(directory="assets"), name="assets")


@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    return FileResponse("assets/favicon.ico")


@app.get("/", response_class=HTMLResponse, include_in_schema=False)
async def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})
