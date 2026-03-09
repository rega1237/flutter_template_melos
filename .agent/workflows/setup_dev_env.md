---
description: Inicializa y valida el entorno de desarrollo (macOS). SI ESTE PROCESO FALLA, EL AGENTE DEBE CONSULTAR 'TROUBLESHOOTING.md' Y NO INTENTAR MODIFICAR CÓDIGO.
---

> **Entorno objetivo:** macOS (Apple Silicon y Intel).
> Los comandos asumen que el shell es `zsh` (default en macOS desde Catalina).
> Asegúrate de que `~/.pub-cache/bin` y `/usr/local/bin` (o `/opt/homebrew/bin` en Apple Silicon) estén en tu `$PATH`.
> Añade esto a tu `~/.zshrc` si no lo tienes:
> ```zsh
> export PATH="$HOME/.pub-cache/bin:$PATH"
> export PATH="/opt/homebrew/bin:$PATH"   # Apple Silicon
> # export PATH="/usr/local/bin:$PATH"    # Intel Mac
> ```

1. Validar prerrequisitos del sistema (CRÍTICO)
   - Verificar Flutter: `flutter --version`. Si falla → ABORTAR y pedir que instalen Flutter via `brew install --cask flutter` o desde flutter.dev.
   - Verificar Docker: `docker --version`. Si falla → ABORTAR y pedir instalar Docker Desktop para Mac desde docker.com.
   - Verificar Supabase CLI:
     - Primero intentar: `supabase --version`
     - Si falla, intentar vía Homebrew: `brew install supabase/tap/supabase` y reintentar.
     - Si aún falla, intentar via NPX: `npx supabase --version`
     - Si todo falla → ABORTAR y referir al usuario a README.md.
   - Verificar que melos está disponible: `melos --version`
     - Si falla, asegurarse de que `~/.pub-cache/bin` está en `$PATH` y ejecutar `dart pub global activate melos`.

2. Bootstrapping del Proyecto
   // turbo
   - Ejecutar `dart pub global activate melos`
   // turbo
   - Ejecutar `melos bootstrap`

3. Configuración de Backend (Local)
   // turbo
   - Ejecutar `supabase start` para levantar el backend local.
     - En Apple Silicon (M1/M2/M3), si hay errores de imagen Docker, ejecutar: `supabase start --ignore-health-check`
     - Si `supabase` no está en PATH, usar: `~/.pub-cache/bin/supabase start` o `npx supabase start`

4. Generación de Código
   // turbo
   - Ejecutar `melos run build:runner` para generar archivos *.g.dart y *.freezed.dart base.

5. Validación Final
   // turbo
   - Ejecutar `melos run analyze` para confirmar que no hay errores estáticos.
   // turbo
   - Ejecutar `melos run test` para validar el estado base del proyecto.

6. Confirmación y Ejecución
   - Ejecutar `cd apps/flutter_app && flutter run -d chrome`
     - Si Chrome no es detectado, verificar con: `flutter devices`
     - En macOS, Chrome suele estar en `/Applications/Google Chrome.app`. Flutter lo detecta automáticamente.
     - Si hay múltiples Chrome, especificar con: `flutter run -d "Chrome (web)"`
   - Verificar que aparezca en pantalla: "Entorno Totalmente Instalado"
