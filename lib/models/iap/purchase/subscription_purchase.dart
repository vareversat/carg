import 'package:carg/models/iap/product/product_type_enum.dart';
import 'package:carg/models/iap/purchase/purchase.dart';
import 'package:carg/models/iap/purchase/subscription_status_enum.dart';
import 'package:enum_to_string/enum_to_string.dart';

class SubscriptionPurchase extends Purchase {
  final SubscriptionStatusEnum status;
  final DateTime expiryDate;

  SubscriptionPurchase({
    super.id,
    required super.iapSource,
    required super.orderId,
    required super.productId,
    required super.userId,
    required super.purchaseDate,
    required this.status,
    required this.expiryDate,
    super.type = ProductTypeEnum.subscription,
  });

  @override
  Map<String, dynamic> toJSON() {
    final json = super.toJSON();
    json.addAll({
      'status': status.name,
      'expiry_date': expiryDate.toUtc().toIso8601String(),
    });
    return json;
  }

  factory SubscriptionPurchase.fromJSON(Map<String, dynamic>? json, String id) {
    return SubscriptionPurchase(
      id: id,
      iapSource: json?['iap_source'],
      orderId: json?['order_id'],
      productId: json?['product_id'],
      userId: json?['userId'],
      purchaseDate: DateTime.parse(json?['purchase_date']),
      type: EnumToString.fromString(ProductTypeEnum.values, json?['type'])!,
      status: EnumToString.fromString(
        SubscriptionStatusEnum.values,
        json?['status'],
      )!,
      expiryDate: DateTime.parse(json?['expiry_date']),
    );
  }

  @override
  bool isValid() {
    return status == SubscriptionStatusEnum.active;
  }
}
