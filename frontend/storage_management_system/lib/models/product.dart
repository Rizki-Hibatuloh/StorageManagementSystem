class Product {
  final int id;
  final String name;
  final int qty;
  final int categoryId;
  final String? urlImage;

  Product({
    required this.id,
    required this.name,
    required this.qty,
    required this.categoryId,
    this.urlImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      qty: json['qty'],
      categoryId: json['categoryId'],
      urlImage: json['urlImage'],
    );
  }

  get updatedBy => null;

  get createdBy => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'categoryId': categoryId,
      'urlImage': urlImage,
    };
  }
}
