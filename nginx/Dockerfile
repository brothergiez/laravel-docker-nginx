# Use an official Nginx image as a base
FROM nginx:latest

# Copy your Nginx configuration file into the container
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
