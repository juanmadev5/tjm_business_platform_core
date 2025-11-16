# TJM\_BUSINESS\_LOGIC ⚙️

Una biblioteca Dart **independiente** diseñada para encapsular la lógica de negocio, la gestión de datos y la autenticación, sirviendo como **cerebro** para la plataforma **TJM Business Platform** que se conectan a un servicio de base de datos (como **Supabase**).

Este proyecto sigue una arquitectura clara de separación de responsabilidades para facilitar el desarrollo, las pruebas unitarias y el mantenimiento.

## 🚀 Instalación y Uso

### 1\. Inicialización

```yaml
# tjm_business_platform_frontend/pubspec.yaml

dependencies:
  flutter:
    sdk: flutter
  
  # 👇 Agrega esta sección para conectar el paquete local
  tjm_business_platform_logic:
    path: ../tjm_business_platform_logic
  
  # Otros paquetes...
```

Después de modificar el `pubspec.yaml` de `tjm_business_platform_frontend` ejecuta:

```bash
flutter pub get
```

Antes de utilizar cualquier funcionalidad, debes inicializar la conexión al servicio usando `ClientLoader`.

```dart
import 'package:tjm_business_logic/client_loader.dart';

// En el main() o al iniciar la app
void main() {
  ClientLoader().initialize(
    supabaseUrl: 'TU_SUPABASE_URL',
    supabaseKey: 'TU_SUPABASE_ANON_KEY',
  );
  // ... código de Flutter
}
```

### 2\. Acceso a la Lógica de Dominio

La lógica de negocio se expone a través de dos *singletons* en la capa de **dominio**, garantizando un punto de acceso único y limpio para el *frontend*.

| Clase de Dominio | Responsabilidad Principal |
| :--- | :--- |
| **`Auth()`** | Manejo de la **autenticación** (login, logout, perfil de usuario). |
| **`Data()`** | Acceso a las **operaciones CRUD** de los modelos de negocio y cálculos de datos. |

#### Autenticación (`Auth`)

```dart
import 'package:tjm_business_logic/domain/auth.dart';
import 'package:tjm_business_logic/model/action_result.dart';

// Verificar estado de sesión
bool loggedIn = Auth().isLoggedIn();

// Iniciar sesión
ActionResult result = await Auth().login('email@ejemplo.com', 'contraseña123');
if (result == ActionResult.ok) {
  // Obtener perfil de usuario
  final user = await Auth().getUserProfile();
  print('Bienvenido: ${user?.name}');
}

// Cerrar sesión
await Auth().logout();
```

#### Operaciones de Datos (`Data`)

```dart
import 'package:tjm_business_logic/domain/data.dart';
import 'package:tjm_business_logic/model/report.dart';
import 'package:tjm_business_logic/model/customer.dart';

// Obtener todos los reportes
List<Report> reports = await Data().getAllReports();

// Añadir un nuevo cliente
final newCustomer = Customer(/* ...datos... */);
await Data().addNewCustomer(newCustomer);

// Realizar cálculos de negocio
double profit = await Data().getNetProfit();
print('Ganancia neta: $profit');
```

## 📐 Estructura del Proyecto

El proyecto está organizado en carpetas que reflejan las capas arquitectónicas clave (separación de la lógica de presentación, negocio y persistencia).

``` dart
TJM_BUSINESS_LOGIC/
├── lib/
│   ├── core/
│   │   ├── model/         # Clases de Modelos de Datos (DTOs) e Enums.
│   │   └── client/        # Lógica de Inicialización de Clientes.
│   ├── data/
│   │   ├── client/        # Implementación de Repositorios (Conexión a Supabase).
│   │   └── domain/        # Interfaces de Repositorios (Abstracción).
│   ├── domain/            # **Capa de Dominio/Uso (Acceso Principal)**.
│   └── utils/             # Funciones utilitarias generales (p.ej., formato).
└── test/                  # Pruebas Unitarias del Dominio con Mocking.
```

## 📦 Modelos de Datos (DTOs)

La capa `lib/core/model` define las estructuras de datos fundamentales de la aplicación.

| Clase | Descripción |
| :--- | :--- |
| **`Customer`** | Datos del cliente. |
| **`Expense`** | Registro de gastos. |
| **`PlatformUser`** | Perfil de usuario autenticado con su rol. |
| **`Report`** | Registro de trabajo o servicio realizado. |
| **`ActionResult`** | Enum simple para resultado de operaciones: `ok`, `error`. |
| **`Role`** | Enum de roles de usuario: `admin`, `user`, `accountant`. |

-----

## 🛠️ Utilidades

El proyecto proporciona utilidades enfocadas en el formato de moneda para el frontend, ubicado en `lib/utils/currency_format.dart`.

### Funciones de Moneda (Guaraníes - es\_PY)

| Función | Descripción | Ejemplo |
| :--- | :--- | :--- |
| **`formatDoubleToGs(double amount)`** | Formatea un `double` a un `String` con separadores de miles (e.g., `125000.0` -\> `"125.000"`). | `formatDoubleToGs(50000.0)` retorna `"50.000"` |
| **`parseGsToDouble(String amount)`** | Convierte una `String` formateada a un `double` para cálculos. | `parseGsToDouble("125.000")` retorna `125000.0` |

-----

## 🧪 Pruebas Unitarias

La lógica de negocio se prueba exhaustivamente en `test/project_logic_test.dart` utilizando **Mocks** (a través de `mockito`) para aislar la capa de dominio de la capa de persistencia (Repositorios).

### Ejecutar Pruebas

1. Genera el archivo de *mocks* (si has modificado Repositorios):

    ```bash
    dart run build_runner build
    ```

2. Ejecuta todos los tests:

    ```bash
    dart test
    ```

El *setup* de las pruebas asegura que los *singletons* de `Auth()` y `Data()` utilicen las implementaciones **mockeadas** para un testing determinista.

```dart
// Configuración de las pruebas
setUp(() {
  mockAuthRepo = MockAuthRepository();
  mockDataRepo = MockDataRepository();

  // Inyectar los mocks en los singletons de dominio
  Auth().auth = mockAuthRepo;
  Data().appDatabase = mockDataRepo;
});
// ... (Ejemplo: prueba de login)
test('login returns ActionResult.ok on successful login', () async {
  when(mockAuthRepo.login('...', '...')).thenAnswer((_) async => ActionResult.ok);
  final result = await Auth().login('...', '...');
  expect(result, ActionResult.ok);
  verify(mockAuthRepo.login('...', '...')).called(1);
});
```
