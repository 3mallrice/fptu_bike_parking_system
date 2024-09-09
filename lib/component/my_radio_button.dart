import 'package:flutter/material.dart';

import 'shadow_container.dart';

class RadioButtonCustom extends StatefulWidget {
  final Widget prefixWidget;
  final Widget contentWidget;
  final bool isSelected;
  final Color? color;
  final Function()? onTap;

  const RadioButtonCustom({
    super.key,
    required this.prefixWidget,
    this.color,
    required this.contentWidget,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<RadioButtonCustom> createState() => _RadioButtonCustomState();
}

class _RadioButtonCustomState extends State<RadioButtonCustom> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ShadowContainer(
        width: MediaQuery.of(context).size.width * 0.9,
        color: widget.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: widget.prefixWidget,
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: widget.contentWidget,
              ),
            ),

            // if isSelected is true then icon color will be primary color, otherwise grey
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    // color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: widget.isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 19,
                    color: widget.isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
