FROM node:22-bookworm-slim AS frontend-build

WORKDIR /app/frontend

COPY frontend/package.json ./
RUN npm install --include=dev --no-audit --no-fund --registry=https://registry.npmjs.org/ --package-lock=false

COPY frontend/ ./
RUN npm run build -- --configuration production

FROM node:22-bookworm-slim

WORKDIR /app

COPY package.json ./
RUN npm install --omit=dev --no-audit --no-fund --registry=https://registry.npmjs.org/ --package-lock=false

COPY main.tsp ./main.tsp
COPY tspconfig.yaml ./tspconfig.yaml
RUN npx tsp compile main.tsp

COPY server.js ./server.js
COPY --from=frontend-build /app/frontend/dist/frontend ./frontend-dist

ENV PORT=10000
EXPOSE 10000

CMD ["sh", "-c", "./node_modules/.bin/prism mock tsp-output/@typespec/openapi3/openapi.yaml --port 4010 --cors & node server.js"]
