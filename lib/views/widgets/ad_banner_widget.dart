import 'dart:developer' as developer;

import 'package:carg/helpers/ad_helper.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdBannerWidgetState();
  }
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  late BannerAd _bannerAd;
  Ad? _ad;

  void _createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId(context),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(
            () {
              _ad = ad;
            },
          );
        },
        onAdFailedToLoad: (ad, error) {
          developer.log(
            'Enable to load the ad : ${error.message}',
            name: 'carg.ad-banner',
          );
          _ad?.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void didChangeDependencies() {
    _createBannerAd();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.ease,
      duration: const Duration(milliseconds: 200),
      child: FutureBuilder<bool>(
        future: Provider.of<AuthService>(context, listen: false).isAdFreeUser(),
        builder: (context, snapshot) {
          if (_ad != null && snapshot.connectionState == ConnectionState.done) {
            return snapshot.data != null && !snapshot.data!
                ? Container(
                    key: const ValueKey('adContent'),
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    alignment: Alignment.center,
                    child: AdWidget(
                      ad: _bannerAd,
                    ),
                  )
                : Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
