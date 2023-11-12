import 'package:carg/models/carg_object.dart';
import 'package:carg/models/iap/iap_source_enum.dart';
import 'package:carg/models/iap/product/product_type_enum.dart';

abstract class Purchase extends CargObject {
  final IAPSourceEnum iapSource;
  final String orderId;
  final String productId;
  final String? userId;
  final DateTime purchaseDate;
  final ProductTypeEnum type;

  Purchase({
    super.id,
    required this.iapSource,
    required this.orderId,
    required this.productId,
    required this.userId,
    required this.purchaseDate,
    required this.type,
  });

  @override
  Map<String, dynamic> toJSON() {
    return {
      'iap_source': iapSource.name,
      'order_id': orderId,
      'product_id': productId,
      'user_id': userId,
      'purchase_date': purchaseDate.toUtc().toIso8601String(),
      'type': type.name,
    };
  }

  bool isValid();

  String purchaseId(Purchase purchaseData) {
    return '${purchaseData.iapSource.name}_${purchaseData.orderId}';
  }
}
