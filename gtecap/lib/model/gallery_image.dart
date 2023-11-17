class GalleryImageModel {
  List<String> transferImage;
  List<String> receivedImage;
  String status;

  GalleryImageModel({
    required this.transferImage,
    required this.receivedImage,
    required this.status,
  });

  factory GalleryImageModel.fromJson(Map<String, dynamic> json) {
    return GalleryImageModel(
      transferImage: List<String>.from(json['transfer_image']),
      receivedImage: List<String>.from(json['received_image']),
      status: json['status'],
    );
  }
}
