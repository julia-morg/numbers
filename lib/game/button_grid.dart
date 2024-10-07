import 'package:flutter/material.dart';
import 'dart:math';
import 'field.dart';

class ButtonGrid extends StatefulWidget {
  final Function(int, int, Function(int)) onButtonPressed;
  final List<Map<String, int>> selectedButtons;
  final Map<int, Field> numbers;
  final double buttonSize;
  final int buttonsPerRow;

  const ButtonGrid({
    Key? key,
    required this.onButtonPressed,
    required this.selectedButtons,
    required this.numbers,
    required this.buttonSize,
    required this.buttonsPerRow,
  }) : super(key: key);

  @override
  _ButtonGridState createState() => _ButtonGridState();
}

class _ButtonGridState extends State<ButtonGrid> {
  void updateGrid() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight =
        Scaffold.of(context).appBarMaxHeight ?? kToolbarHeight;

    double availableHeight = screenHeight - appBarHeight;

    int totalRowsInView =
        (availableHeight / (widget.buttonSize * 2 + 1)).floor() - 1;
    int totalButtonsToShow = totalRowsInView * widget.buttonsPerRow;

    int buttonsInLastRow = widget.numbers.length % widget.buttonsPerRow;

    int emptyCellsToAdd =
        buttonsInLastRow > 0 ? widget.buttonsPerRow - buttonsInLastRow : 0;

    int initialEmptyCells = totalButtonsToShow - widget.numbers.length;

    int finalItemCount = widget.numbers.length +
        max(emptyCellsToAdd, 0).toInt() +
        max(initialEmptyCells, 0).toInt() +
        widget.buttonsPerRow;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.buttonsPerRow,
        childAspectRatio: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: finalItemCount,
      itemBuilder: (context, index) {
        if (index >= widget.numbers.length) {
          return SizedBox(
            width: widget.buttonSize,
            height: widget.buttonSize,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.zero,
              ),
              onPressed: null,
              child: null,
            ),
          );
        }

        Field buttonField = widget.numbers[index]!;
        int buttonNumber = buttonField.number;
        bool isSelected = widget.selectedButtons.any(
            (element) => element['index'] == index);

        return SizedBox(
          width: widget.buttonSize,
          height: widget.buttonSize,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonField.isActive
                  ? (isSelected
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5)
                      : null)
                  : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: buttonField.isActive
                ? () {
                    widget.onButtonPressed(index, buttonNumber, (idx) {
                      setState(() {
                        widget.numbers[idx] = Field(
                            idx, buttonNumber, false);
                      });
                    });
                  }
                : null,
            child: Text(
              '$buttonNumber',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
