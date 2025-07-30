# Use the official Flutter Docker image as base
FROM ghcr.io/cirruslabs/flutter:3.16.0 AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the source code
COPY . .

# Enable web platform and build
RUN flutter config --enable-web
RUN flutter build web --release --web-renderer html

# Use nginx to serve the built web app
FROM nginx:alpine

# Copy built web files to nginx html directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]