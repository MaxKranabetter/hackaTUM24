from fastapi import APIRouter, HTTPException, Depends
from src.domain.models.activity import ActivityModel
from src.infrastructure.database import activity_collection
from bson import ObjectId

router = APIRouter(prefix="/activity", tags=["Activity"])

@router.post("/")
async def create_activity(activity: ActivityModel):
    activity_data = activity.dict()
    result = await activity_collection.insert_one(activity_data)
    return {"id": str(result.inserted_id)}

@router.get("/{activity_id}")
async def get_activity(activity_id: str):
    activity = await activity_collection.find_one({"_id": ObjectId(activity_id)})
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    activity["id"] = str(activity["_id"])
    del activity["_id"]
    return activity

@router.put("/{activity_id}")
async def update_activity(activity_id: str, activity: ActivityModel):
    updated_data = activity.dict(exclude_unset=True)
    result = await activity_collection.update_one(
        {"_id": ObjectId(activity_id)}, {"$set": updated_data}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Activity not found")
    return {"message": "Activity updated successfully"}

@router.delete("/{activity_id}")
async def delete_activity(activity_id: str):
    result = await activity_collection.delete_one({"_id": ObjectId(activity_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Activity not found")
    return {"message": "Activity deleted successfully"}
