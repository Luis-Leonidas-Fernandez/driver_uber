import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part 'images_event.dart';
part 'images_state.dart';

class ImagesBloc extends HydratedBloc<ImagesEvent, ImagesState> {
  ImagesBloc() : super(const ImagesState(isImagePermissionGranted: false)) {
    on<UpdateImagePermissionEvent>((event, emit) {
      emit(state.copyWith(isImagePermissionGranted: event.isGranted));
    });

    _initBloc();
  }

  Future<void> _initBloc() async {
    final granted = await _checkImagePermission();
    add(UpdateImagePermissionEvent(isGranted: granted));
  }

  Future<bool> _checkImagePermission() async {
    // Maneja Android e iOS
    if (await Permission.photos.isGranted) return true;
    if (await Permission.storage.isGranted) return true;
    return false;
  }

  Future<bool> requestImagePermission() async {
  // Pide permiso para fotos (iOS y Android 13+)
  final photosStatus = await Permission.photos.request();
  if (photosStatus.isGranted) {
    add(const UpdateImagePermissionEvent(isGranted: true));
    return true;
  }

  // Si es Android < 13, pide permiso de storage
  final storageStatus = await Permission.storage.request();
  final granted = storageStatus.isGranted;
  add(UpdateImagePermissionEvent(isGranted: granted));

  if (storageStatus.isPermanentlyDenied) {
    openAppSettings();
  }
  return granted;
}


  @override
  ImagesState? fromJson(Map<String, dynamic> json) {
    try {
      return ImagesState(
        isImagePermissionGranted: json['isImagePermissionGranted'] as bool? ?? false,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ImagesState state) {
    return {
      'isImagePermissionGranted': state.isImagePermissionGranted,
    };
  }


}
