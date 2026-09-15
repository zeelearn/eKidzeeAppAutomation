import 'package:ekidzee/constants.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

class PathBar extends StatelessWidget implements PreferredSizeWidget {
  final List paths;
  final Function(int) onChanged;
  final IconData? icon;

  PathBar({
    Key? key,
    required this.paths,
    required this.onChanged,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      color: LightColors.kLightGrayM,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: paths.length,
          itemBuilder: (BuildContext context, int index) {
            String i = paths[index];
            List splited = i.split('/');
            if (index == -1) {
              return IconButton(
                icon: Icon(
                  Icons.home,
                  color: index == paths.length - 1
                      ? kPrimaryLightColor
                      : Colors.grey,
                ),
                onPressed: () => onChanged(index),
              );
            }
            return InkWell(
              onTap: () => onChanged(index),
              child: Container(
                height: 24,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: index == 0 ? 10 : 2),
                    child: Text(
                      '${splited[splited.length - 1]}',
                      style: LightColors.subTextStyle.copyWith(color: index == paths.length - 1
                            ? kPrimaryLightColor
                            : Colors.grey)
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return InkWell(
              mouseCursor: SystemMouseCursors.click,
              child: Image.asset('assets/icons/ic_arrow_right.png',width: 12,color: Colors.grey,),
              onTap: () => onChanged(-1),
            );//Image.asset('assets/icons/ic_arrow_right.png');
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(20.0);
}
