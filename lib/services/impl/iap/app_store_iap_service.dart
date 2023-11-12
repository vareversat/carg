import 'dart:convert';
import 'dart:developer' as developer;

import 'package:carg/const.dart';
import 'package:carg/models/iap/product/product_data.dart';
import 'package:carg/services/iap/abstract_iap_service.dart';
import 'package:http/http.dart' as http;

class AppStoreIAPService extends AbstractIAPService {
  @override
  Future<bool> handleNonSubscription({
    required String userId,
    required ProductData productData,
    required String token,
  }) {
    return handleValidation(userId: userId, token: token);
  }

  @override
  Future<bool> handleSubscription({
    required String userId,
    required ProductData productData,
    required String token,
  }) {
    return handleValidation(userId: userId, token: token);
  }

  Future<bool> handleValidation({
    required String userId,
    required String token,
  }) async {
    developer.log('AppStoreIAPService.handleValidation');
    developer.log('userId: $userId');
    developer.log('token: $token');
    // See documentation at https://developer.apple.com/documentation/appstorereceipts/verifyreceipt
    // final url = Uri.parse('https://buy.itunes.apple.com/verifyReceipt');
    final url = Uri.parse('https://sandbox.itunes.apple.com/verifyReceipt');
    const headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      url,
      body: jsonEncode({
        'receipt-data': token,
        'password': Const.appStoreSharedSecret,
      }),
      headers: headers,
    );
    final Map<String, dynamic> json = jsonDecode(response.body);
    final status = json['status'] as int;
    if (status == 0) {
      developer.log('Successfully verified purchase');

      return true;
    } else {
      developer.log('Error: Status: $status');

      return false;
    }
  }
}
