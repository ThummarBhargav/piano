// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_piano/constants/api_constants.dart';
import 'package:flutter_piano/main.dart';
import 'package:get/state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  BannerAd? bannerAd;
  RxBool isBannerLoaded = false.obs;
  InterstitialAd? interstitialAds;
  AnchoredAdaptiveBannerAdSize? size;

  // BannerAds
  initBannerAds(BuildContext context) async {
    if (banner.isTrue) {
      size = await anchoredAdaptiveBannerAdSize(context);
      bannerAd = BannerAd(
          size: (adaptiveBannerSize==true)
              ? size!
              : AdSize.banner,
          adUnitId: BannerID.toString().trim(),
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              isBannerLoaded.value = true;
            },
            onAdFailedToLoad: (ad, error) {
              print(
                  'Ad load failed (code=${error.code} message=${error.message})');
              ad.dispose();
              initBannerAds(context);
            },
          ),
          request: AdRequest())
        ..load();
    }
  }

  Widget getBannerAds() {
    return SizedBox(
      width: bannerAd!.size.width.toDouble(),
      height: bannerAd!.size.height.toDouble(),
      child: bannerAd != null ? AdWidget(ad: bannerAd!) : SizedBox(),
    );
  }

  // InterstitialAds Load & Show
  showInterstitialAd() {
    if (interstitial==true) {
      interStitialAdRunning = true;
      if (interStitialAdRunning==true) {
        interstitialAds?.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) =>
              print('Ad showed fullscreen content.'),
          onAdDismissedFullScreenContent: (ad) {
            box.write(ArgumentConstant.isStartTime, DateTime.now().millisecondsSinceEpoch.toString());
            interstitialAds?.dispose();
            interStitialAdRunning = false;
            loadInterstitialAd();
            print('Ad dismissed fullscreen content.');
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            interStitialAdRunning = false;
            print('Ad failed to show fullscreen content: $error');
          },
        );
        interstitialAds?.show();
      } else {
        print('Interstitial ad is not loaded yet.');
        loadInterstitialAd(); // Load a new ad if not already loaded
      }
    }
  }

  loadInterstitialAd() {
    if(interstitial==true){
      InterstitialAd.load(
        adUnitId: InterstitialID.toString().trim(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAds = ad;
          },
          onAdFailedToLoad: (error) {
            interStitialAdRunning = false;
            print('InterstitialAd failed to load: $error');
            print("InterstitialID:-  " + InterstitialID.toString().trim());
          },
        ),
      );
    }
  }

  // Get Difference Time For Interstitial
  getDifferenceTime() {
    if (box.read(ArgumentConstant.isStartTime) != null) {
      String startTime = box.read(ArgumentConstant.isStartTime).toString();
      String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
      int difference = int.parse(currentTime) - int.parse(startTime);
      print("Difference := $difference");
      print("StartTime := $startTime");
      print("currentDate := $currentTime");
      int differenceTime = difference ~/ 1000;
      if (differenceTime > interShowTime) {
        showInterstitialAd();
      }
    }
  }

  // Get Difference Time For AppOpen
  bool getDifferenceAppOpenTime() {
    if (box.read(ArgumentConstant.isAppOpenStartTime) != null) {
      String startTime = box.read(ArgumentConstant.isAppOpenStartTime).toString();
      String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
      int difference = int.parse(currentTime) - int.parse(startTime);
      print("Difference := $difference");
      print("StartTime := $startTime");
      print("currentDate := $currentTime");
      int differenceTime = difference ~/ 1000;
      if (differenceTime > appOpenShowTime) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

Future<AnchoredAdaptiveBannerAdSize?> anchoredAdaptiveBannerAdSize(BuildContext context) async {
  return await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.of(context).size.width.toInt());
}