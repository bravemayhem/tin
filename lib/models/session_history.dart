import 'product_type.dart';

class SessionHistory {
  final String productId;
  final int durationSeconds;
  final String timestamp;

  SessionHistory({
    required this.productId,
    required this.durationSeconds,
    required this.timestamp,
  });

  ProductType get product {
    return ProductType.all.firstWhere(
      (p) => p.id == productId,
      orElse: () => ProductType.tampon,
    );
  }

  String get formattedDuration {
    final h = (durationSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((durationSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
