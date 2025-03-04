# dietbot-backend
Backend codebase for the DietBot application.

This project, which is in progress, aims to create an emotionally conscious dietitian chatbot support system to help people with lifestyle diseases. 

## 🚀 Usage

Create a virtual environment and install the dependencies:

For the backend:
```bash
cd backend
python -m venv .venv
source venv/bin/activate
pip install -r requirements.txt
```
To run the backend:
```bash
uvicorn main:app --reload --port
```

To index your PDF documents in the data folder:

For CSV files:
```bash
cd data 
python embed.py
```

