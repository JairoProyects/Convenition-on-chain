class ProfileImageResponse {
  final String imageUrl;

  ProfileImageResponse({ required this.imageUrl });

  factory ProfileImageResponse.fromJson(Map<String, dynamic> json) {
    return ProfileImageResponse(
      imageUrl: json['imageUrl'] as String,
    );
  }
}
