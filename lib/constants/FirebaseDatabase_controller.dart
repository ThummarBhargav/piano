import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:get/state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../main.dart';

class FirebaseDatabaseHelper {
  static DatabaseReference adsRef =
      FirebaseDatabase.instance.ref().child("Ads");
  void GetAdsData() {
    adsRef.onValue.listen((DatabaseEvent event) {
      Object? data = event.snapshot.value;
      Map<String, dynamic> getDataList = jsonDecode(jsonEncode(data));
      if (getDataList.isNotEmpty) {
        appOpen = getDataList['appOpen'];
        banner.value = getDataList['banner'];
        interstitial = getDataList['inter'];
        print("=*=*=*=FetchAdsData" + getDataList.toString());
      }
    });
  }

  Future<void> adsVisible() async {
    String databaseCollectionName = "PianoApp";
    await FirebaseDatabase.instance
        .ref("${databaseCollectionName}/Ads")
        .onValue
        .listen((DatabaseEvent event) async {
      Object? data = event.snapshot.value;
      Map<String, dynamic> getDataList = jsonDecode(jsonEncode(data));
      Map<String, dynamic> showAds = getDataList['showAds'];
      Map<String, dynamic> testAds = getDataList['testAds'];
      Map<String, dynamic> liveAds = getDataList['androidLiveAds'];
      Map<String, dynamic> iOSLiveAds = getDataList['appleLiveAds'];

      print("showAds:-  " + showAds.toString());
      print("testAds:-  " + testAds.toString());
      print("liveAds:-  " + liveAds.toString());
      print("iOSLiveAds:-  " + iOSLiveAds.toString());

      appOpen = showAds['appOpenShow'];
      banner.value = showAds['bannerShow'];
      interstitial = showAds['interShow'];
      interShowTime = showAds['interShowTime'];
      appOpenShowTime = showAds['appOpenShowTime'];
      adaptiveBannerSize = showAds['adaptiveBannerSize'];

      androidAdsId = (kReleaseMode) ? liveAds['app_id'] : testAds['app_id'];
      iOSAdsId = (kReleaseMode) ? iOSLiveAds['app_id'] : testAds['app_id'];

      print("androidAdsId:-  " + androidAdsId);
      print("iOSAdsId:-  " + iOSAdsId);
      const platform = MethodChannel('samples.flutter.dev/firebase');
      if (banner.isTrue) {
        try {
          await platform.invokeMethod('setId', {
            "googleAdsId": Platform.isIOS ? iOSAdsId : androidAdsId,
          }).then((value) async {
            if (value == "Success") {
              await GdprDialog.instance
                  .showDialog(isForTest: false, testDeviceId: '')
                  .then((onValue) {
                print('result === $onValue');
              });
              await MobileAds.instance.initialize();
              MobileAds.instance.updateRequestConfiguration(
                RequestConfiguration(
                  tagForChildDirectedTreatment:
                      TagForChildDirectedTreatment.unspecified,
                  testDeviceIds: kDebugMode
                      ? [
                          "921ECDEF8D5D6B5B6CD6F3BC93FF97D7",
                          "AE1F0F89B6FA703DB464057FBE19FE15",
                        ]
                      : [],
                ),
              );
            }
          });
        } on PlatformException catch (e) {
          print(e);
        }
      }

      AppOpenID = (Platform.isIOS)
          ? (kReleaseMode)
              ? iOSLiveAds['appOpen']
              : testAds['appOpen']
          : (kReleaseMode)
              ? liveAds['appOpen']
              : testAds['appOpen'];
      BannerID = (Platform.isIOS)
          ? (kReleaseMode)
              ? iOSLiveAds['banner']
              : testAds['banner']
          : (kReleaseMode)
              ? liveAds['banner']
              : testAds['banner'];
      InterstitialID = (Platform.isIOS)
          ? (kReleaseMode)
              ? iOSLiveAds['inter']
              : testAds['inter']
          : (kReleaseMode)
              ? liveAds['inter']
              : testAds['inter'];

      // AppOpenID.value = "ca-app-pub-3940256099942544/9257395921";
      // BannerID.value = "ca-app-pub-3940256099942544/6300978111";
      // InterstitialID.value = "ca-app-pub-3940256099942544/1033173712";
      // NativeID.value = "ca-app-pub-3940256099942544/2247696110";
    });
  }
}
