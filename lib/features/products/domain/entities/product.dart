import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final int minQuantity; // Seuil d'alerte
  final String? supplierId;
  final String? supplierName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.minQuantity,
    this.supplierId,
    this.supplierName,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isLowStock => quantity <= minQuantity;

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    int? minQuantity,
    String? supplierId,
    String? supplierName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        quantity,
        minQuantity,
        supplierId,
        supplierName,
        createdAt,
        updatedAt,
      ];
}

