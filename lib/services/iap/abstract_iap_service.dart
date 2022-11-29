import 'package:carg/models/iap/iap_source_enum.dart';
import 'package:carg/models/iap/product/product_data.dart';
import 'package:carg/models/iap/product/product_type_enum.dart';
import 'package:carg/services/impl/iap/app_store_iap_service.dart';
import 'package:carg/services/impl/iap/playstore_iap_service.dart';
import 'package:flutter/material.dart';

/// Generic purchase handler,
abstract class AbstractIAPService with ChangeNotifier {
  String purchaseStatus = "Achat en cours d'initialization ⚙️";

  AbstractIAPService();

  factory AbstractIAPService.init(String source) {
    if (source == IAPSourceEnum.google_play.name) {
      return PlayStoreIAPService();
    } else if (source == IAPSourceEnum.app_store.name) {
      return AppStoreIAPService();
    } else {
      throw Exception(
          'Cannot get the correct IAP service from this source : $source');
    }
  }

  /// Verify if purchase is valid and update the database
  Future<bool> verifyPurchase({
    required String userId,
    required ProductData productData,
    required String token,
  }) async {
    switch (productData.type) {
      case ProductTypeEnum.subscription:
        return handleSubscription(
          userId: userId,
          productData: productData,
          token: token,
        );
      case ProductTypeEnum.nonSubscription:
        return handleNonSubscription(
          userId: userId,
          productData: productData,
          token: token,
        );
    }
  }

  /// Verify if non-subscription purchase (aka consumable) is valid
  /// and update the database
  Future<bool> handleNonSubscription({
    required String userId,
    required ProductData productData,
    required String token,
  });

  /// Verify if subscription purchase (aka non-consumable) is valid
  /// and update the database
  Future<bool> handleSubscription({
    required String userId,
    required ProductData productData,
    required String token,
  });
}
