import 'package:carg/models/iap/purchase/purchase.dart';

class FakePurchase extends Purchase {
  FakePurchase(
      {super.id,
      required super.iapSource,
      required super.orderId,
      required super.productId,
      required super.userId,
      required super.purchaseDate,
      required super.type});

  @override
  bool isValid() {
    return true;
  }
}
