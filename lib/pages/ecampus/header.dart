import 'package:flutter/material.dart';

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _title(),
        const SizedBox(width: 10),
        const Spacer(),
      ],
    );
  }

  Widget _title() {
    return Row(
      children: [
        Icon(
          Icons.menu,
          color: Colors.black87,
          size: 24.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Sanavi Patil",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Senior KG",
              style: TextStyle(fontSize: 16),
            )
          ],
        )
      ],
    );
  }

  Widget _className() {
    return const Text(
      "Senior KG",
      style: TextStyle(fontSize: 16),
    );
  }

}
