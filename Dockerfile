# ---------- 1) Build ----------
# Corre en la arquitectura de quien construye. El resultado (JS/CSS estático)
# sirve para cualquier CPU, así que no hace falta emular ARM si luego se usa una Raspberry Pi.
FROM --platform=$BUILDPLATFORM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---------- 2) Runtime: Nginx ----------
FROM nginx:alpine

# Valores por defecto; se pueden cambiar con variables de entorno al ejecutar el contenedor
ENV PORT=80 \
    API_UPSTREAM=http://api:8080 \
    DNS_RESOLVER=127.0.0.11

# La imagen oficial de Nginx reemplaza ${PORT}, ${API_UPSTREAM} y ${DNS_RESOLVER}
# de los archivos en /etc/nginx/templates al arrancar
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://127.0.0.1:${PORT}/ >/dev/null || exit 1
