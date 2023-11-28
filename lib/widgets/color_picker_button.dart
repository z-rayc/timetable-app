import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerButton extends StatefulWidget {
  const ColorPickerButton({
    super.key,
    required this.initialColor,
    required this.setColor,
  });

  final Color initialColor;
  final Function(Color) setColor;

  @override
  State<ColorPickerButton> createState() {
    return _ColorPickerButtonState();
  }
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor; // Initial color
  }

  Future<void> _showColorPickerOverlay(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                widget.setColor(color);
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(selectedColor); // Return the selected color
              },
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _showColorPickerOverlay(context);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
          color: selectedColor,
        ),
        height: 30,
        width: 30,
      ),
    );
  }
}
