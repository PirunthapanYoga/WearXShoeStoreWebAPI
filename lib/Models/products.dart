import 'Price.dart';

class Product {
  String id;
  String sKU;
  String name;
  String brandName;
  String mainImage;
  Price price;
  List<String> sizes;
  String stockStatus;
  String colour;
  String description;

  Product({
    required this.id,
    required this.sKU,
    required this.name,
    required this.brandName,
    required this.mainImage,
    required this.price,
    required this.sizes,
    required this.stockStatus,
    required this.colour,
    required this.description});


  factory Product.fromJson(Map<String, dynamic> json) =>
      Product(
          id: json['id'],
          sKU: json['SKU'],
          name: json['name'],
          brandName: json['brandName'],
          mainImage: json['mainImage'],
          price: Price.fromJason(json['price']),
          sizes: json['sizes'].cast<String>(),
          stockStatus: json['stockStatus'],
          colour: json['colour'],
          description: json['description']
      );
}