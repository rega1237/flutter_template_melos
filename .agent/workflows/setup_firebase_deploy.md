---
description: Configura las credenciales y el proyecto para habilitar el Despliegue Continuo (CD) a Firebase.
---

# Guía de Configuración: Despliegue Continuo a Firebase

Tu repositorio ya tiene el pipeline configurado (`.github/workflows/main_pipeline.yml`), pero **GitHub necesita permiso** para hablar con Firebase.

Sigue estos pasos únicos para conectar los cables.

## 1. Crear Proyecto en Firebase Console
1. Ve a [console.firebase.google.com](https://console.firebase.google.com/).
2. Crea un nuevo proyecto (o usa uno existente).
3. **Importante**: Copia el `Project ID` (ej: `progrese-app-v1`).

## 2. Configurar el Pipeline
1. Abre el archivo `.github/workflows/main_pipeline.yml` en este repo.
2. Busca la línea `projectId: progrese-prod` (al final del archivo).
3. Cambia `progrese-prod` por tu `Project ID` real.

## 3. Obtener Credenciales (Service Account)
Necesitamos una llave para que GitHub Actions pueda desplegar sin que tú inicies sesión.

1. Instala Firebase CLI (si no lo tienes):
   ```bash
   npm install -g firebase-tools
   ```
2. Loguéate:
   ```bash
   firebase login
   ```
3. **Generar el token para GitHub**:
   Este comando configurará automáticamente el secreto en tu repositorio si tienes permisos de admin:
   ```bash
   firebase init hosting:github
   ```
   *   Sigue las instrucciones.
   *   Cuando te pregunte "For which GitHub repository would you like to set up a GitHub workflow?", escribe: `usuario/repo` (tu usuario y nombre de repo).
   *   Esto creará el secreto `FIREBASE_SERVICE_ACCOUNT` automáticamente en GitHub.

   **Alternativa Manual (si el comando falla)**:
   1. Ve a la configuración de tu proyecto en Firebase Console > Cuentas de Servicio.
   2. Genera una nueva clave privada (descarga el JSON).
   3. Ve a tu Repo en GitHub > Settings > Secrets and variables > Actions.
   4. Crea un **New Repository Secret**:
      - Nombre: `FIREBASE_SERVICE_ACCOUNT`
      - Valor: (Pega todo el contenido del JSON descargado).

## 4. Probar
Haz un push a la rama `main`.
- Si todo está bien, verás en la pestaña "Actions" de GitHub que se ejecuta el trabajo `Deploy to Firebase Hosting` y tu web estará online en minutos.
