# Design System & UI Guidelines

Este archivo es la **fuente de verdad** para el diseño visual del proyecto (KFG Transport). El agente debe consultar este documento antes de crear o modificar cualquier interfaz para asegurar consistencia a nivel de toda la aplicación.

## 📍 Ubicación del Código
Todos los componentes de diseño, paleta de colores y widgets base residen en el paquete de UI centralizado: `packages/core_ui`.

## 🎨 Paleta de Colores (Theme - `KfgColors`)
Los colores semánticos se encuentran definidos en `packages/core_ui/lib/src/theme/kfg_theme.dart` en la clase `KfgColors`. Evita usar colores crudos o *hardcodear* `Colors.red` o `Hex codes`.

- **Primary (Deep Red / Red):** `KfgColors.deepRed` (0xFFD32F2F) / `KfgColors.red` (0xFFEF5350)
- **Secondary (Steel Blue):** `KfgColors.steelBlue` (0xFF4A6B8C)
- **Backgrounds:** `KfgColors.background` (0xFFF8F9FA) para el fondo general, `KfgColors.surface` (Colors.white) para tarjetas y fondos de contenedor.
- **Sidebar / Dark Navy:** `KfgColors.darkNavy` (0xFF0A192F) o `KfgColors.darkBlue` (0xFF1A365D).
- **Gradients:** `KfgColors.spaceGradient` es el degradado oficial oscuro (usado en LoginScreen y en la Sidebar principal para fusionar estética). Combina `darkNavy`, `deepSlate`, y `steelBlue`.
- **Text:** `KfgColors.textPrimary` (Oscuro), `KfgColors.textSecondary` (Gris medio), `KfgColors.textMuted` (Gris claro).

## 🔤 Tipografía (TextStyles)
La aplicación utiliza `GoogleFonts.inter` por defecto. Al construir interfaces, prefiere usar las fuentes de `GoogleFonts` especificadas en la configuración y siempre presta atención al color del texto para garantizar el contraste con el fondo.

## 🧩 Componentes Globales Obligatorios

El agente **DEBE PREFERIR** los siguientes widgets personalizados. **Bajo ninguna circunstancia** debes construir `TextFormField` sueltos para datos de la app sin usar los custom widgets.

### Entradas de Texto y Formularios (`AppTextField` y `AppDropdownField`)
Todo formulario debe usar `AppTextField` y `AppDropdownField` (ubicados en `packages/core_ui/lib/src/widgets/app_text_field.dart`). Estos componentes están construidos con las siguientes reglas KFG:
- **Label Externo:** La etiqueta (*label*) debe ir por fuera del campo de texto principal. 
- **Indicador de Requerido:** Si es obligatorio (`isRequired: true`), se dibuja un asterisco rojo (*) junto al label.
- **Aspecto del Campo:** El campo de texto siempre tiene un fondo blanco sólido (`fillColor: Colors.white`, salvo un sobreentendido para fondos muy oscuros donde debes proveer `labelColor`), bordes suaves gises, y un borde ligeramente más grueso de color `KfgColors.steelBlue` cuando tiene el foco (focused). En estado de error, se bordea de color rojo (`KfgColors.red`).
- **Hint Text y Soft Icons:** El texto de ayuda interior se pinta en color suave (mutado), igual que los íconos internos (`icon` y `suffixIcon`).
- **Campos Especiales:** `AppTextField` maneja por ti casos de uso especial mediante variables: Usa `keyboardType: TextInputType.phone` para auto-formatear números en máscara `(XXX) XXX-XXXX`. Usa `isAmount: true` para permitir valores numéricos con decimales (`RegExp(r'^\d*\.?\d*')`).

### Navegación y Estructura
- **Sidebar y Topbar:** La navegación principal está centralizada en `apps/flutter_app/lib/router.dart` (`ShellRoute`). El Sidebar está reservado principalmente para navegación en la aplicación. La información del usuario conectado, opciones de cambiar contraseña, y cerrar sesión, se ubican siempre en la zona de la cabecera / TopBar, como un `PopupMenuButton` sobre el nombre y avatar del usuario de turno.

### Pantallas de Listado de Datos (List Screens / Data Tables)
- **Ancho Máximo (Max Width):** Toda pantalla principal orientada a listar datos y tablas debe estar contenida o centrada con un ancho máximo de `1200px` (usando, por ejemplo, `Center` con `ConstrainedBox(constraints: BoxConstraints(maxWidth: 1200))`).
- **Encabezado y Botón de Acción (Header & Add Action):** En resoluciones de escritorio/tablet el botón primario de agregar (Add Item) **NO** debe ser un FAB, sino un botón (FilledButton) en la parte superior derecha acompañado del Título del módulo a la izquierda (en un `Row`). Al hacer la pantalla pequeña (< 800px), el botón se oculta de la zona superior y aparecerá un `FloatingActionButton` estándar. Todo botón de agregar, crear o acción principal debe usar el color rojo base de la marca (`KfgColors.red` definido en el Tema por defecto), nunca naranja u otros colores arbitrarios. Las acciones de eliminar y desactivar (Destructivas) también deben usar `KfgColors.red`, reservando `KfgColors.steelBlue` para acciones secundarias o neutrales.
- **Barra de Herramientas Obligatoria:** Las pantallas de listado siempre deben incluir debajo del título principal:
  - Un **Buscador** (Search bar) para búsquedas de texto.
  - Opciones de **Filtrado** por tipo, categoría o estado (por ejemplo, estado activo/inactivo, rol).
  - Opciones de **Ordenamiento** para organizar la tabla.

### Internacionalización y Localization (`AppStrings`)
- **Regla Estricta:** Las traducciones son obligatorias. Ningún texto o Label orientado al usuario debe codificarse en duro en las pantallas de Flutter. Todo el texto de los modulos debe ser centralizado y extraído a través de `AppStrings` en `packages/core/lib/src/l10n/app_strings.dart` abarcando tanto el idioma Inglés (`en`) como el Español (`es`).
- **Verificación de Módulos (Bilingual Check):** Antes de dar por concluido el desarrollo de un módulo o pantalla, el Agente y el Desarrollador **DEBEN obligatoriamente** revisar si el componente soporta y visualiza correctamente sus textos en ambos idiomas (Español e Inglés) usando la clase principal. NO se permite asumir funcionalidad sin esta verificación cruzada.

---
*Nota para el Desarrollador e Inteligencia Artificial: Toda modificación al UI base, campos o componentes recurrentes debe agregarse a este archivo y referenciar a `core_ui`.*
