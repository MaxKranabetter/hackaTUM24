from fastapi import APIRouter, HTTPException, Depends
from src.domain.models.user import UserModel
from src.infrastructure.database import user_collection
from bson import ObjectId

router = APIRouter(prefix="/user", tags=["User"])

@router.post("/")
async def create_user(user: UserModel):
    user_data = user.model_dump()
    result = await user_collection.insert_one(user_data)
    return {"id": str(result.inserted_id)}

@router.get("/{user_id}")
async def get_user(user_id: str):
    user = await user_collection.find_one({"_id": ObjectId(user_id)})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user["id"] = str(user["_id"])
    del user["_id"]
    return user

@router.put("/{user_id}")
async def update_user(user_id: str, user: UserModel):
    updated_data = user.dict(exclude_unset=True)
    result = await user_collection.update_one(
        {"_id": ObjectId(user_id)}, {"$set": updated_data}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="User not found")
    return {"message": "User updated successfully"}

@router.delete("/{user_id}")
async def delete_user(user_id: str):
    result = await user_collection.delete_one({"_id": ObjectId(user_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="User not found")
    return {"message": "User deleted successfully"}
