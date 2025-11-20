# TJM Business Platform

A comprehensive business management solution designed to streamline operations, manage customers, track expenses, and generate insightful reports.

## Features

*   **Dashboard**: Get a quick overview of your business performance with key metrics and charts.
*   **Customer Management**: Easily add, edit, and view detailed customer information and their work history.
*   **Expense Tracking**: Keep track of all your business expenses and purchases in one place.
*   **Reporting**: Generate detailed reports to analyze income, expenses, and overall profitability.
*   **Authentication**: Secure access to your business data with user authentication.

## Screenshots

<table>
  <tr>
    <td><img src="assets/screenshot-1.png" width="200" alt="Dashboard Screenshot"></td>
    <td><img src="assets/screenshot-2.png" width="200" alt="Customer Management Screenshot"></td>
    <td><img src="assets/screenshot-3.png" width="200" alt="Expense Tracking Screenshot"></td>
    <td><img src="assets/screenshot-4.png" width="200" alt="Reporting Screenshot"></td>
  </tr>
</table>

## Tech Stack

*   **Frontend**: Flutter
*   **Backend**: Supabase
*   **Desktop Integration**: Window Manager

## Platform Support

This application has been tested and verified on the following platforms (because I don't have a Mac to compile for `iOS/macOS`):

*   ✅ Android
*   ✅ Windows
*   ✅ Linux

## Installation

To run this project locally, follow these steps:

1.  **Prerequisites**: Ensure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.

2.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd tjm_business_platform
    ```

3.  **Install dependencies**:
    Navigate to the frontend directory:
    ```bash
    cd tjm_business_platform_frontend
    flutter pub get
    ```
    Navigate to the logic directory:
    ```bash
    cd tjm_business_platform_logic
    dart pub get
    ```

4.  **Run the app**:
    ```bash
    flutter run
    ```

## Supabase configuration

1.  **Supabase account**: 
    Log in or create an account at [Supabase](https://supabase.com/).

2.  **Create a new project**:
    Click on create a new project, ensure to create your project at the nearest region.
    
3.  **Create database**:
    Copy the `sql` script from `database.sql` and paste it in the `SQL Editor` then execute all except:
    ```SQL
        insert into users (id, name, last_name, email, phone_number, role)
        values (
            '280ed459-f54e-4af3-b6d5',  -- id that Supabase Auth returns
            'Juan Manuel',             -- name
            'Velázquez',               -- last name
            'itzjuanmadev@proton.me', -- email
            '+595900000000',           -- phone number
            'admin'                    -- role
        );
    ```
4.  **Create user for `Auth`**:
    Go to `Authentication` panel to Add a new user. After create a user, copy the `UID` of the new user.
5.  **Register user to allow Login**:
    Complete all fields of the `insert` query
    ```sql
        insert into users (id, name, last_name, email, phone_number, role)
        values (
            'id-you-copied',  -- id that Supabase Auth returns
            'name',             -- name
            'last-name',               -- last name
            'mail@mail.com', -- email
            '123456789',           -- phone number
            'admin'                    -- role
        );
    ```
    Always follow steps `3` and `4` if you want to add more users.
    Use role `admin` to have full platform control.
    
6.  **Put secrets on the app**:
    Create a `secrets.dart` at `tjm_business_platform_frontend/lib` and put:
    ```dart
      String SUPABASE_URL = "https://yourprojecturl.supabase.co";
      String SUPABASE_KEY = "project-api-key";
    ```
    
    To get your project id just click on `Connect` on Supabase, select `Mobile Frameworks` and copy the project URL. Then go to the side bar in Supabase and click on `Project Settings` and `API Keys` then create a new one.
    
    Then put the Project ID and API Key on `SUPABASE_URL` and `SUPABASE_KEY` respective.

## Customize the platform for your business

You can go to `tjm_business_platform_frontend/lib/core/app_settings.dart` and change the app name by your own business name or change the number format.

Also you can go to `tjm_business_platform_frontend/assets/` and change the app icon and the businnes logo. If you change the app's icon, ensure to run `dart run flutter_launcher_icons -f flutter_launcher_icons.yaml` and then compile the app.

