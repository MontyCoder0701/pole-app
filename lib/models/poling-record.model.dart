class PolingRecord {
  final String? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String videoId;
  final DateTime videoDate;
  final List<String> tags;
  final String memo;

  PolingRecord({
    this.id,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deletedAt,
    required this.videoId,
    required this.videoDate,
    required this.tags,
    required this.memo,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory PolingRecord.fromJson(Map<String, dynamic> json) {
    return PolingRecord(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      videoId: json['videoId'] as String,
      videoDate: DateTime.parse(json['videoDate'] as String),
      tags: List<String>.from(json['tags'] as List),
      memo: json['memo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'videoId': videoId,
      'videoDate': videoDate.toIso8601String(),
      'tags': tags,
      'memo': memo,
    };
  }
}
