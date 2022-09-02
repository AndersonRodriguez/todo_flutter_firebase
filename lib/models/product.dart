import 'dart:convert';

class Product {
  String? id;
  String name;

  Product(this.name, {this.id});

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        json["name"],
        id: json["_id"],
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
      };
}

List<Product> productsFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Product>.from(data.map((item) => Product.fromMap(item)));
}
