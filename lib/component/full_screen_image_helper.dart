import 'package:flutter/material.dart';

class FullScreenImageDialog extends StatelessWidget {
  final String imagePath;
  final bool isAssetImage;

  const FullScreenImageDialog(
      {super.key, required this.imagePath, this.isAssetImage = true});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: isAssetImage
            ? Image.asset(
                imagePath,
                fit: BoxFit.cover,
              )
            : Image.network(
                imagePath,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
