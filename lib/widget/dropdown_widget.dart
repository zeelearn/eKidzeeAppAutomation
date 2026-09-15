import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:saathi/core/theme/hex.dart';
import 'package:saathi/core/theme/light_colors.dart';

class DropDownWidget<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) displayFunction;
  final void Function(T?) onChanged;
  final TextEditingController? textController;
  final String? hintText;
  final String? backgroundColor;
  final String title;
  final bool? enable;
  final bool? readOnly;
  final TextStyle? textStyle;

  const DropDownWidget(
      {super.key,
      required this.title,
      required this.textController,
      required this.hintText,
      required this.items,
      required this.displayFunction,
      required this.onChanged,
      this.textStyle,
      this.backgroundColor,
      this.readOnly,
      this.enable});

  @override
  SimpleAccountMenuState<T> createState() => SimpleAccountMenuState<T>();
}

class SimpleAccountMenuState<T> extends State<DropDownWidget<T>>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
  late GlobalKey _key;
  bool isMenuOpen = false;
  late Offset buttonPosition;
  late Size buttonSize;
  late OverlayEntry _overlayEntry;
  late OverlayEntry _overlayFullBuilder;
  late AnimationController _animationController;

  List<T> _filteredList = [];
  List<T> _subFilteredList = [];

  Timer? _debounce;

  TextEditingController localTextController = TextEditingController();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _filteredList = widget.items;
    _subFilteredList = _filteredList;
    _key = LabeledGlobalKey("button_icon");

    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void findButton() {
    RenderBox renderBox = _key.currentContext?.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry.remove();
    _overlayFullBuilder.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilder();
    _overlayFullBuilder = _overlayBuilder();
    Overlay.of(context).insert(_overlayFullBuilder);
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    // localTextController.text = widget.textController!.text.toString();
    return InkWell(
      onTap: () {
        if (widget.enable != null && widget.enable!) {
          if (isMenuOpen) {
            closeMenu();
          } else {
            openMenu();
          }
        }
      },
      child: Container(
          //height: Responsive.isMobile(context) ? 40 : 40,
          //width: 80,
          height: 40,
          padding: const EdgeInsets.only(left: 0, top: 0),
          key: _key,
          decoration: BoxDecoration(
            color: widget.backgroundColor == null ||
                    widget.backgroundColor!.isEmpty
                ? Colors.white
                : HexColor.fromHex(widget.backgroundColor!),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isMenuOpen ? Colors.blue.shade600 : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: isMenuOpen
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: /* true
            ?  */
              Container(
            child: TextFormField(
              enabled: widget.enable,
              readOnly: widget.readOnly == null ? false : widget.readOnly!,
              style: widget.textStyle ?? LightColors.subtitleStyle10,
              controller: widget.textController,
              onChanged: (val) {
                setState(() {
                  localTextController.text = val;
                });
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    _filteredList = _subFilteredList.where((element) {
                      return widget
                          .displayFunction(element)
                          .toLowerCase()
                          .contains(widget.textController!.text.toLowerCase());
                    }).toList();

                    closeMenu();
                    openMenu();
                  });
                });
              },
              validator: (val) => val!.isEmpty ? 'Field can\'t empty' : null,
              onTap: () => openMenuWithoughtKeyboard(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText ?? "Select option...",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: localTextController.text.isNotEmpty &&
                        (widget.enable ?? false)
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            size: 18, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            localTextController.text = '';
                            widget.textController!.text = '';
                            widget.onChanged(null);
                          });
                        },
                      )
                    : Icon(
                        isMenuOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Colors.grey.shade600,
                        size: 24,
                      ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                isDense: true,
              ),
            ),
          )),
    );
  }

  void openMenuWithoughtKeyboard() {
    //hideKeyboard();
    openMenu();
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      canSizeOverlay: true,
      maintainState: true,
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy > 266
              ? buttonPosition.dy -
                  (_filteredList.length > 10 ? 10 : _filteredList.length) * 45 -
                  10
              : buttonPosition.dy + buttonSize.height + 5,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: PointerInterceptor(
            child: FadeTransition(
              opacity: _animationController,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeOutBack,
                ),
                alignment: buttonPosition.dy > 266
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                child: Material(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: _filteredList.isEmpty
                        ? const SizedBox(
                            height: 60,
                            child: Center(
                              child: Text(
                                'No Data Available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : Container(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height / 3,
                            ),
                            child: Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              child: ListView.separated(
                                controller: _scrollController,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item = _filteredList[index];
                                  final isSelected =
                                      widget.displayFunction(item) ==
                                          widget.textController?.text;

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        localTextController.text = 'selected';
                                      });
                                      closeMenu();
                                      widget.textController!.text =
                                          widget.displayFunction(item);
                                      widget.onChanged(item);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.blue.shade50
                                            : Colors.transparent,
                                      ),
                                      child: Text(
                                        widget.displayFunction(item),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isSelected
                                              ? Colors.blue.shade700
                                              : Colors.black87,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Colors.grey.shade100,
                                ),
                                itemCount: _filteredList.length,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  OverlayEntry _overlayBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              try {
                widget.textController?.text = '';
                // _filteredList.clear();
                _filteredList = widget.items;
                widget.onChanged(null);
              } catch (e) {}
              closeMenu();
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              color: Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
