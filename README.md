# EPN Reporta · Prototipo

Prototipo navegable de **EPN Reporta**, una app para reportar daños en aulas, laboratorios y baños de la Escuela Politécnica Nacional y seguir su solución. Está hecho con Flutter.

No usa base de datos ni servidor. Todo vive en memoria con datos de ejemplo, así que al cerrar la app se reinicia. La idea es mostrar todas las pantallas y cómo se mueve el usuario entre ellas.

## Perfiles

En el login hay tres accesos rápidos (también sirve cualquier correo con una clave no vacía; el usuario de ejemplo es `maria.pazmino@epn.edu.ec`).

| Perfil | Qué puede hacer |
| --- | --- |
| Estudiante / Docente | Crear, editar y eliminar reportes, filtrarlos, comentar, ver el mapa del campus y recibir notificaciones |
| Personal técnico | Ver la bandeja por atender, tomar reportes, cambiar su estado y comentar |
| Administrador | Ver el panel con indicadores, asignar técnicos, cambiar prioridad y estado, y activar o desactivar usuarios |

## Pantallas

Splash, onboarding, inicio de sesión, registro, inicio del estudiante, lista de reportes con búsqueda y filtros, nuevo reporte en tres pasos, detalle con línea de tiempo y comentarios, mapa del campus, detalle por edificio, bandeja del técnico, panel del administrador, gestión de usuarios, notificaciones, perfil, editar perfil, ajustes (incluye modo oscuro), ayuda y acerca de.

## Cómo correrlo

```
flutter pub get
flutter run
```

Se probó en un emulador Pixel 5 con Android 14.

## Estructura

```
lib/
  data/      estado de la app y datos de ejemplo (provider)
  models/    usuarios, reportes, edificios, notificaciones
  screens/   pantallas y pestañas por perfil
  widgets/   componentes reutilizables
  tema.dart  colores y temas claro y oscuro
```

Proyecto del Taller de Aplicaciones Móviles, Ingeniería de Software, EPN.
