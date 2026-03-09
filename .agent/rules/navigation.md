---
trigger: always_on
---

# Estándar de Navegación

## Prioridad Global
Para garantizar consistencia y soportar funcionalidades Web críticas (Deep Linking, Clean URLs), el proyecto sigue estas directrices:

### 1. Router Principal: GoRouter
- **Uso Obligatorio**: Toda la navegación de nivel superior y anidada estándar debe usar `GoRouter`.
- **Configuración**: Centralizad en `lib/router.dart` (o módulo de routing equivalente).
- **Ventajas**: Manejo nativo de URLs web, redirecciones basadas en estado (auth), y soporte de parámetros tipados.

### 2. Flujos Complejos: Flow Builder
- **Uso Opcional/Recomendado**: Para casos donde la navegación depende estrictamente de un estado lineal o complejo (ej. Wizards, Onboarding, Procesos de Checkout).
- **Integración**: Se debe montar como una página/widget dentro de una ruta de `GoRouter`.
- **Beneficio**: Desacopla la lógica de "pasos" del router global, permitiendo manejar el historial del flujo localmente.

### Ejemplo de Integración

```dart
// flow_builder maneja el estado interno del Wizard
final wizardRoute = GoRoute(
  path: '/wizard',
  builder: (context, state) => FlowBuilder<WizardState>(
    state: context.watch<WizardStateProvider>(),
    onGeneratePages: (wizardState, pages) {
      // Retorna lista de páginas basada en estado
    },
  ),
);
```

