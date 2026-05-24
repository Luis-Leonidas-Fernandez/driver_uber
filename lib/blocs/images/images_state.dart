part of 'images_bloc.dart';

class ImagesState extends Equatable {
  final bool isImagePermissionGranted;

  const ImagesState({required this.isImagePermissionGranted});

  ImagesState copyWith({
    bool? isImagePermissionGranted,
  }) {
    return ImagesState(
      isImagePermissionGranted: isImagePermissionGranted ?? this.isImagePermissionGranted,
    );
  }

  @override
  List<Object> get props => [isImagePermissionGranted];
}
