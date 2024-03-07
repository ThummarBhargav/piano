import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_piano/constants/FirebaseDatabase_controller.dart';
import 'package:flutter_piano/constants/app_module.dart';
import 'package:flutter_piano/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:get/state_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'constants/api_constants.dart';
import 'presentation/view/app.dart';

bool appOpen = false;
RxBool banner = false.obs;
bool interstitial = false;
bool appOpenAdRunning = false;
bool interStitialAdRunning = false;
String AppOpenID = "";
String BannerID = "";
String InterstitialID = "";
String androidAdsId = "";
String iOSAdsId = "";
int interShowTime = 0;
int appOpenShowTime = 0;
bool adaptiveBannerSize = false;

final box = GetStorage();
final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseDatabaseHelper().adsVisible();
  await GetStorage.init();
  setUp();
  if (isNullEmptyOrFalse(box.read(ArgumentConstant.isStartTime))) {
    box.write(ArgumentConstant.isStartTime, 0);
  }
  if (isNullEmptyOrFalse(box.read(ArgumentConstant.isAppOpenStartTime))) {
    box.write(ArgumentConstant.isAppOpenStartTime, 0);
  }
  runApp(ProviderScope(child: ThePocketPiano()));
}
