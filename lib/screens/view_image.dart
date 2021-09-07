import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final ImageProvider image;
  const ImageDialog({
    Key? key,
    required this.image,
  }) : super(key: key);

  Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox.fromSize(
        size: Size.square(size.width / 1.5),
        child: Image(
          image: image,
        ),
      ),
    );
  }
}
