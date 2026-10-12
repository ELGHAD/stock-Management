import 'package:equatable/equatable.dart';

enum MovementType { entry, exit }

class StockMovement extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final MovementType type;
  final int quantity;
  final String? reason;
  final DateTime date;

  const StockMovement({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    this.reason,
    required this.date,
  });

  @override
  List<Object?> get props => [id, productId, productName, type, quantity, reason, date];
}

