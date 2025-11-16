FROM python:3.10-slim

# सिस्टम dependencies install
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    gcc \
    libffi-dev \
    ffmpeg \
    aria2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Workdir set
WORKDIR /app

# Requirements पहले copy करो ताकि cache use हो सके
COPY requirements.txt .

# Python dependencies install
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir pytube gunicorn

# बाकी code copy
COPY . .

# Environment variables
ENV COOKIES_FILE_PATH="/app/youtube_cookies.txt"

# CMD
CMD ["sh", "-c", "gunicorn app:app --bind 0.0.0.0:8000 & python3 main.py"]
