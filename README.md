![Flutter](https://img.shields.io/badge/Flutter-v3.27-blue)


# 🚕 Conductores INRI - App de Viajes Tipo Uber

Aplicación móvil desarrollada con Flutter inspirada en la lógica de Uber, donde los conductores pueden recibir viajes y seguir el estado del mismo en tiempo real.

---

## 📱 Características

- Registro e inicio de sesión de conductores
- Subscripción a bases específicas  
- Recepción de viajes  
- Asignación dinámica de viajes
- Visualización de precio por espera y kilometros recorridos  
- Seguimiento en tiempo real en el mapa  
- Finalización del viaje  
- Notificaciones visuales personalizadas (SnackBars)  
- Estado persistente con Hydrated Bloc  

---

## 🛠️ Tecnologías

- **Flutter** (Frontend)  
- **Dart** (Lógica)  
- **Node.js + Express** (Backend)  
- **MongoDB** (Base de datos)  
- **Hydrated Bloc** para manejo de estado persistente  
- **Mapbox** para mapas  

---

## 🚀 Instalación local

1. Cloná el proyecto:

   ```bash
   git clone https://github.com/tu-usuario/usuarios_uber.git
   cd usuarios_uber
   ```

2. Instalá las dependencias:

   ```bash
   flutter pub get
   ```

3. Configurá tu backend en:

   ```
   lib/global/environment.dart
   ```

4. Ejecutá la app:

   ```bash
   flutter run
   ```

---

## 🔐 Seguridad

- Implementación futura de mTLS, WAF y firewalls personalizados  
- Tokens protegidos  
- Persistencia controlada de información  

---
## 📷 Capturas de pantalla

### Splash screen
![Splash](screenshots/splash.png)

### Inicio de sesión
![Login](screenshots/login.png)

### Politicas de Privacidad
![Privacy](screenshots/privacy.png)

### Home de la app donde el conductor se suscribe a una base
![Home](screenshots/home.png)

### Home de la app con una  solicitud de viaje
![Home](screenshots/home.png)


### Home de la app con la opcion de cancelar viaje
![Cancel](screenshots/cancel.png)


### Home de la app conductor avisa de su llegada
![Arrivo](screenshots/arrivo.png)


### Home de la app mostrando las tarifas
![Tarifa](screenshots/tarifa.png)

---
## 📬 Contacto

**Luis Leonidas Fernández**  
Flutter Developer (Chaco, Argentina)  
📧 Email: fernandezluis303@gmail.com  
🌐 GitHub: [https://github.com/Luis-Leonidas-Fernandez](https://github.com/Luis-Leonidas-Fernandez)
