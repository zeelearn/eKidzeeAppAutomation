import 'package:ekidzee/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/TrackerIndent.dart';
import 'model/TrackerRequest.dart';

class FilterOrderScreen extends StatefulWidget {
  final TrackerIndent trackerIndent;
  final TrackerRequest request;
  const FilterOrderScreen(
      {required this.trackerIndent, required this.request, super.key});

  @override
  State<FilterOrderScreen> createState() => _FilterOrderScreenState();
}

class _FilterOrderScreenState extends State<FilterOrderScreen> {
  AcademicYear? academicYear;

  String indentType = 'ACK';
  String indentStatus = 'ALL';

  @override
  void initState() {
    super.initState();
    indentType = widget.request.IndentType;
    indentStatus = widget.request.status;
    academicYear = AcademicYear(
        academicYearId: widget.request.academicyearId,
        academicYearName: widget.request.academicyearName);

    widget.trackerIndent.root!.subroot!.academicYear!.sort((a, b) =>
        int.parse(a.academicYearId!).compareTo(int.parse(b.academicYearId!)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 15, color: Colors.black),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          'Back',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'FILTER BY Indent Status',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(
                height: 5,
              ),
              DropdownButton(
                padding: const EdgeInsets.all(8.0),
                value: indentStatus,
                elevation: 0,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: widget.trackerIndent.root!.subroot!.indentStatus!
                    .map((IndentStatus indentStatus) {
                  return DropdownMenuItem(
                    value: indentStatus.indentStatus,
                    child: Text(indentStatus.indentStatus ?? ''),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    indentStatus = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'FILTER BY ORDER TYPE',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(
                height: 5,
              ),
              DropdownButton(
                padding: const EdgeInsets.all(8.0),
                value: indentType,
                icon: const Icon(Icons.keyboard_arrow_down),
                elevation: 0,
                items: widget.trackerIndent.root!.subroot!.indentType!
                    .map((IndentType indentTypeLocal) {
                  return DropdownMenuItem(
                    value: indentTypeLocal.indentType,
                    child: Text(indentTypeLocal.indentDescription ?? ''),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    indentType = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'FILTER BY ORDER DATE',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount:
                      widget.trackerIndent.root!.subroot!.academicYear!.length,
                  controller: ScrollController(),
                  separatorBuilder: (_, __) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 2,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) => Container(
                    height: 50,
                    color: Colors.white,
                    child: RadioListTile(
                      title: Text(widget.trackerIndent.root!.subroot!
                          .academicYear![index].academicYearName!),
                      value: widget
                          .trackerIndent.root!.subroot!.academicYear![index],
                      groupValue: academicYear,
                      onChanged: (AcademicYear? value) {
                        setState(() {
                          academicYear = value!;
                          debugPrint(
                              'Selected year is - ${academicYear!.academicYearId}');
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width / 2, 40),
                        backgroundColor: kPrimaryTEXTBGColor,
                      ),
                      onPressed: () async {
                        final pref = await SharedPreferences.getInstance();
                        if (academicYear!.academicYearId!.contains('-')) {
                          if (mounted) {
                            Navigator.pop(
                                context,
                                TrackerRequest(
                                    frachisee_Id: widget.request.frachisee_Id,
                                    DocketNo: '',
                                    IndentType: indentType,
                                    fromDate: DateFormat("yyyy-MM-dd hh:mm a")
                                        .format(new DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month - 2,
                                            DateTime.now().day)),
                                    toDate: DateFormat("yyyy-MM-dd hh:mm a")
                                        .format(DateTime.now()),
                                    academicyearId: '0',
                                    indentNo: '0',
                                    status: indentStatus,
                                    last_days: academicYear!.academicYearId,
                                    academicyearName:
                                        academicYear!.academicYearName!));
                          }
                        } else {
                          if (mounted) {
                            Navigator.pop(
                                context,
                                TrackerRequest(
                                    frachisee_Id: widget.request.frachisee_Id,
                                    DocketNo: '',
                                    IndentType: indentType,
                                    fromDate: DateFormat("yyyy-MM-dd hh:mm a")
                                        .format(new DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month - 2,
                                            DateTime.now().day)),
                                    toDate: DateFormat("yyyy-MM-dd hh:mm a")
                                        .format(DateTime.now()),
                                    academicyearId:
                                        academicYear!.academicYearId ??
                                            DateTime.now()
                                                .year
                                                .toString()
                                                .substring(2),
                                    indentNo: '0',
                                    status: indentStatus,
                                    last_days: '30',
                                    academicyearName:
                                        academicYear!.academicYearName!));
                          }
                        }
                      },
                      child: Text('Apply',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)))),
            ],
          ),
        ),
      ),
    );
  }
}
