import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final String label;
  ColorPicker({required this.color, required this.onColorChanged, required this.label});

  @override
  Widget build(BuildContext context) {
    final themeColors = [
      Color(0xffff6666),
      Color(0xffff6680),
      Color(0xffff66ff),
      Color(0xffa88bda),
      Color(0xffbf66ff),
      Color(0xff6666ff),
      Color(0xff8ac7db),
      Color(0xff66ffff),
      Color(0xff00e6e6),
      Color(0xff66ff66),
      Color(0xff7bea7b),
      Color(0xff4dff4d),
      Color(0xffffff66),
      Color(0xffffd24d),
      Color(0xffffc966),
      Color(0xffff8a66),
      Color(0xffda7171),
      Color(0xffa6a6a6),
      Color(0xff7893a1),
    ];
    return ExpansionTile(
      title: Text(label),
      leading: const Icon(Icons.color_lens),
      shape: Border.all(color: Colors.transparent),
      children: [
        Wrap(
          children: themeColors
              .map(
                (item) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => onColorChanged(item),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: item,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: item.value == color.value
                              ? Colors.black
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}