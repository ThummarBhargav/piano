import 'package:flutter_piano/constants/AdsManager/ad_services.dart';
import 'package:flutter_piano/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../api_constants.dart';

class AppOpenAdManager {
  final Duration maxCacheDuration = Duration(hours: 4);
  DateTime? _appOpenLoadTime;
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  String adUnitId = AppOpenID.toString().trim();

  void loadAd() {
    if(appOpen==true){
      AppOpenAd.load(
        adUnitId: adUnitId,
        orientation: AppOpenAd.orientationPortrait,
        request: AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            print('$ad loaded');
            _appOpenLoadTime = DateTime.now();
            _appOpenAd = ad;
          },
          onAdFailedToLoad: (error) {
            print('AppOpenAd failed to load: $error');
          },
        ),
      );
    }
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      print('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );

    (appOpen==true)
        ? (interStitialAdRunning == false)
            ? appOpenAdRunning == true
                ? null
                : getIt<AdService>().getDifferenceAppOpenTime()
                    ? _appOpenAd!.show().then((value) {box.write(ArgumentConstant.isAppOpenStartTime, DateTime.now().millisecondsSinceEpoch.toString());})
                    : null
            : null
        : null;
  }
}