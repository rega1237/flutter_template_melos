# Estándar de Sincronización Local-First (Híbrido: Realtime + Pull)

Para garantizar un sistema multi-dispositivo veloz, eficiente y escalable, todo módulo o tabla que requiera persistencia offline y sincronización DEBE seguir estrictamente estas reglas.

## 1. Esquema de Base de Datos (Drift & SQL)

Toda tabla sincronizable debe incluir estos campos técnicos de forma obligatoria:

```dart
DateTimeColumn get createdAt => dateTime()();
DateTimeColumn get updatedAt => dateTime().nullable()();
// Soportar borrado offline sin pérdida de datos
DateTimeColumn get deletedAt => dateTime().nullable()();
// Control de subida (Push)
BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
// Control de bajada (Realtime & Pull)
DateTimeColumn get lastSyncedAt => dateTime().nullable()();
```

## 2. Repositorios Sincronizables

Los repositorios deben implementar la interfaz `SyncableRepository` de `packages/database`.

### Requisitos Críticos:
1. **`initializeRealtime()`**: Debe abrir un canal de Supabase para escuchar cambios en tiempo real. Al recibir un cambio, se guarda en local **SOLO si** `isDirty == false` para evitar conflictos.
2. **`pull()`**: Se ejecuta SOLO en el arranque o reconexión. Realiza una descarga masiva basada en el `updated_at` más reciente.
3. **`push()`**: Se ejecuta periódicamente (60s). Procesa cambios locales.
   - Si `deletedAt != null`: Borra en la nube y luego borra físicamente en local.
   - Si no: Hace `upsert` y limpia el flag `isDirty`.

## 3. Registro y Control (SyncEngine)

Todo repositorio sincronizable debe registrarse en el `syncTasksProvider` en el `main.dart` de la aplicación.
* El `SyncEngine` reintentará automáticamente fallos de red cada 60s.
* Se debe notificar visualmente el estado de `Error` si una sincronización falla persistentemente.

## 4. Flujo de UX (Local-First Priority)

1. **Escritura**: Siempre escribir en SQLite primero con `isDirty: true`.
2. **Lectura**: Usar `Streams` reactivos que miren a SQLite y filtren SIEMPRE los registros donde `deletedAt != null`.
3. **Magia de Realtime**: La UI se actualizará sola cuando lleguen cambios remotos, gracias a que el listener de Realtime actualiza la base local.
