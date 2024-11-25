## **Backend for City-of-Munich**
Backend for the city-of-munich challenge of HackaTUM 2024.
Technologies used:
- MongoDB
- FastAPI

### **Setup Steps**

#### 1. Clone the Repository
```bash
git clone <repository-url>
cd <repository-folder>
```

#### 2. Create and Activate a Virtual Environment
Run the following command to create and set up the virtual environment:
```bash
make create_venv
```
This will:
- Create a virtual environment in the `venv` directory.
- Install dependencies from `requirements.txt`.

To manually activate the virtual environment later:
- **Linux/macOS**:
  ```bash
  source venv/bin/activate
  ```
- **Windows**:
  ```bash
  venv\Scripts\activate
  ```

#### 3. Save Dependencies
After installing new dependencies, save them to `requirements.txt` with:
```bash
make save_requirements
```

#### 4. Configure Environment Variables
Create a `.env` file in the project root with the following content:
```env
MONGO_USER=<your_mongo_user>
MONGO_PASSWORD=<your_mongo_password>
MONGO_CLUSTER=<your_mongo_cluster_url>
MONGO_DB=fastapi_example
```
Replace placeholders with your MongoDB Atlas credentials.

#### 5. Start the Application
Run the following command to start the FastAPI server:
```bash
make start
```

Access the application at:
- **Base URL**: `http://127.0.0.1:8000`
- **Swagger Docs**: `http://127.0.0.1:8000/docs`

---

### **Makefile Commands**

| Command               | Description                                          |
|-----------------------|------------------------------------------------------|
| `make create_venv`    | Creates and activates a virtual environment, installs dependencies. |
| `make start`          | Starts the FastAPI server (`uvicorn src.main:app --reload`). |
| `make save_requirements` | Saves installed dependencies to `requirements.txt`. |
| `make install_requirements` | Installs dependencies from `requirements.txt`. |
| `make activate`       | Activates the virtual environment (Linux/macOS only). |
| `make remove_venv`    | Removes the virtual environment for cleanup.          |

---

### **Common Issues**

1. **Environment Variables Missing**:
   - Ensure `.env` exists in the root directory and contains valid MongoDB credentials.

2. **Dependencies Not Installed**:
   - Run `make install_requirements` to reinstall all dependencies.

3. **MongoDB Connection Issues**:
   - Verify MongoDB credentials and ensure your IP is whitelisted in MongoDB Atlas settings.

---

You’re ready to go! Use `make start` to run the application and start building! 🚀