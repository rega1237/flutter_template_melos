---
description: Valida el código contra las reglas de CI/CD para asegurar que no romperá el pipeline al subir.
---

Este workflow **DEBE** ejecutarse antes de que el agente considere una tarea como "Completada".

1. **Generación de Código**
   // turbo
   - Ejecuta `melos run build:runner`
   *Razón:* Asegura que todos los archivos *.g.dart y *.freezed.dart estén actualizados y no falten referencias.

2. **Análisis Estático (Linter)**
   // turbo
   - Ejecuta `melos run analyze`
   *Razón:* Verifica reglas de `analysis_options.yaml` (Very Good Analysis + 120 chars).
   *Acción si falla:* El agente DEBE corregir los errores linter antes de continuar.

3. **Pruebas (Tests)**
   // turbo
   - Ejecuta `melos run test`
   *Razón:* Asegura que los cambios no rompieron lógica existente.
   *Acción si falla:* Diagnosticar y corregir el test fallido.

4. **Verificación de Base de Datos (Si aplica)**
   - Si hubo cambios en `packages/database`, verificar migraciones.
   *Nota:* Supabase local debe estar activo.

5. **Aprobación final**
   - Si los pasos 2 y 3 pasan exitosamente -> El código es seguro para Commit/Push.
