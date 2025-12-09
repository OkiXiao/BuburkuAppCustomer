class MenuItem {
  final String id;
  final String name;
  final int price;
  final String image;
  final String? description;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.description,
  });

  // Factory untuk ambil data dari Firestore
  factory MenuItem.fromFirestore(String id, Map<String, dynamic> data) {
    return MenuItem(
      id: id,
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      image: data['image'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
