import 'package:flutter/material.dart';
import 'package:bai_system/component/loading_component.dart';

class LoadingOverlayHelper {
  static late OverlayEntry _overlayEntry;

  static OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: LoadingCircle(),
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  static void hide() {
    _overlayEntry.remove();
  }
}
