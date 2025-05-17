import 'dart:async';
import 'dart:developer' as developer;

import 'package:carg/const.dart';
import 'package:carg/models/iap/product/product_data.dart';
import 'package:carg/models/iap/product/product_type_enum.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/iap/abstract_iap_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:carg/l10n/app_localizations.dart';

class RemoveAdsListTile extends StatefulWidget {
  const RemoveAdsListTile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RemoveAdsListTileState();
  }
}

class _RemoveAdsListTileState extends State<RemoveAdsListTile> {
  final InAppPurchase iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late AbstractIAPService iapImplementation;

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      iapImplementation = AbstractIAPService.init(
        purchaseDetails.verificationData.source,
      );
      final userId =
          Provider.of<AuthService>(
            context,
            listen: false,
          ).getConnectedUserId()!;
      final token = purchaseDetails.verificationData.serverVerificationData;
      final productData = ProductData(
        purchaseDetails.productID,
        ProductTypeEnum.nonSubscription,
      );
      _purchaseStatusDialog(context);
      return iapImplementation.verifyPurchase(
        userId: userId,
        productData: productData,
        token: token,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> _freeAdsOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => SimpleDialog(
            contentPadding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                CustomProperties.borderRadius,
              ),
            ),
            children: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).cardColor,
                  ),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        CustomProperties.borderRadius,
                      ),
                    ),
                  ),
                ),
                onPressed:
                    () async => {
                      _buy(context),
                      Navigator.of(context).pop(true),
                    },
                child: Text(
                  AppLocalizations.of(context)!.buy,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).cardColor,
                  ),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        CustomProperties.borderRadius,
                      ),
                    ),
                  ),
                ),
                onPressed:
                    () async => {
                      _restorePurchase(),
                      Navigator.of(context).pop(true),
                    },
                child: Text(
                  AppLocalizations.of(context)!.restoreMyPurchase,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Future<dynamic> _purchaseStatusDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder:
          (BuildContext context) => ChangeNotifierProvider.value(
            value: iapImplementation,
            child: Consumer<AbstractIAPService>(
              builder:
                  (context, iapImplementationData, _) => SimpleDialog(
                    contentPadding: const EdgeInsets.all(24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    children: <Widget>[
                      Text(
                        iapImplementationData.purchaseStatus,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
            ),
          ),
    );
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    // Break when not mounted when restoring purchases
    try {
      if (mounted) {
        if (purchaseDetails.status == PurchaseStatus.purchased) {
          await iap.completePurchase(purchaseDetails);
          var validPurchase = await _verifyPurchase(purchaseDetails);
          if (validPurchase) {
            developer.log('Purchase is COMPLETED', name: 'carg.iap-tile');
          } else {
            developer.log(
              'Purchase KO during COMPLETE PROCESS',
              name: 'carg.iap-tile',
            );
          }
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          developer.log('Purchase is CANCELED', name: 'carg.iap-tile');
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          var validPurchase = await _verifyPurchase(purchaseDetails);
          if (validPurchase) {
            developer.log('Restore is COMPLETED', name: 'carg.iap-tile');
          } else {
            developer.log(
              'v KO during COMPLETE PROCESS',
              name: 'carg.iap-tile',
            );
          }
          developer.log('Purchase is RESTORED', name: 'carg.iap-tile');
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          developer.log(
            'Purchase is IN ERROR : ${purchaseDetails.error}',
            name: 'carg.iap-tile',
          );
        } else if (purchaseDetails.pendingCompletePurchase) {
          developer.log(
            'Purchase is PENDING_COMPLETE_PURCHASE',
            name: 'carg.iap-tile',
          );
        }
      }
    } catch (e) {
      InfoSnackBar.showErrorSnackBar(
        context,
        '${AppLocalizations.of(context)!.errorWhileRestoring} : ${e.toString()}',
      );
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
  }

  void _updateStreamOnDone() {
    developer.log('_updateStreamOnDone', name: 'carg.iap-tile');
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    developer.log('_updateStreamOnError', name: 'carg.iap-tile');
    _subscription.cancel();
  }

  Future<void> _restorePurchase() async {
    if (await iap.isAvailable()) {
      try {
        await iap.restorePurchases(applicationUserName: null);
      } on Exception {
        InfoSnackBar.showErrorSnackBar(
          context,
          AppLocalizations.of(context)!.errorWhileRestoring,
        );
      }
    } else {
      InfoSnackBar.showErrorSnackBar(
        context,
        AppLocalizations.of(context)!.cannotRestorePurchase,
      );
    }
  }

  Future<void> _buy(BuildContext context) async {
    if (await iap.isAvailable()) {
      try {
        var queryProductDetails = await iap.queryProductDetails({
          Const.iapFreeAdsProductId,
        });
        if (queryProductDetails.productDetails.isEmpty) {
          InfoSnackBar.showErrorSnackBar(
            context,
            AppLocalizations.of(context)!.noProducts,
          );
        } else {
          developer.log('Purchase PROCESS STARTING', name: 'carg.iap-tile');
          await iap.buyConsumable(
            purchaseParam: PurchaseParam(
              productDetails: queryProductDetails.productDetails[0],
            ),
          );
        }
      } on Exception {
        InfoSnackBar.showErrorSnackBar(
          context,
          AppLocalizations.of(context)!.errorDuringPurchase,
        );
      }
    } else {
      InfoSnackBar.showErrorSnackBar(
        context,
        AppLocalizations.of(context)!.cannotPurchase,
      );
    }
  }

  _RemoveAdsListTileState() {
    final purchaseUpdatedStream = iap.purchaseStream;
    _subscription = purchaseUpdatedStream.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedTileColor: Theme.of(context).primaryColor,
      key: const ValueKey('adFreeButton'),
      subtitle: Text(
        AppLocalizations.of(context)!.theAppWithoutAds,
        style: TextStyle(fontSize: 15, color: Theme.of(context).cardColor),
      ),
      selected: true,
      leading: Icon(
        FontAwesomeIcons.rectangleAd,
        size: 30,
        color: Theme.of(context).cardColor,
      ),
      onTap: () async => {await _freeAdsOptionsDialog(context)},
      title: Text(
        AppLocalizations.of(context)!.removeAds,
        style: TextStyle(color: Theme.of(context).cardColor, fontSize: 25),
      ),
    );
  }
}
