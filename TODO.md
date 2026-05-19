# TODO


## Paso 1: Diagnóstico en código
- [x] Revisar `RegisterVeterinarianScreen` y ver cómo se sube la foto.
- [x] Confirmar que el problema ocurre en Web (Chrome) desde `http://localhost:58249`.

## Paso 2: Blindar el registro ante fallas de Firebase Storage (CORS)
- [ ] Ajustar `_uploadImage()` para que NO afecte el flujo de registro.
- [ ] Asegurar que si `photoUrl` queda vacío, NO se guarde `fotoUrl` en Firestore (o se guarde `null`).
- [ ] Mantener navegación exitosa aunque falle el upload.

## Paso 3: (Opcional) Repetir el mismo blindaje en otros flujos con upload
- [ ] Verificar `RegisterFarmerScreen` y `UpdateVeterinarianProfileScreen` para el mismo patrón.
- [x] Ajustar `RegisterVeterinarianScreen` para que el registro NO dependa del upload (CORS Web).


## Paso 4: Validación
- [ ] Probar registro en Web nuevamente.
- [ ] Confirmar que ya no se corta el registro por el error CORS.

