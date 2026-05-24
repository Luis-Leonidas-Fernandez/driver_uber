import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'images_event.dart';
part 'images_state.dart';

class ImagesBloc extends HydratedBloc<ImagesEvent, ImagesState> {
  ImagesBloc() : super(const ImagesState(isImagePermissionGranted: true)) {
    on<UpdateImagePermissionEvent>((event, emit) {
      emit(state.copyWith(isImagePermissionGranted: event.isGranted));
    });
  }

  Future<bool> requestImagePermission() async {
    add(const UpdateImagePermissionEvent(isGranted: true));
    return true;
  }


  @override
  ImagesState? fromJson(Map<String, dynamic> json) {
    try {
      return ImagesState(
        isImagePermissionGranted: json['isImagePermissionGranted'] as bool? ?? true,
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
