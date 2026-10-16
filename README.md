# RutaSV – Frontend

SPA en React + Vite del marketplace de experiencias turísticas RutaSV.
Solo consume la API REST; el backend (.NET) vive en otro repositorio y corre en su propio contenedor.

**Stack:** React, Vite, React Router, TailwindCSS, Vitest + React Testing Library, Nginx (en producción).

## Requisitos

- Node 22 (`.nvmrc`)
- Docker (opcional, para probar la imagen)

## Desarrollo local

```bash
npm install
cp .env.example .env  
npm run dev
```

Vite redirige `/api/*` al backend quitando el prefijo `/api` (igual que Nginx en producción),
así el código siempre llama a `/api/...` sin importar el entorno.

## Scripts

| Comando | Qué hace |
|---|---|
| `npm run dev` | Servidor de desarrollo |
| `npm run build` | Build de producción en `dist/` |
| `npm run lint` | ESLint |
| `npm test` | Pruebas con Vitest |

## Docker

La imagen sirve la SPA con Nginx (sin root, puerto interno 8080) y reenvía `/api` al backend.
Variables de entorno de la imagen:

| Variable | Por defecto | Descripción |
|---|---|---|
| `API_UPSTREAM` | `http://api:8080` | URL del backend |
| `PORT` | `8080` | Puerto de Nginx dentro del contenedor |
| `DNS_RESOLVER` | `127.0.0.11` | DNS de Docker |

Probar solo el frontend (con el backend corriendo aparte en tu PC, puerto 8080):

```bash
docker compose up --build
```

Abre http://localhost:5173. Para apuntar a otro backend, define `API_UPSTREAM` en `.env`
(en el compose completo del proyecto es `http://api:8080`).

## CI

GitHub Actions (`.github/workflows/ci.yml`) en cada PR y push a `develop`/`main`:
lint, pruebas, build y construcción de la imagen Docker con una prueba de humo.

## Flujo de trabajo

GitHub Flow: `main` (estable), `develop` (integración) y `feature/*` por historia.
Todo cambio entra por Pull Request con revisión; commits con Conventional Commits.
