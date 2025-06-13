# 📱 App de Gestión de Tareas para Personal de Aseo

Esta aplicación móvil permite al personal de aseo visualizar, gestionar y actualizar el estado de las residencias asignadas, con múltiples
funciones como el uso de mapa para la ubicación actual del usuario y dirección de las residencias. Asimismo, esta aplicación cuenta
con un historial completo de las residencias con estado 'Hecho' e incluso un filtro de búsqueda utilizando el nombre o dirección.
Esta plataforma esstá desarrollada con Flutter y se utiliza emuladores de Android Studio para el despliegue.

---

## 🛠️ Manual de Instalación (modo local)

### ✅ Requisitos previos

- Sistema Operativo Windows, macOs o Linux
- Android Studio 
- Android toolchain (Android SDK)
- Chrome - develop for the web 
- Visual Studio
- Flutter SDK instalado

Si no tieneas alguno de estos programas, aquí tienes un manual de instalación:

### 📥 1. Instalar Android Studio
1. Ir a la página oficial: https://developer.android.com/studio
2. Descargar el instalador correspondiente a tu sistema operativo.
3. Ejecutar el instalador.
4. En el Setup Wizard, asegúrate de marcar:
   1) Android Studio
   2) Android SDK
   3) Android Virtual Device
4. Esperar que descargue las herramientas necesarias.
5. Una vez iniciado Android Studio, navegar a:
   File > Settings > Appearance & Behavior > System Settings > Android SDK
y asegurarse de tener instalada una versión reciente del SDK. 

### 📥 2. Instalar Android Toolchain (Android SDK)
Generalmente se instala junto a Android Studio, pero si lo quieres instalar manualmente o actualizarlo:
1. Abrir Android Studio.
2. Ir a: 
   File > Settings > Appearance & Behavior > System Settings > Android SDK
3. Podrá visualizar la ubicación del SDK.

### 📥 3. Instalar Chrome (para desarrollo web con Flutter)
Flutter puede compilar aplicaciones para la web directamente en Chrome.
1. Descargar Chrome desde: https://www.google.com/chrome/
2. Instalar normalmente.
3. Flutter lo detectará automáticamente si está en la ruta por defecto.
4. Para verificar: 
   ```bash
    flutter devices
Debes ver Chrome como uno de los dispositivos disponibles.

### 📥 4. Instalar Visual Studio (para desarrollo en Windows con Flutter)
Es Visual Studio (IDE), no confundir con Visual Studio Code.
1. Ir a la página oficial: https://visualstudio.microsoft.com/es/
2. Descargar Visual Studio Community 2022.
3. Durante la instalación, marca el "Desarrollo para escritorio con C++".

Es necesario para compilar aplicaciones Windows con Flutter.

Completa la instalación y reinicia si es necesario.
4. Para verificar: 
   ```bash
    flutter doctor

### 📥 5. Instalar Flutter

1. Descarga Flutter SDK desde [flutter.dev](https://flutter.dev).
2. Extrae y agrega Flutter al PATH del sistema.
3. Verifica la instalación:
   ```bash
    flutter doctor

Al ejecutar 'flutter doctor' en la terminal, deberá visualizar una lista de los programas necesarios para desplegar el proyecto

### 📥 6. Descarga e instalación
1) Descarga la carpeta del archivo.
2) Navega a la carpeto del proyecto con: 
   cd ruta/proyecto
3) Instala dependencias con el siguiente código en la terminal:
   flutter pub get

### 📱 7. Ejecutar en emulador o dispositivo
Teniendo el emulador activo o el dispositivo conectado, ejecutar lo siguiente:
   ```bash
    flutter devices
    flutter run
