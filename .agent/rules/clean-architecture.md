# Clean Architecture & Monorepo Rules

- **Estructura Melos:** Los paquetes deben dividirse en `core`, `ui`, y `features`.
- **Capas de Clean Architecture:**
  - **Domain:** Entidades y contratos (interfaces). Sin dependencias externas.
  - **Data:** Implementaciones de repositorios, fuentes de datos (Drift/Supabase) y DTOs (Mappers).
  - **Presentation:** Widgets de Flutter y providers de Riverpod.
- **Riverpod:** Usa `@riverpod` annotations para la generación automática de providers.
