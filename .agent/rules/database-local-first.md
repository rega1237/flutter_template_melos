# Reglas de Base de Datos y Sincronización (Local-First)

## 1. Patrón Arquitectónico:
Toda la aplicación Flutter lee y escribe **exclusivamente** de SQLite (`drift`).
*   **La UI no debe llamar a Supabase directamente para leer/guardar datos transaccionales.**
*   El paquete `database` expone Repositorios que leen/escriben en `AppDatabase`.

## 2. Definición de Tablas en Drift:
Para que la sincronización offline funcione, TODA tabla en SQLite que deba sincronizarse con Supabase DEBE incluir:
*   `BoolColumn get isDirty => boolean().withDefault(const Constant(false))();`
*   `DateTimeColumn get lastSyncedAt => dateTime().nullable()();`

## 3. Sincronización en Segundo Plano (El Sync Engine):
*   Cuando la UI inserta un registro:
    1. Se graba en Drift con `isDirty = true`.
    2. La UI recibe actualización en tiempo real (gracias al stream de Drift).
    3. Un servicio en background (`SyncService`) intenta subir el registro a Supabase.
    4. Si hay internet y triunfa, actualiza `isDirty = false` y `lastSyncedAt = DateTime.now()`.
    5. Si hay cambios de Supabase (Realtime), el backend actualiza Drift y la UI se refresca sin tocar nada.

## 4. Archivos WASM:
*   Este es un proyecto enfocado a Web (`platform-web.md`).
*   La compilación de SQLite requiere `sqlite3.wasm` y `drift_worker.js` en la carpeta `web/` de la app principal.

## 5. Cambios Estructurales (Migraciones):
Cualquier cambio de esquema se debe hacer **en ambos lados**:
1. Archivos `.sql` en `supabase/migrations/`
2. Esquema en `packages/database/lib/infrastructure/tables/` seguido de la regeneración de Drift (`melos run build:runner`).
## 6. Manejo de Borrados (Soft Delete):
Para soportar el borrado de registros estando offline sin que el registro reaparezca en el próximo `pull`:
*   **Esquema**: Se debe incluir `DateTimeColumn get deletedAt => dateTime().nullable()();`.
*   **Acción del Repositorio**: El método `delete()` no debe borrar el registro de Drift, sino actualizar `deletedAt = DateTime.now()` e `isDirty = true`.
*   **Filtros**: Las consultas de lectura (`get` y `watch`) deben filtrar registros donde `deletedAt` no sea nulo.
*   **Sincronización (Push)**: El `SyncEngine` al encontrar un registro con `deletedAt` no nulo, llamará al endpoint de Supabase para borrarlo permanentemente y luego ejecutará el borrado físico en Drift local.
