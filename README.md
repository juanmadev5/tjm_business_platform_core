# TJM Business Platform

Es un **sistema de gestión empresarial (ERP/CRM ligero)** diseñado para ayudar a los administradores a llevar un control detallado de las operaciones de su negocio. Permite **monitorear indicadores clave** (ingresos, gastos, beneficio), **gestionar clientes**, y **crear/visualizar/editar reportes** y registros de compras.

## 🖼️ Capturas de Pantalla

<table>
  <tr>
    <td><img src="assets/screenshot1.jpg" height="480px"/></td>
    <td><img src="assets/screenshot2.jpg" height="480px"/></td>
      <td><img src="assets/screenshot3.jpg" height="480px"/></td>
    <td><img src="assets/screenshot4.jpg" height="480px"/></td>
  </tr>
</table>

## Stack Tecnológico y Arquitectura

* **Tecnología Principal (Frontend):** **Flutter** (Dart), lo que garantiza la capacidad de ser **multiplataforma** (iOS, Android, Web, **Windows** y **Linux**).
* **Backend & Base de Datos:** **Supabase** (Auth y Base de Datos), utilizado para el manejo de la autenticación de usuarios y la persistencia de los datos del negocio (clientes, reportes, compras).
* **Arquitectura del Código:** El proyecto está estructurado de manera modular en dos paquetes principales:
    * **`tjm_business_platform_frontend`:** Contiene la interfaz de usuario (UI) y la lógica de presentación.
    * **`tjm_business_platform_logic`:** Una librería separada que actúa como la **Capa de Dominio y la Capa de Datos**, abstrayendo toda la comunicación con Supabase.
    * Esta librería es la **única** que tiene la dependencia directa de `supabase`.
    * Para acceder a las funcionalidades de la capa de dominio desde el frontend, se utilizan instancias de las clases `Auth` y `Data`:
    
    ```dart
        Auth auth = Auth();
        Data data = Data();
    ```

## ⚙️ Configuración e Instalación

### 1. Requisitos

* [Flutter SDK](https://flutter.dev/docs/get-started/install) (versión compatible con Dart ^3.10.0)
* IDE (VS Code o Android Studio)
* **Una instancia de Supabase** (URL del proyecto y Clave API Anónima).

### 2. Clonar el Repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd tjm_business_platform
````

### 3\. Configuración de Dependencias

Ejecuta el siguiente comando en el directorio principal para asegurar que los dos paquetes (frontend y logic) resuelvan sus dependencias, incluyendo la dependencia local.

```bash
flutter pub get
```

### 4\. Configuración de Entorno

Debes configurar tu URL y Key de Supabase. Estos valores se deben colocar en el archivo `secrets.dart` del módulo `tjm_business_platform_frontend`.

> **NOTA:** Asegúrate de no subir `secrets.dart` al control de versiones (Git). Se recomienda incluirlo en el `.gitignore`.

```dart
// tjm_business_platform_frontend/lib/secrets.dart
const String supabaseUrl = 'TU_SUPABASE_URL';
const String supabaseAnonKey = 'TU_SUPABASE_ANON_KEY';
```

### 5\. Configuración de la Base de Datos

Ejecuta el script SQL en tu instancia de Supabase para crear las tablas necesarias:

```bash
# El archivo database.sql contiene el esquema necesario
# Sube el contenido de database.sql a tu SQL Editor de Supabase.
```
