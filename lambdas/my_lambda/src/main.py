from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse, JSONResponse
from mangum import Mangum
import os

if os.environ.get("AWS_EXECUTION_ENV", "").startswith("AWS_Lambda"):
    from mangum.lifespan import LifespanOff
    app.router.lifespan_context = LifespanOff()


app = FastAPI()

# Serve HTML (assuming it's embedded in your package or inline)
@app.get("/", response_class=HTMLResponse)
async def get_form():
    with open("index.html", "r", encoding="utf-8") as f:
        return HTMLResponse(content=f.read(), status_code=200)

# Handle form submission
@app.post("/index")
async def handle_form(username: str = Form(...), password: str = Form(...)):
    return JSONResponse(content={"username": username, "password": password})

# Create Lambda handler
handler = Mangum(app)
