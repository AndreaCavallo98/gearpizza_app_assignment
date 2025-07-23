class Pizza {
  final int id;
  final String name;
  final String description;
  final List<String> allergens;
  final String? coverImageId;

  Pizza({
    required this.id,
    required this.name,
    required this.description,
    required this.allergens,
    this.coverImageId,
  });

  String get coverImageUrl =>
      'https://gearpizza.revod.services/assets/$coverImageId';

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      allergens:
          (json['allergens'] as List<dynamic>?)
              ?.map((a) => a['allergens_id']?['name'] as String?)
              .whereType<String>() // filtra eventuali null
              .toList() ??
          [],
      coverImageId: json['cover_image']?['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'allergens': allergens,
    'cover_image': coverImageId != null ? {'id': coverImageId} : null,
  };
}
