import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/source/settings.dart';
import '../view/app.dart';
import 'color_picker.dart';
import 'color_role.dart';
import 'locale.dart';
import 'piano_key.dart';
import 'piano_section.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: ExpansionTile(
              shape: Border.all(
                color: Colors.transparent,
              ),
              title: Text(context.locale.themeBrightness),
              leading: Icon(Icons.brightness_medium),
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              children: [
                Consumer(builder: (context, ref, child) {
                  final brightness = ref.watch(themeModeProvider);
                  return ListTile(
                    splashColor:
                        Colors.transparent, // Set splashColor to transparent
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    title: SegmentedButton(
                      segments: [
                        for (final item in [
                          ThemeMode.light,
                          ThemeMode.system,
                          ThemeMode.dark,
                        ])
                          ButtonSegment(
                            value: item,
                            label: Text(
                              item.label(context),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            icon: Icon(item.icon),
                          ),
                      ],
                      selected: {brightness},
                      onSelectionChanged: (value) {
                        ref.read(themeModeProvider.notifier).state =
                            value.first;
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
          elevation: 8,
          child: Consumer(builder: (context, ref, child) {
            final color = ref.watch(themeColorProvider);
            return ColorPicker(
              color: color,
              onColorChanged: (value) {
                ref.read(themeColorProvider.notifier).state = value;
              },
              label: context.locale.themeColor,
            );
          }),
        ),
        Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
          elevation: 8,
          child: Consumer(builder: (context, ref, child) {
            final keyWidth = ref.watch(keyWidthProvider);
            final invertKeys = ref.watch(invertKeysProvider);
            final keyLabel = ref.watch(keyLabelsProvider);
            final colorRole = ref.watch(colorRoleProvider);
            final haptics = ref.watch(hapticsProvider);
            final disableScroll = ref.watch(disableScrollProvider);
            return ExpansionTile(
              title: Text(context.locale.keySettings),
              leading: const Icon(Icons.music_note),
              shape: Border.all(
                color: Colors.transparent,
              ),
              children: [
                ListTile(
                  title: Text(context.locale.keyWidth),
                  leading: const Icon(Icons.settings_ethernet),
                  subtitle: Slider(
                    label: keyWidth.toString(),
                    value: keyWidth,
                    min: 50,
                    max: 200,
                    onChanged: (value) {
                      setState(() {
                        ref.read(keyWidthProvider.notifier).state = value;
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.restore),
                    tooltip: context.locale.resetToDefault,
                    onPressed: keyWidth == 80
                        ? null
                        : () {
                            setState(() {
                              ref.read(keyWidthProvider.notifier).state = 80;
                            });
                          },
                  ),
                ),
                ListTile(
                  title: Text(context.locale.invertKeys),
                  leading: const Icon(Icons.swap_horiz),
                  trailing: Switch(
                    value: invertKeys,
                    onChanged: (value) {
                      setState(() {
                        ref.read(invertKeysProvider.notifier).state = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(context.locale.colorRole),
                  leading: const Icon(Icons.colorize),
                  trailing: DropdownButton<ColorRole>(
                    value: colorRole,
                    onChanged: (value) {
                      setState(() {
                        ref.read(colorRoleProvider.notifier).state = value!;
                      });
                    },
                    items: [
                      for (final item in ColorRole.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.name.titleCase),
                        ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(context.locale.keyLabels),
                  leading: const Icon(Icons.label),
                  trailing: DropdownButton<PitchLabels>(
                    value: keyLabel,
                    onChanged: (value) {
                      setState(() {
                        ref.read(keyLabelsProvider.notifier).state = value!;
                      });
                    },
                    items: [
                      for (final item in PitchLabels.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.name.titleCase),
                        ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(context.locale.hapticFeedback),
                  leading: const Icon(Icons.vibration),
                  trailing: Switch(
                    value: haptics,
                    onChanged: (value) {
                      setState(() {
                        ref.read(hapticsProvider.notifier).state = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(context.locale.disableScroll),
                  leading: const Icon(Icons.list),
                  trailing: Switch(
                    value: disableScroll,
                    onChanged: (value) {
                      setState(() {
                        ref.read(disableScrollProvider.notifier).state = value;
                      });
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: IgnorePointer(
                      child: PianoSection(
                        index: 4,
                        onPlay: (midi) {},
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
          elevation: 8,
          child: Consumer(builder: (context, ref, child) {
            return ExpansionTile(
              title: Text(context.locale.language),
              leading: const Icon(Icons.language),
              shape: Border.all(
                color: Colors.transparent,
              ),
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    children: [
                      for (final locale in AppLocalizations.supportedLocales)
                        TextButton.icon(
                          icon: locale.flag,
                          label: Text(locale.description(context)),
                          onPressed: ref.watch(localeProvider)?.languageCode ==
                                  locale.languageCode
                              ? null
                              : () => ref.read(localeProvider.notifier).state =
                                  locale,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (ref.watch(localeProvider) != null)
                  OutlinedButton(
                    child: Text(context.locale.resetToDefault),
                    onPressed: () =>
                        ref.read(localeProvider.notifier).state = null,
                  ),
                const SizedBox(height: 10),
              ],
            );
          }),
        ),
      ],
    );
  }
}

extension on ThemeMode {
  String label(BuildContext context) {
    switch (this) {
      case ThemeMode.light:
        return context.locale.themeBrightnessLight;
      case ThemeMode.dark:
        return context.locale.themeBrightnessDark;
      case ThemeMode.system:
        return context.locale.themeBrightnessSystem;
    }
  }

  IconData get icon {
    switch (this) {
      case ThemeMode.light:
        return Icons.wb_sunny;
      case ThemeMode.dark:
        return Icons.nights_stay;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}

extension on Locale {
  String description(BuildContext context) {
    switch (languageCode) {
      case 'en':
        return context.locale.languageEn;
      case 'es':
        return context.locale.languageEs;
      case 'de':
        return context.locale.languageDe;
      case 'fr':
        return context.locale.languageFr;
      case 'ja':
        return context.locale.languageJa;
      case 'ko':
        return context.locale.languageKo;
      case 'zh':
        return context.locale.languageZh;
      case 'ru':
        return context.locale.languageRu;
      default:
    }
    return 'Unknown';
  }

  CountryFlag get flag {
    String? code;
    switch (languageCode) {
      case 'ja':
        code = 'jp';
      case 'en':
        code = 'us';
      case 'ko':
        code = 'kr';
      case 'zh':
        code = 'cn';
      case 'ru':
        code = 'ru';
      default:
    }
    if (code != null) {
      return CountryFlag.fromCountryCode(
        code,
        height: 24,
        width: 31,
        borderRadius: 4,
      );
    }
    return CountryFlag.fromLanguageCode(
      languageCode.toUpperCase(),
      height: 24,
      width: 31,
      borderRadius: 4,
    );
  }
}
