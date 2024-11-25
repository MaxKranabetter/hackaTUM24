from fastapi import FastAPI
from src.application.routers import user_router, activity_router

app = FastAPI()

app.include_router(user_router.router)
app.include_router(activity_router.router)

@app.get("/")
def read_root():
    return {"message": "Welcome to the FastAPI DDD example"}
