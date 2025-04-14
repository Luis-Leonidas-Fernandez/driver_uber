// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
//import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:inri_driver/service/addresses_service.dart';
import 'package:inri_driver/service/location_service.dart';

class BackgroundService {
  BackgroundService._internal();

  static final BackgroundService _instance = BackgroundService._internal();
  static BackgroundService get instance => _instance;

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground',
      'MY FOREGROUND SERVICE',
      description: 'This channel is used for important notifications.',
      importance: Importance.low,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_bg_service_small'),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'UBICACIÓN ACTIVA',
        initialNotificationContent: 'SERVICIO INRI ACTIVO',
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [
          AndroidForegroundType.location,
          AndroidForegroundType.dataSync],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {

  WidgetsFlutterBinding.ensureInitialized(); // 🔥 IMPORTANTE
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  // Configuración del canal de notificación
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description: 'Este canal es usado para notificaciones importantes.',
    importance: Importance.low,
  );

  // Configuración de la notificación inicial
  final notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.low,
      priority: Priority.low,
      icon: 'ic_bg_service_small', // Asegúrate de tener este ícono en tu proyecto
    ),
  );    

  // Mostrar notificación lo antes posible para evitar crash
  if (service is AndroidServiceInstance) {

    // Llama a startForeground lo más rápido posible
    await service.setAsForegroundService();
    await service.setForegroundNotificationInfo(
      title: "Servicio INRI Activo",
      content: "Esperando órdenes de viaje...",
    );

    // Muestra la notificación inicial
    await flutterLocalNotificationsPlugin.show(
      888, // ID de notificación
      "Servicio INRI Activo",
      "Esperando órdenes de viaje...",
      notificationDetails,
    );

    final isForeground = await service.isForegroundService();
    debugPrint('🟢 ¿Está en Foreground? $isForeground');

    // Listeners
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  // Timer que corre cada 1 minuto
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    try {
      final isActiveOrder = await LocationService.instance.isActiveOrder();
      final existUserIdAndToken =
          await LocationService.instance.getIdUserAndToken();

      if (isActiveOrder && existUserIdAndToken) {
        if (service is AndroidServiceInstance &&
            await service.isForegroundService()) {
          final hasAddress = await existAddress();

          if (hasAddress) {
            final now = DateTime.now();
            const color = Colors.indigo;
            final fecha = "${now.day}-${now.month}-${now.year}";
            final hora = "${now.hour}:${now.minute}";
            const message = 'Felicitaciones, tienes un nuevo viaje!';

            flutterLocalNotificationsPlugin.show(
              888,
              'NUEVO MENSAJE: $message',
              'Fecha: $fecha Hora: $hora',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: '@drawable/car_launcher',
                  importance: Importance.max,
                  priority: Priority.high,
                  largeIcon:
                      DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
                  color: color,
                  colorized: true,
                ),
              ),
            );
          }
        }
      }
    } catch (e, stack) {
      print("❌ Error en background: $e\n$stack");
    }
  });
}

Future<bool> existAddress() async {
  final address = await AddressService().getAddressesBackground();
  return address.id != null;
}


