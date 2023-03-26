import 'package:mywebstore/Models/products.dart';

class CartItem extends Product {
  String selectedSizes;
  int count;

  CartItem({
    required this.selectedSizes,
    required super.id,
    required super.sKU,
    required super.name,
    required super.brandName,
    required super.mainImage,
    required super.price,
    required super.stockStatus,
    required super.colour,
    required super.description,
    required super.sizes,
    required this.count,
  });
}