import 'package:mywebstore/Models/products.dart';

class Store{
  List<Product>? product;

  Store({
    this.product
  });

  factory Store.fromJson(Map<String , dynamic> json) => Store(
    product: List<Product>.from(json["data"].map((x) => Product.fromJson(x)))
  );
}