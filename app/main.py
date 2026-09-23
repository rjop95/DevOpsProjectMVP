from fastapi import FastAPI

app = FastAPI(title="MVP E-commerce DevOps", version="1.0.0", description="This is a simple MVP E-commerce application for DevOps demonstration.")

@app.get("/")
def read_root():
    return {"message": "Welcome to the MVP E-commerce DevOps application!"}

@app.get("/product")
def get_product():
    return {
        "id": 1,
        "name": "Camiseta DevOps",
        "price": 29.99,
        "availability": "In Stock",
        "currency": "USD",
        "stock": 100

    }