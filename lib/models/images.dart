class ImagePermissionModel {
  final bool isGalleryAccessGranted;

  ImagePermissionModel({required this.isGalleryAccessGranted});

  factory ImagePermissionModel.fromJson(Map<String, dynamic> json) =>
      ImagePermissionModel(
        isGalleryAccessGranted: json['isGalleryAccessGranted'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'isGalleryAccessGranted': isGalleryAccessGranted,
      };
}
