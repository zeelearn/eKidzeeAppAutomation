import 'package:flutter/material.dart';

class AttachmentLegendWidget extends StatelessWidget {
  const AttachmentLegendWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 3,
          alignment: Alignment.center,
          width: 3,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(text,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.grey, fontSize: 10)),
        ),
      ],
    );
  }
}
