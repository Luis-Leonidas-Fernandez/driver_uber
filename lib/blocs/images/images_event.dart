part of 'images_bloc.dart';

abstract class ImagesEvent extends Equatable {
  const ImagesEvent();

  @override
  List<Object> get props => [];
}

class UpdateImagePermissionEvent extends ImagesEvent {
  final bool isGranted;

  const UpdateImagePermissionEvent({required this.isGranted});

  @override
  List<Object> get props => [isGranted];
}
