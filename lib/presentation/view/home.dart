import 'package:app_review/app_review.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_piano/constants/AdsManager/ad_services.dart';
import 'package:flutter_piano/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/state_manager.dart';

import '../../constants/AdsManager/app_lifecycle_reactor.dart';
import '../../constants/AdsManager/app_open_ad_manager.dart';
import '../../data/source/player/player.dart';
import '../../data/source/settings.dart';
import '../widget/locale.dart';
import '../widget/piano_view.dart';
import '../widget/settings.dart';

class Home extends ConsumerStatefulWidget {
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {

  AppLifecycleReactor? appLifecycleReactor;
  final player = $Player();
  final _focusNode = FocusNode();
  int octaveOffset = 0;
  int velocity = 127;
  int nOctaves = 7;
  bool sustain = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(Duration(seconds: 2)).then((value) async {
        await getIt<AdService>().initBannerAds(context);
        await getIt<AdService>().loadInterstitialAd();
        AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
        appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
        if(appLifecycleReactor!=null) {
          appLifecycleReactor!.listenToAppStateChanges();
        }
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final splitKeyboard = ref.watch(splitKeyboardProvider);
    return LayoutBuilder(builder: (context, dimens) {
      final canSplit = dimens.maxHeight > 600;
      final showControls = dimens.maxWidth > 550;
      return WillPopScope(
        onWillPop: () async {
          if (getIt<AdService>().bannerAd != null) {
            await getIt<AdService>().bannerAd!.dispose();
            await getIt<AdService>().initBannerAds(context);
          }
          getIt<AdService>().getDifferenceTime();
          return await true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.locale.title),
            actions: [
              if (showControls) ...[
                IconButton.filled(
                  onPressed: () => adjustOctave(-1),
                  icon: Icon(Icons.remove),
                  padding: EdgeInsets.zero,
                ),
                SizedBox(width: 4),
                IconButton.outlined(
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        octaveOffset = 0;
                      });
                    }
                  },
                  icon: Text(octaveOffset.toString(), style: TextStyle(color: Colors.white)),
                  padding: EdgeInsets.zero,
                ),
                SizedBox(width: 4),
                IconButton.filled(
                  onPressed: () => adjustOctave(1),
                  icon: Icon(Icons.add),
                  padding: EdgeInsets.zero,
                ),
                SizedBox(width: 10),
              ],
              Text('${context.locale.sustain}:'),
              Switch(
                value: sustain,
                onChanged: setSustain,
              ),
              if (canSplit) ...[
                IconButton(
                  onPressed: () async {
                    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
                      AppReview.requestReview.then((onValue) {
                        debugPrint('app_review: $onValue');
                      });
                    }
                    ref.read(splitKeyboardProvider.notifier).state = !splitKeyboard;
                  },
                  icon: Icon(!splitKeyboard ? Icons.splitscreen : Icons.fullscreen),
                  tooltip: context.locale.splitKeyboard,
                ),
              ],
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    showBottomSheet(
                      enableDrag: false,
                      context: context,
                      constraints: BoxConstraints(
                        maxWidth: double.infinity,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0),
                        ),
                      ),
                      builder: (context) => Settings(),
                    );
                  },
                  icon:  Icon(Icons.settings),
                );
              }),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.outlineVariant,
          body: Focus(
            focusNode: _focusNode,
            autofocus: true,
            onKey: (_, event) => onKey(
              ScaffoldMessenger.of(context),
              event,
            ),
            child: Builder(builder: (context) {
              if (canSplit && splitKeyboard) {
                return Column(
                  children: [
                    Flexible(
                      child: PianoView(
                        octaves: nOctaves,
                        onPlay: play,
                      ),
                    ),
                    Flexible(
                      child: PianoView(
                        octaves: nOctaves,
                        onPlay: play,
                      ),
                    ),
                  ],
                );
              }
              return PianoView(
                octaves: nOctaves,
                onPlay: play,
              );
            }),
          ),
          bottomNavigationBar: Obx(() => banner.isTrue
              ? getIt<AdService>().isBannerLoaded.isTrue
              ? getIt<AdService>().getBannerAds()
              : SizedBox()
              : SizedBox()),
        ),
      );
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> play(int midi) async {
    await player.play(midi, sustain: sustain);
  }

  void adjustOctave(int adjustment) {
    if (mounted) {
      setState(() {
        octaveOffset = (octaveOffset + adjustment).clamp(
          -nOctaves + 2,
          nOctaves - 2,
        );
      });
    }
  }

  void setSustain(bool val) async {
    setState(() {
      sustain = val;
    });
    if (!val) player.stopSustain();
  }

  KeyEventResult onKey(ScaffoldMessengerState messenger, RawKeyEvent event) {
    KeyEventResult result = KeyEventResult.ignored;
    if (event is RawKeyDownEvent) {
      // Use hardware keyboard for midi notes
      final key = event.logicalKey;
      final midiNotes = {
        LogicalKeyboardKey.keyA: 60 + (octaveOffset * 12),
        LogicalKeyboardKey.keyW: 61 + (octaveOffset * 12),
        LogicalKeyboardKey.keyS: 62 + (octaveOffset * 12),
        LogicalKeyboardKey.keyE: 63 + (octaveOffset * 12),
        LogicalKeyboardKey.keyD: 64 + (octaveOffset * 12),
        LogicalKeyboardKey.keyF: 65 + (octaveOffset * 12),
        LogicalKeyboardKey.keyT: 66 + (octaveOffset * 12),
        LogicalKeyboardKey.keyG: 67 + (octaveOffset * 12),
        LogicalKeyboardKey.keyY: 68 + (octaveOffset * 12),
        LogicalKeyboardKey.keyH: 69 + (octaveOffset * 12),
        LogicalKeyboardKey.keyU: 70 + (octaveOffset * 12),
        LogicalKeyboardKey.keyJ: 71 + (octaveOffset * 12),
        LogicalKeyboardKey.keyK: 72 + (octaveOffset * 12),
        LogicalKeyboardKey.keyO: 73 + (octaveOffset * 12),
        LogicalKeyboardKey.keyL: 74 + (octaveOffset * 12),
        LogicalKeyboardKey.keyP: 75 + (octaveOffset * 12),
        LogicalKeyboardKey.semicolon: 76 + (octaveOffset * 12),
        LogicalKeyboardKey.quoteSingle: 77 + (octaveOffset * 12),
      };
      if (midiNotes.containsKey(key)) {
        final midi = midiNotes[key]!;
        play(midi);
        result = KeyEventResult.handled;
      }
      final octaveAdjustment = {
        LogicalKeyboardKey.keyZ: -1,
        LogicalKeyboardKey.keyX: 1,
      };
      if (octaveAdjustment.containsKey(key)) {
        final adjustment = octaveAdjustment[key]!;
        setState(() {
          adjustOctave(adjustment);
          result = KeyEventResult.handled;
        });
      }
      final velocityAdjustment = {
        LogicalKeyboardKey.keyC: -1,
        LogicalKeyboardKey.keyV: 1,
      };
      if (velocityAdjustment.containsKey(key)) {
        final adjustment = velocityAdjustment[key]!;
        setState(() {
          velocity = (velocity + adjustment).clamp(0, 127);
          result = KeyEventResult.handled;
        });
      }
      if (key == LogicalKeyboardKey.space) {
        result = KeyEventResult.handled;
        setSustain(!sustain);
      }
    }
    return result;
  }
}