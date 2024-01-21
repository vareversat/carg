import 'package:carg/models/iap/iap_source_enum.dart';
import 'package:carg/models/iap/product/product_type_enum.dart';
import 'package:carg/models/iap/purchase/non_subscription_status_enum.dart';
import 'package:carg/models/iap/purchase/purchase.dart';
import 'package:enum_to_string/enum_to_string.dart';

class NonSubscriptionPurchase extends Purchase {
  final NonSubscriptionStatusEnum status;

  NonSubscriptionPurchase({
    super.id,
    required super.iapSource,
    required super.orderId,
    required super.productId,
    required super.userId,
    required super.purchaseDate,
    required this.status,
    super.type = ProductTypeEnum.nonSubscription,
  });

  @override
  Map<String, dynamic> toJSON() {
    final json = super.toJSON();
    json.addAll({
      'status': status.name,
    });
    return json;
  }

  factory NonSubscriptionPurchase.fromJSON(
      Map<String, dynamic>? json, String id) {
    return NonSubscriptionPurchase(
        id: id,
        iapSource:
            EnumToString.fromString(IAPSourceEnum.values, json?['iap_source'])!,
        orderId: json?['order_id'],
        productId: json?['product_id'],
        userId: json?['user_id'],
        purchaseDate: DateTime.parse(json?['purchase_date']),
        type: EnumToString.fromString(ProductTypeEnum.values, json?['type'])!,
        status: EnumToString.fromString(
            NonSubscriptionStatusEnum.values, json?['status'])!);
  }

  @override
  bool isValid() {
    return status == NonSubscriptionStatusEnum.purchased;
  }
}
