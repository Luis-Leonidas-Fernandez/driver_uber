# 🚗 Driver Uber - Sistema de Autenticación

## 📋 Índice
- [Descripción General](#descripción-general)
- [Arquitectura](#arquitectura)
- [Flujo de Autenticación](#flujo-de-autenticación)
- [Manejo de Errores](#manejo-de-errores)
- [Tipos de Error](#tipos-de-error)
- [Uso en la UI](#uso-en-la-ui)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Instalación](#instalación)

## 🎯 Descripción General

Sistema de autenticación robusto para conductores de Uber con manejo avanzado de errores, validaciones y estados. Implementa patrones de Clean Architecture y BLoC para un código mantenible y escalable.

## 🏗️ Arquitectura

### **Patrón BLoC (Business Logic Component)**
```
UI Layer (Widgets) 
    ↓
BLoC Layer (AuthBloc)
    ↓
Service Layer (AuthService)
    ↓
Data Layer (API/Storage)
```

### **Componentes Principales**
- **`AuthBloc`**: Maneja estados y lógica de negocio
- **`AuthService`**: Comunicación con API
- **`ErrorUtils`**: Manejo centralizado de errores
- **`RegisterUserController`**: Gestión de formularios

## 🔐 Flujo de Autenticación

### **1. Registro de Usuario**

```mermaid
graph TD
    A[Usuario llena formulario] --> B[RegisterUserController.agregarNuevoUsuario()]
    B --> C[AuthBloc._sendUser()]
    C --> D[AuthBloc._initRegister()]
    D --> E[AuthService.register()]
    E --> F{¿Registro exitoso?}
    F -->|Sí| G[OnAddUserSessionEvent]
    F -->|No| H[OnRegisterErrorEvent]
    G --> I[Usuario autenticado]
    H --> J[Mostrar error en UI]
```

### **2. Login de Usuario**

```mermaid
graph TD
    A[Usuario ingresa credenciales] --> B[AuthBloc.initLogin()]
    B --> C[AuthService.loginUser()]
    C --> D{¿Login exitoso?}
    D -->|Sí| E[OnAddUserSessionEvent]
    D -->|No| F[OnLoginErrorEvent]
    E --> G[Usuario autenticado]
    F --> H[Mostrar error en UI]
```

## ⚠️ Manejo de Errores

### **Estrategia de Manejo**

1. **Manejo Específico**: Captura excepciones específicas primero
2. **Fallback Genérico**: Usa `ErrorUtils` para casos no específicos
3. **Categorización**: Clasifica errores por tipo para mejor UX

### **Flujo de Manejo de Errores**

```mermaid
graph TD
    A[Error ocurre] --> B{¿Es excepción específica?}
    B -->|Sí| C[Manejo específico]
    B -->|No| D[ErrorUtils.handleError()]
    C --> E[Emitir estado de error]
    D --> F[Analizar patrón de error]
    F --> G[Obtener mensaje y código]
    G --> E
    E --> H[UI muestra error]
```

## 🚨 Tipos de Error

### **Excepciones Específicas**

| Excepción | Cuándo ocurre | Mensaje | Código |
|-----------|---------------|---------|---------|
| `NetworkException` | Sin conexión | "Sin conexión a internet. Verifica tu red." | `NETWORK_ERROR` |
| `ServerException` | Error del servidor | "Error del servidor. Intenta más tarde." | `SERVER_ERROR` |
| `ClientException` | Error del cliente | "Credenciales incorrectas." | `UNAUTHORIZED_ERROR` |
| `ValidationException` | Datos inválidos | "El formato del email no es válido." | `INVALID_EMAIL_ERROR` |
| `TimeoutException` | Tiempo agotado | "Tiempo de espera agotado. Intenta nuevamente." | `TIMEOUT_ERROR` |
| `ParseException` | Error de parsing | "Error al procesar la respuesta del servidor." | `PARSE_ERROR` |

### **Patrones de Error (ErrorUtils)**

```dart
// Ejemplos de patrones detectados
'socketexception|network'     → NetworkError
'timeoutexception|timeout'    → TimeoutError
'formatexception|parse'       → ParseError
'unauthorized|401'            → UnauthorizedError
'forbidden|403'               → ForbiddenError
'not found|404'               → NotFoundError
'server error|500'            → ServerError
'email.*invalid'              → InvalidEmailError
'password.*weak'              → WeakPasswordError
```

## 🎨 Uso en la UI

### **1. Escuchar Estados**

```dart
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is UserRegisterErrorState) {
      // Mostrar error de registro
      _showErrorDialog(state.message, state.errorCode);
    } else if (state is UserLoginErrorState) {
      // Mostrar error de login
      _showErrorDialog(state.message, state.errorCode);
    } else if (state is UserRegisteringState) {
      // Mostrar loading de registro
      _showLoadingDialog();
    }
  },
  builder: (context, state) {
    // Construir UI según estado
  },
)
```

### **2. Manejar Errores Específicos**

```dart
void _showErrorDialog(String message, String? errorCode) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: [
        if (errorCode == 'NETWORK_ERROR' || errorCode == 'SERVER_ERROR')
          TextButton(
            onPressed: () {
              // Reintentar operación
              context.read<AuthBloc>().add(RegisterUserEvent());
            },
            child: Text('Reintentar'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cerrar'),
        ),
      ],
    ),
  );
}
```

### **3. Estados Disponibles**

```dart
// Estados de carga
UserRegisteringState()    // Registrando usuario
UserLoggingInState()      // Iniciando sesión

// Estados de error
UserRegisterErrorState(message: 'Error', errorCode: 'CODE')
UserLoginErrorState(message: 'Error', errorCode: 'CODE')

// Estados de éxito
AuthState(usuario: usuario, authenticando: true)  // Usuario autenticado
```

## 📁 Estructura del Proyecto

```
lib/
├── blocs/user/
│   ├── auth_bloc.dart          # Lógica de autenticación
│   ├── auth_event.dart         # Eventos de autenticación
│   └── auth_state.dart         # Estados de autenticación
├── service/
│   └── auth_service.dart       # Comunicación con API
├── utils/
│   ├── error_utils.dart        # Manejo de errores
│   └── error_constants.dart    # Constantes de error
├── exceptions/
│   └── auth_exceptions.dart    # Excepciones personalizadas
├── controllers/
│   └── register_user_controllers.dart  # Controladores de formulario
└── models/
    ├── usuario.dart            # Modelo de usuario
    └── login.dart              # Modelo de respuesta de login
```

## 🚀 Instalación

### **Dependencias Principales**

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  hydrated_bloc: ^9.1.5
  equatable: ^2.0.5
  http: ^1.1.0
  flutter_secure_storage: ^9.0.0
```

### **Configuración Inicial**

```dart
void main() {
  HydratedBloc.storage = await HydratedStorage.build();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authService: AuthService(),
            registerUserController: RegisterUserController(),
          ),
        ),
        // ... otros providers
      ],
      child: MyApp(),
    ),
  );
}
```

## 🔧 Configuración de Errores

### **Agregar Nuevo Tipo de Error**

1. **En `error_constants.dart`:**
```dart
static const Map<String, String> errorPatterns = {
  // ... patrones existentes
  'new_error': 'patron|regex',
};

static const Map<String, String> errorMessages = {
  // ... mensajes existentes
  'new_error': 'Mensaje amigable para el usuario',
};

static const Map<String, String> errorCodes = {
  // ... códigos existentes
  'new_error': 'NEW_ERROR_CODE',
};
```

2. **En `auth_exceptions.dart`:**
```dart
class NewException extends AuthException {
  const NewException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}
```

3. **En `auth_bloc.dart`:**
```dart
} on NewException catch (e) {
  add(OnRegisterErrorEvent(
    message: e.message,
    errorCode: e.code,
  ));
}
```

## 📚 Ejemplos de Uso

### **Registro de Usuario**

```dart
// En tu UI
void _registerUser() {
  context.read<AuthBloc>().add(RegisterUserEvent());
}
```

### **Login de Usuario**

```dart
// En tu UI
void _loginUser(String email, String password) {
  context.read<AuthBloc>().initLogin(email, password);
}
```

### **Limpiar Errores**

```dart
// En tu UI
void _clearErrors() {
  context.read<AuthBloc>().clearError();
}
```

## 🎯 Mejores Prácticas

1. **Siempre maneja errores específicos primero**
2. **Usa `ErrorUtils` como fallback**
3. **Proporciona mensajes amigables al usuario**
4. **Implementa retry para errores de red/servidor**
5. **Mantén la lógica de error separada del BLoC**

## 🤝 Contribución

Para contribuir al proyecto:
1. Sigue las convenciones de código existentes
2. Agrega tests para nuevas funcionalidades
3. Documenta cambios en el README
4. Usa el patrón de manejo de errores establecido

---

**¡Desarrollado con ❤️ para conductores de Uber!**