# Debug chats (sin tocar rules)

## Objetivo
Eliminar el `permission-denied` en `getUserConversations()` para veterinarios.

## Paso 1: imprimir UID logueado
1) Abre `lib/screens/home_veterinarian_screen.dart`.
2) En el `build` o antes de navegar a `VeterinarianChatScreen`, imprime:
   - `AuthService().getCurrentUser()?.uid`

## Paso 2: verificar que el mismo UID esté en `participants`
Para el chat que falla, valida en Firestore Console:
- `chats/{chatId}.participants` contiene el UID logueado.

## Paso 3: revisar filtros de la consulta
La consulta es:
- `collection('chats').where('participants', arrayContains: userId).get()`

Si falla para veterinario, significa que Firestore está negando lectura sobre *al menos* uno de los documentos del resultado.

## Paso 4: identificar el documento problemático
1) Ejecuta una consulta manual en el app (o en consola) para traer `chats` donde `participants` contiene el UID.
2) Si la lista falla, usa el Emulator/Logs o revisa si existen chats con participantes inconsistentes (aunque uno esté bien).

## Resultado esperado
Al confirmar que la UID logueada coincide y que *todos* los chats encontrados cumplen reglas, el error debe desaparecer.

