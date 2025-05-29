# Use the official Flutter SDK image
FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

COPY pubspec.* ./

# Run pub get
RUN flutter pub get

COPY . .

# (Optional) Build the app for Android
RUN flutter build apk

# Run the app
CMD ["/bin/bash"]
