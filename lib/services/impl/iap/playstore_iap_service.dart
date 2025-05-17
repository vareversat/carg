import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:carg/const.dart';
import 'package:carg/exceptions/iap_exception.dart';
import 'package:carg/models/iap/iap_source_enum.dart';
import 'package:carg/models/iap/product/product_data.dart';
import 'package:carg/models/iap/purchase/non_subscription_purchase.dart';
import 'package:carg/models/iap/purchase/non_subscription_status_enum.dart';
import 'package:carg/models/iap/purchase/subscription_purchase.dart';
import 'package:carg/models/iap/purchase/subscription_status_enum.dart';
import 'package:carg/repositories/abstract_iap_repository.dart';
import 'package:carg/repositories/impl/iap_repository.dart';
import 'package:carg/services/iap/abstract_iap_service.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/androidpublisher/v3.dart' as ap;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart';

class PlayStoreIAPService extends AbstractIAPService {
  late final ap.AndroidPublisherApi androidPublisher;
  late final AbstractIAPRepository iapRepository;

  PlayStoreIAPService({
    ap.AndroidPublisherApi? androidPublisher,
    AbstractIAPRepository? iapRepository,
  }) {
    this.iapRepository = iapRepository ?? IAPRepository();
    this.androidPublisher =
        androidPublisher ?? ap.AndroidPublisherApi(Client());
  }

  Future<ap.AndroidPublisherApi?> _getApiPublisherAccess() async {
    final googleApiConfig = jsonDecode(
      await rootBundle.loadString(Const.googleApiKey),
    );
    final credentials = auth.ServiceAccountCredentials.fromJson(
      googleApiConfig,
    );
    const scopes = [ap.AndroidPublisherApi.androidpublisherScope];
    var client = await auth.clientViaServiceAccount(credentials, scopes);
    return ap.AndroidPublisherApi(client);
  }

  /// If a subscription suffix is present (..#) extract the orderId.
  String _extractOrderId(String orderId) {
    final orderIdSplit = orderId.split('..');
    if (orderIdSplit.isNotEmpty) {
      orderId = orderIdSplit[0];
    }
    return orderId;
  }

  @override
  Future<bool> handleNonSubscription({
    required String? userId,
    required ProductData productData,
    required String token,
  }) async {
    try {
      // Verify purchase with Google
      var apiPublisherAccess = await _getApiPublisherAccess();
      if (apiPublisherAccess == null) {
        return false;
      }
      // Fetch the purchase
      var productPurchases = await apiPublisherAccess.purchases.products.get(
        Const.packageId,
        productData.productId,
        token,
      );
      developer.log('Google API call : OK', name: 'carg.iap-playstore');
      purchaseStatus += "\nValidation auprès de Google effectuée ✔️";
      notifyListeners();

      // Make sure an order id exists
      if (productPurchases.orderId == null) {
        developer.log(
          'Could not handle purchase without order id',
          name: 'carg.iap-playstore',
        );
        return false;
      }

      final orderId = productPurchases.orderId!;

      final purchaseData = NonSubscriptionPurchase(
        purchaseDate: DateTime.fromMillisecondsSinceEpoch(
          int.parse(productPurchases.purchaseTimeMillis ?? '0'),
        ),
        orderId: orderId,
        productId: productData.productId,
        status: nonSubscriptionStatusFrom(productPurchases.purchaseState),
        userId: userId,
        iapSource: IAPSourceEnum.google_play,
      );

      // Update the database
      if (userId != null) {
        await iapRepository.createOrUpdate(purchaseData);
      } else {
        developer.log('No userId was provided', name: 'carg.iap-playstore');
        return false;
      }
      developer.log('Database update : OK', name: 'carg.iap-playstore');
      purchaseStatus += "\nIntégrité validée ✔️";
      notifyListeners();
      purchaseStatus += "\n\nAchat validé. Merci ! 💖";
      notifyListeners();
      return true;
    } on ap.DetailedApiRequestError catch (e) {
      developer.log(
        'Error on handle NonSubscription: $e\n'
        'JSON: ${e.jsonResponse}',
        name: 'carg.iap-playstore',
      );
      purchaseStatus += "\nErreur durant le traitement ❌";
      throw IAPException('Error on handle NonSubscription : ${e.jsonResponse}');
    } catch (e) {
      developer.log(
        'Error on handle NonSubscription: $e\n',
        name: 'carg.iap-playstore',
      );
      purchaseStatus += "\nErreur durant le traitement ❌";
      throw IAPException('Error on handle NonSubscription : ${e.toString()}');
    }
  }

  /// Handle subscription purchases.
  ///
  /// Retrieves the purchase status from Google Play and updates
  /// the Firestore Database accordingly.
  @override
  Future<bool> handleSubscription({
    required String? userId,
    required ProductData productData,
    required String token,
  }) async {
    developer.log(
      'GooglePlayPurchaseHandler.handleSubscription'
      '($userId, ${productData.productId}, ${token.substring(0, 5)}...)',
      name: 'carg.iap-playstore',
    );

    try {
      // Verify purchase with Google
      var apiPublisherAccess = await _getApiPublisherAccess();
      if (apiPublisherAccess == null) {
        return false;
      }
      // Fetch the purchase
      var productPurchases = await apiPublisherAccess.purchases.subscriptions
          .get(Const.packageId, productData.productId, token);

      // Make sure an order id exists
      if (productPurchases.orderId == null) {
        developer.log(
          'Could not handle purchase without order id',
          name: 'carg.iap-playstore',
        );
        return false;
      }
      final orderId = _extractOrderId(productPurchases.orderId!);

      final purchaseData = SubscriptionPurchase(
        purchaseDate: DateTime.fromMillisecondsSinceEpoch(
          int.parse(productPurchases.startTimeMillis ?? '0'),
        ),
        orderId: orderId,
        productId: productData.productId,
        status: subscriptionStatusFrom(productPurchases.paymentState),
        userId: userId,
        iapSource: IAPSourceEnum.google_play,
        expiryDate: DateTime.fromMillisecondsSinceEpoch(
          int.parse(productPurchases.expiryTimeMillis ?? '0'),
        ),
      );

      // Update the database
      if (userId != null) {
        await iapRepository.createOrUpdate(purchaseData);
      } else {
        developer.log('No userId was provided', name: 'carg.iap-playstore');
        return false;
      }
      return true;
    } on ap.DetailedApiRequestError catch (e) {
      developer.log(
        'Error on handle Subscription: $e\n'
        'JSON: ${e.jsonResponse}',
        name: 'carg.iap-playstore',
      );
      throw IAPException('Error on handle Subscription : ${e.jsonResponse}');
    } catch (e) {
      developer.log(
        'Error on handle NonSubscription: $e\n',
        name: 'carg.iap-playstore',
      );
      throw IAPException('Error on handle Subscription : ${e.toString()}');
    }
  }
}
