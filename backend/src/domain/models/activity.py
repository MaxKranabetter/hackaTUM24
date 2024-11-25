from pydantic import BaseModel, Field
from datetime import datetime
from src.domain.models.user import UserModel

# Timestamps: milliseconds since epoch

class ActivityLocation(BaseModel):
    lon: float
    lat: float
    radius: float

class ActivityTimerange(BaseModel):
    startTime: int
    endTime: int

class ActivityModel(BaseModel):
    description: str
    minUsers: str
    maxUsers: int
    timerange: ActivityTimerange
    location: ActivityLocation
    joinedUsers: list[UserModel]
    createdAt: datetime = Field(default_factory=datetime.utcnow)
    updatedAt: datetime = Field(default_factory=datetime.utcnow)
