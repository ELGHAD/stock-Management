import 'package:stock_management/features/stock/domain/entities/stock_movement.dart';

class StockMovementModel extends StockMovement {
  const StockMovementModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.type,
    required super.quantity,
    super.reason,
    required super.date,
  });

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    return StockMovementModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      type: MovementType.values.firstWhere(
        (e) => e.toString() == 'MovementType.${json['type']}',
        orElse: () => MovementType.entry,
      ),
      quantity: json['quantity'] as int,
      reason: json['reason'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'type': type.toString().split('.').last,
      'quantity': quantity,
      'reason': reason,
      'date': date.toIso8601String(),
    };
  }

  factory StockMovementModel.fromHive(Map<dynamic, dynamic> map) {
    return StockMovementModel(
      id: map['id'] as String,
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      type: MovementType.values.firstWhere(
        (e) => e.toString() == 'MovementType.${map['type']}',
        orElse: () => MovementType.entry,
      ),
      quantity: map['quantity'] as int,
      reason: map['reason'] as String?,
      date: DateTime.parse(map['date'] as String),
    );
  }

  Map<String, dynamic> toHive() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'type': type.toString().split('.').last,
      'quantity': quantity,
      'reason': reason,
      'date': date.toIso8601String(),
    };
  }
}

