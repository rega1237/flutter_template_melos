---
trigger: always_on
---

# Flutter Web Guidelines

Este proyecto está optimizado para **Web**. El agente debe seguir estas reglas adicionales:

## 🌐 Consideraciones Web First
1. **No usar `dart:io`**: Evita importar `dart:io` (File, Platform) en código compartido. Usa `universal_html` o chequeos `kIsWeb` si es estrictamente necesario.
2. **Navegación**: Usa **GoRouter** (o similar configurado) para soportar Deeplinking y URLs limpias en el navegador.
3. **Responsive Design**:
   - Todo componente debe ser *responsive*.
   - Usa `LayoutBuilder` o breakpoints predefinidos en `core_ui`.
   - Recuerda que el usuario puede redimensionar la ventana en cualquier momento.

## 📦 Dependencias Web
- Asegúrate de que los paquetes agregados tengan soporte oficial para **Web**.
- Prefiere `shared_preferences` o `hive` (limitado) / `drift` (WebAssembly) para persistencia.

## 🚀 Despliegue Web
- El build de producción se genera con:
  ```bash
  flutter build web --release
  ```
- (Configura `--wasm` solo si el entorno lo soporta, sino usa html/canvas kit default).
