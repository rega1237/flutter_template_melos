# CI/CD & Git Workflow

- **Control de Versiones:** Los commits deben seguir el estándar de [Conventional Commits](www.conventionalcommits.org).
- **Flujo de Trabajo:** Todo el desarrollo debe realizarse en la rama `develop`. Solo se debe fusionar (merge) a `main` cuando se desee realizar un despliegue a producción.
- **Validación:** Antes de hacer commit, se debe ejecutar `melos run validate`.
  - Debe incluir: `melos run analyze`, `melos run test` y `supabase db verify`.
- **Despliegue:** El despliegue a producción es automático solo si el pipeline de GitHub Actions termina en verde.

## ✅ Gestión de Base de Datos Local (SQLite/Drift):
- **Cuándo incrementar `schemaVersion`**: Siempre que se añada, elimine o renombre una columna o tabla en los archivos de `tables/`.
- **Procedimiento**:
  1. Incrementar el `schemaVersion` en `app_database.dart`.
  2. Añadir la lógica de migración en `MigrationStrategy -> onUpgrade` usando `m.addColumn`, `m.createTable`, etc.
  3. Esto evita errores de "no such column" en dispositivos que ya tenían una versión previa del app instalada (especialmente en producción).

## ✅ Incremento de Versión App:
- **Obligatorio**: Se DEBE incrementar la versión en `apps/flutter_app/pubspec.yaml` (ej: `1.0.5+1` -> `1.0.6+1`) en **CADA commit** que incluya cambios de lógica o UI.
- Esto garantiza que el despliegue refleje siempre el estado actual y que los usuarios reciban las actualizaciones correctamente.

## ✅ Regla Crítica antes de hacer Commit:
**NUNCA**, bajo ninguna circunstancia, se debe realizar un `git commit` o `git push` sin haber resuelto primero todos los errores de validación local y haber incrementado la versión.
El Agente DEBE ejecutar SIEMPRE:
```bash
melos run validate
```
Si el comando falla, el Agente debe corregir los errores de sintaxis, análisis o tests antes de continuar con el commit.
