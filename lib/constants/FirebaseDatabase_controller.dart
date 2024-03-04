// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_piano/main.dart';

class FirebaseDatabaseHelper {
  Future<void> adsVisible() async {
    String databaseCollectionName = "PianoApp";
    await FirebaseDatabase.instance.ref("${databaseCollectionName}/Ads").onValue.listen((DatabaseEvent event) {
      Object? data = event.snapshot.value;
      Map<String, dynamic> getDataList = jsonDecode(jsonEncode(data));
      Map<String, dynamic> showAds = getDataList['showAds'];
      Map<String, dynamic> testAds = getDataList['testAds'];
      Map<String, dynamic> androidLiveAds = getDataList['androidLiveAds'];
      Map<String, dynamic> appleLiveAds = getDataList['appleLiveAds'];
      print("showAds:-  " + showAds.toString());
      print("testAds:-  " + testAds.toString());
      print("androidLiveAds:-  " + androidLiveAds.toString());
      print("appleLiveAds:-  " + appleLiveAds.toString());

      appOpen = showAds['appOpenShow'];
      banner.value = showAds['bannerShow'];
      interstitial = showAds['interShow'];
      interShowTime = showAds['interShowTime'];
      appOpenShowTime = showAds['appOpenShowTime'];
      adaptiveBannerSize = showAds['adaptiveBannerSize'];

      AppOpenID = (Platform.isIOS) ? (kReleaseMode) ? appleLiveAds['appOpen'] : "ca-app-pub-3940256099942544/5575463023" : (kReleaseMode) ? androidLiveAds['appOpen'] : testAds['appOpen'];
      BannerID = (Platform.isIOS) ? (kReleaseMode) ? appleLiveAds['banner'] : "ca-app-pub-3940256099942544/2934735716" : (kReleaseMode) ? androidLiveAds['banner'] : testAds['banner'];
      InterstitialID = (Platform.isIOS) ? (kReleaseMode) ? appleLiveAds['inter'] : "ca-app-pub-3940256099942544/4411468910" : (kReleaseMode) ? androidLiveAds['inter'] : testAds['inter'];

      // AppOpenID.value = "ca-app-pub-3940256099942544/9257395921";
      // BannerID.value = "ca-app-pub-3940256099942544/6300978111";
      // InterstitialID.value = "ca-app-pub-3940256099942544/1033173712";
    });
  }
}