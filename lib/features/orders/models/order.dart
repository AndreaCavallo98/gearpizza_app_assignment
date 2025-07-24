class Order {
  final int id;
  final String status;
  final String address;
  final String helpingIimage;
  final List<int> pizzas;

  Order({
    required this.id,
    required this.status,
    required this.address,
    required this.helpingIimage,
    required this.pizzas,
  });

  String get helpingImageUrl =>
      'https://gearpizza.revod.services/assets/$helpingIimage';

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      status: json['status'] as String,
      address: json['address'] as String,
      pizzas:
          (json['pizzas'] as List<dynamic>?)
              ?.map((a) => a['pizzas_id']?['id'] as int?)
              .whereType<int>() // filtra eventuali null
              .toList() ??
          [],
      helpingIimage: json['helping_image'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'address': address,
    'pizzas': pizzas,
    'helping_image': helpingIimage,
  };
}
