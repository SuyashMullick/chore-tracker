# EqualChores – Chore & Habit Tracker

EqualChores is a mobile application that promotes equal distribution of chores and habits within households. It aims to encourage fairness, accountability, and engagement through gamification.

---

## Prerequisites

### Backend

1. Ensure you have Docker installed.
2. Navigate to the `backend/` directory.
3. Create a `.env` file using the provided example:

    `cp .env.example .env`

4. Generate a Django secret key using Python:
    - Run this command in your terminal:

        `python -c "import secrets; print(secrets.token_urlsafe(50))"`

5. Copy the output and place it in your .env file like so:

    `DJANGO_SECRET_KEY=fhKfh39r8-m98398293D32r79823d-329cd9cr3c2IfewfH  // Sample`

### Frontend

1. Install Android Studio: https://developer.android.com/studio

2. Set up the required SDKs and Android tools.

3. Create and configure an Android emulator (or use a physical Android device with USB debugging enabled).

## Running the Project


### Backend

To run the backend server:

1. Load the pre-built Docker image from the .tar file:

    `docker load -i equalchores-backend.tar`

2. Start the Docker container:

    `docker run --env-file backend/.env -p 8000:8000 equalchores-backend`

This will run the Django backend server on http://localhost:8000.

### Frontend

The recommended choice to run the project is installing the .apk file on an emulator or a physical android device. However, the frontend can be run on the web.

#### Installing the .apk file

To run the frontend app:

1. Start your Android emulator or connect a real device.

2. Install the prebuilt APK:

    `adb install path/to/app-release.apk`

3. Ensure adb is installed and accessible via terminal. It comes with the Android SDK Platform Tools.

#### Running on the web

1. To run the frontend app on the web, run the follwoing commands:

    `cd build/web`
    
    `python3 -m http.server 8080`

2. Open http://localhost:8080 in a browser.

## Building the Docker Image

If you want to build the Docker image yourself:

1. Navigate to the backend/ directory.

2. Run the following command:

    `docker build -t equalchores-backend .`

[Note: Building the image will take approximately 7–9 minutes, depending on your system.]