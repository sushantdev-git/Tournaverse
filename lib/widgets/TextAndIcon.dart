import 'package:flutter/material.dart';

class TextAndIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  const TextAndIcon({required this.icon, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                text,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}