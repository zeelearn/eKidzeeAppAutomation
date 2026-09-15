import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../api/response/bpms/getTaskDetailsResponseModel.dart';
import '../../../helper/color_constant.dart';
import '../../../helper/math_utils.dart';
import '../../../helper/utils.dart';
import '../../../iface/onClick.dart';

class CenterSeupEmptyItemWidget extends StatefulWidget {
  final TaskDetailModel item;
  final onClickListener clickListener;

  const CenterSeupEmptyItemWidget(this.item,
      {super.key, required this.clickListener});

  @override
  CenterSeupEmptyItemWidgetPage createState() =>
      CenterSeupEmptyItemWidgetPage();
}

class CenterSeupEmptyItemWidgetPage extends State<CenterSeupEmptyItemWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
//     debugPrint('Empty widget=====================');
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? Utility.showLoader()
        : InkWell(
            onTap: () => widget.clickListener.onClick(111, widget.item),
            /*showModalBottomSheet(
          backgroundColor:
          Colors.transparent,
          context: context,
          builder: (builder) =>
              showBottomSheetEditTask(context))*/
            child: Container(
              margin: EdgeInsets.only(
                top: getVerticalSize(6.0),
                bottom: getVerticalSize(6.0),
              ),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: ColorConstant.whiteA700,
                borderRadius: BorderRadius.circular(
                  getHorizontalSize(
                    12,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      /*FadeInImage(
                  width: getSize(
                    42,
                  ),
                  height: getSize(
                    42,
                  ),
                  placeholder: AssetImage('assets/icons/ic_upload.png'),
                  image: NetworkImage(item.image),
                  imageErrorBuilder:
                      (context, error, stackTrace) {
                    return Image.asset(
                        'assets/icons/ic_error_image.png',
                        fit: BoxFit.fitWidth);
                  },
                  fit: BoxFit.cover,
                ),*/
                      /*Image.asset(
                  item.image,
                  height: getSize(
                    64,
                  ),
                  width: getSize(
                    64,
                  ),
                  fit: BoxFit.fill,
                ),*/
                      const Gap(8),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: getVerticalSize(
                                10,
                              ),
                              bottom: getVerticalSize(
                                1,
                              ),
                            ),
                            child: Text(
                              widget.item.title,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ColorConstant.gray900,
                                fontSize: getFontSize(
                                  16,
                                ),
                                fontFamily: 'General Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: getVerticalSize(
                                1,
                              ),
                              bottom: getVerticalSize(
                                1,
                              ),
                            ),
                            child: InkWell(
                              /*onTap: () => widget.clickListener.onClick(111, widget.item),*/
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    16,
                                  ),
                                  top: getVerticalSize(
                                    8,
                                  ),
                                  right: getHorizontalSize(
                                    16,
                                  ),
                                  bottom: getVerticalSize(
                                    8,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: widget.item.status == 4
                                      ? ColorConstant.deepPurpleA200
                                      : ColorConstant.gray900,
                                  borderRadius: BorderRadius.circular(
                                    getHorizontalSize(
                                      50,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  widget.item.statusname,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorConstant.whiteA700,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'SF Pro Text',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
