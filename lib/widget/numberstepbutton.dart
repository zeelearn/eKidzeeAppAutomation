import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LightColor.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int currentValue;

  final ValueChanged<int> onChanged;

  NumericStepButton(
      {Key? key,required this.currentValue, this.minValue = 0, this.maxValue = 10,required this.onChanged})
      : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {

  int counter= 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counter = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: kPrimaryLightColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
            iconSize: 24.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (counter > widget.minValue) {
                  counter--;
                }
                widget.onChanged(counter);
              });
            },
          ),
          Text(
            '$counter',
            textAlign: TextAlign.center,
            style: LightColors.textHeaderStyle13,
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: kPrimaryLightColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
            iconSize: 28.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (counter < widget.maxValue) {
                  counter++;
                }
                widget.onChanged(counter);
              });
            },
          ),
        ],
      ),
    );
  }
}