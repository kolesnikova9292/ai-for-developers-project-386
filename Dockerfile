FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=development
ENV NPM_CONFIG_PRODUCTION=false

# Root dependencies (Prism mock API)
COPY package*.json ./
RUN npm ci --include=dev --no-audit --no-fund

# Frontend dependencies
COPY frontend/package*.json ./frontend/
RUN cd frontend && npm ci --include=dev --no-audit --no-fund

# Application sources
COPY . .

ENV PORT=4200
EXPOSE 4200

# Start mock API and frontend app
CMD ["sh", "-c", "./node_modules/.bin/prism mock tsp-output/@typespec/openapi3/openapi.yaml --port 4010 --cors & cd frontend && ./node_modules/.bin/ng serve --host 0.0.0.0 --port ${PORT}"]
