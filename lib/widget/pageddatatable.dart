import 'package:ekidzee/Responsive.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';

class MyDataTable<T> extends StatefulWidget {
  final List<String> headers;
  final List<T> items;
  final dynamic Function(int, T) displayFunction;
  final void Function(int, dynamic) onClick;
  final ColumnSize? Function(int) getColoumSize;
  final Future<List<T>> Function(int, SortModel?, FilterModel?, String) fetch;
  // final Fetcher<T,String> fetcher;
  //final Fetcher<dynamic,String> Function(int,SortModel,FilterModel,String)  fetch;
  final PagedDataTableController<String, dynamic>? tableController;
  final String? hintText;
  final String? backgroundColor;
  final String title;
  final bool? enable;
  final TextStyle? headerTextStyle;
  final TextStyle? contentTextStyle;

  const MyDataTable(
      {Key? key,
      required this.headers,
      required this.title,
      required this.tableController,
      this.hintText,
      required this.items,
      required this.displayFunction,
      required this.onClick,
      required this.fetch,
      required this.getColoumSize,
      this.headerTextStyle,
      this.contentTextStyle,
      this.backgroundColor,
      this.enable})
      : super(key: key);

  @override
  DataTableState<T> createState() => DataTableState<T>();
}

class DataTableState<T> extends State<MyDataTable<T>>
    with SingleTickerProviderStateMixin {
  var pageThemeData;
  int currentPage = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pageThemeData = PagedDataTableThemeData(
        cellPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        selectedRow: const Color(0xFFCE93D8),
        rowColor: (index) => index.isEven ? LightColors.kLightGrayM : null,
        rowHeight: 40,
        horizontalScrollbarVisibility: true,
        backgroundColor: Colors.white,
        cellTextStyle: LightColors.subTextStyle,
        headerTextStyle: widget.headerTextStyle == null
            ? LightColors.subTextStyle
            : widget.headerTextStyle!,
        footerTextStyle: LightColors.subTextStyle,
        filterBarHeight: 0,
        footerHeight: 40,
        headerHeight: Responsive.isMobile(context) ? 0 : 40);

    return Container(
      margin:
          EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: 0),
      child: PagedDataTableTheme(
        data: pageThemeData,
        child: PagedDataTable<String, dynamic>(
          controller: widget.tableController!,
          initialPageSize: kIsWeb ? 10 : 100,
          initialPage: '1',
          footer: false
              ? null
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total Items : ${widget.items.length}',
                      style: LightColors.subTextStyle,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    _getSelector(),
                    const SizedBox(width: 10),
                    IconButton(
                      splashRadius: 20,
                      icon: const Icon(Icons.keyboard_arrow_left_rounded),
                      onPressed: () {
                        //debugPrint('on Previous Page');
                        if (currentPage > 1) {
                          widget.tableController!.previousPage();
                          currentPage--;
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    Text(currentPage.toString()),
                    IconButton(
                      disabledColor: widget.items.length >
                              (currentPage * widget.tableController!.pageSize ==
                                      0
                                  ? 10
                                  : widget.tableController!.pageSize)
                          ? LightColors.kLightGray
                          : Colors.black12,
                      splashRadius: 20,
                      icon: const Icon(Icons.keyboard_arrow_right_rounded),
                      onPressed: widget.items.length >
                              (currentPage * widget.tableController!.pageSize ==
                                      0
                                  ? 10
                                  : widget.tableController!.pageSize)
                          ? () {
                              //debugPrint('on Next page called ${widget.items.length} ${(currentPage * widget.tableController!.pageSize == 0 ? 10 : widget.tableController!.pageSize)}');
                              if (widget.items.length >
                                  (currentPage *
                                              widget
                                                  .tableController!.pageSize ==
                                          0
                                      ? 10
                                      : widget.tableController!.pageSize)) {
                                currentPage++;
                                widget.tableController!.nextPage();
                                setState(() {});
                              }
                            }
                          : null,
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
          configuration: const PagedDataTableConfiguration(),
          pageSizes: const [10, 20, 50, 100],
          fetcher: (pageSize, sortModel, filterModel, pageToken) async {
            //debugPrint('PageSize ${pageSize} sortmodel ${sortModel} filterModel ${filterModel} ');
            final data = await widget.fetch(
                pageSize,
                null,
                null,
                pageToken == null
                    ? "1"
                    : (int.parse(pageToken) + 1).toString());
            return (data, pageToken == null ? "1" : pageToken);
          },
          fixedColumnCount: 1,
          columns: _generateColoum(),
        ),
      ),
    );
  }

  _getSelector() {
    //debugPrint('Page Size ${widget.tableController!.pageSize}');
    return Row(
      children: [
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: DropdownButtonFormField<int>(
            alignment: Alignment.center,
            isExpanded: true,
            value: widget.tableController!.pageSize == 0
                ? 10
                : widget.tableController!.pageSize,
            items: [10, 20, 50, 100]
                .map((pageSize) => DropdownMenuItem(
                    value: pageSize, child: Text(pageSize.toString())))
                .toList(growable: false),
            onChanged: (newPageSize) {
              if (newPageSize != null) {
                currentPage = 1;
                widget.tableController!.pageSize = newPageSize;
                setState(() {});
              }
            },
            style: LightColors.textHeaderStyle13,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD6D6D6))),
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  List<ReadOnlyTableColumn<String, dynamic>> _generateColoum() {
    List<ReadOnlyTableColumn<String, dynamic>> list = [];
    for (int index = 00; index < widget.headers.length; index++) {
      list.add(TableColumn(
        title: Text(widget.headers[index]),
        cellBuilder: (context, item, i) => InkWell(
          child: widget.displayFunction(index, item as T),
          onTap: () {
            widget.onClick(index, item);
            //ToastUtility.showSuccess( msg: 'Click is getting called.');
          },
        ),
        size: widget.getColoumSize(index) ?? const RemainingColumnSize(),
      ));
    }
    return list;
  }
}
