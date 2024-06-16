import 'package:flutter/material.dart';

import 'shadow_container.dart';

class RadioButtonCustom extends StatelessWidget {
  final Widget prefixWidget;
  final Widget contentWidget;
  final bool isSelected;
  final Function() onTap;

  const RadioButtonCustom({
    super.key,
    required this.prefixWidget,
    required this.contentWidget,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ShadowContainer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: prefixWidget,
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: contentWidget,
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
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 19,
                    color: isSelected
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
