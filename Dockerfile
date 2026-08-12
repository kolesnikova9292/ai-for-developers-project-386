FROM node:22-bookworm-slim

WORKDIR /app

# Root dependencies (Prism mock API)
COPY package.json ./
RUN npm install --include=dev --no-audit --no-fund --registry=https://registry.npmjs.org/ --package-lock=false

# Frontend dependencies
COPY frontend/package.json ./frontend/
RUN cd frontend && npm install --include=dev --no-audit --no-fund --registry=https://registry.npmjs.org/ --package-lock=false

# Application sources
COPY . .

ENV PORT=4200
EXPOSE 4200

# Start mock API and frontend app
CMD ["sh", "-c", "./node_modules/.bin/prism mock tsp-output/@typespec/openapi3/openapi.yaml --port 4010 --cors & ./frontend/node_modules/.bin/ng serve --host 0.0.0.0 --port ${PORT}"]
