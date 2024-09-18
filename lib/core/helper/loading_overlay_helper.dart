import 'package:bai_system/component/loading_component.dart';
import 'package:flutter/material.dart';

class LoadingOverlayHelper {
  OverlayEntry? _overlayEntry;

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: LoadingCircle(),
        ),
      ),
    );
  }

  void show(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void hide() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null; // Reset to avoid reusing the old entry
    }
  }

  void dispose() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null; // Ensure proper cleanup
    }
  }
}
