class MusicModel {
  String? path;
  String? name;
  String? duration;

  MusicModel({
    required this.path,
    required this.name,
    required this.duration,
  });

  factory MusicModel.fromJson(Map<String, Object?> json) => MusicModel(
        path: json["path"] as String?,
        name: json["name"] as String?,
        duration: json["duration"] as String?,
      );
}
