import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/source/settings.dart';
import '../../src/version.dart';
import 'home.dart';

final localeProvider = StateProvider<Locale?>(
  (ref) => null,
);

class ThePocketPiano extends ConsumerStatefulWidget {
  @override
  ConsumerState<ThePocketPiano> createState() => _ThePocketPianoState();
}

class _ThePocketPianoState extends ConsumerState<ThePocketPiano> {

  static const platform = MethodChannel('samples.flutter.dev/firebase');
  static const updateKey = 'app_check';
  final _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await platform.invokeMethod('setId').then((value) async {
          if (value == "Success") {
            await MobileAds.instance.initialize();
            MobileAds.instance.updateRequestConfiguration(
              RequestConfiguration(
                tagForChildDirectedTreatment:
                TagForChildDirectedTreatment.unspecified,
                testDeviceIds: kDebugMode
                    ? [
                  "921ECDEF8D5D6B5B6CD6F3BC93FF97D7",
                ]
                    : [],
              ),
            );
          }
        });
      } on PlatformException catch (e) {
        print(e);
      }
      // checkForUpdate(context);
    });
  }

  Future<void> checkForUpdate(BuildContext context) async {
    final nav = _navKey.currentState!;
    final prefs = await SharedPreferences.getInstance();
    final lastCheck = prefs.getString(updateKey);
    const appVersion = packageVersion;
    if (lastCheck == null || lastCheck != appVersion) {
      final _ = await nav.push(
        MaterialPageRoute(
          builder: (context) => const WhatsNewPage.changelog(adaptive: false),
          fullscreenDialog: true,
        ),
      );
      await prefs.setString(updateKey, appVersion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = ref.watch(themeColorProvider);
    final mode = ref.watch(themeModeProvider);
    const appBarTheme = AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Pocket Piano',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: color,
          brightness: Brightness.light,
        ),
        appBarTheme: appBarTheme,
        splashColor: Colors.transparent, // Set splashColor to transparent
        highlightColor: Colors.transparent, // Set highlightColor to transparent
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: color,
          brightness: Brightness.dark,
        ),
        appBarTheme: appBarTheme,
        splashColor: Colors.transparent, // Set splashColor to transparent
        highlightColor: Colors.transparent, // Set highlightColor to transparent
      ),
      navigatorKey: _navKey,
      themeMode: mode,
      locale: ref.watch(localeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Home(),
    );
  }
}