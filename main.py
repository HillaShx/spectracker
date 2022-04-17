import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI

from routers.users import router as users_router

load_dotenv()
app = FastAPI()


@app.get("/ping")
def health_test():
    return {"status": "ok"}


app.include_router(users_router)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
