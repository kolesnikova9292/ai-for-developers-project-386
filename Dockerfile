FROM node:20-alpine

WORKDIR /app

# Root dependencies (Prism mock API)
COPY package*.json ./
RUN npm ci --no-audit --no-fund

# Frontend dependencies
COPY frontend/package*.json ./frontend/
RUN cd frontend && npm ci --no-audit --no-fund

# Application sources
COPY . .

ENV PORT=4200
EXPOSE 4200

# Start mock API and frontend app
CMD ["sh", "-c", "npm run mock & cd frontend && npm run start -- --host 0.0.0.0 --port ${PORT}"]
