
import 'package:flutter/material.dart';

import '../../../api/response/bpms/franchisee_details_response.dart';
import '../../../helper/utils.dart';
import '../../../iface/onClick.dart';

class IndentViewWidget extends StatelessWidget {
  final FranchiseeIndentModel item;
  final onClickListener clickListener;

  const IndentViewWidget(this.item, {Key? key,required this.clickListener}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getView(context);
  }

  getView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*if(item.startDate.isNotEmpty) {
          showChatScreen(context,item);
        }else{
          clickListener.onClick(111, item);
        }*/
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
        child: Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x430F1113),
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Date : ${Utility.parseShortDate(item.IndentDate)} ${Utility.parseShortTime(item.IndentDate)}',
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF4B39EF),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Ref Id : ${item.IndentType} ${item.IndentId}',
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF4B39EF),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /*Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 1,
                decoration: BoxDecoration(
                  color: Color(0xFFF1F4F8),
                ),
              ),*/
              ListTile(
                title: Padding(
                  padding: EdgeInsetsDirectional.all(0),
                  child: Text(
                    item.IndentNo,
                    style: const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF090F13),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                subtitle: Text(
                  'Status : ${ Utility.parseShortDate(item.IndentStatus)}',
                  style: const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                //),
                trailing: Text(
                    '₹ ${item.IndentAmount.toString()}',
                    style: TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF4B39EF)  ,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
