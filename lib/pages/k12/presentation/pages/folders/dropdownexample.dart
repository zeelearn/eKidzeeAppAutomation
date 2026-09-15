import 'dart:math';

import 'package:ekidzee/helper/utils.dart' as util;
import 'package:ekidzee/pages/k12/data/models/directory/folder_model.dart';
import 'package:ekidzee/pages/k12/presentation/pages/folders/tree_page.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/file/path_bar.dart';
import 'package:ekidzee/widget/pageddatatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:literaoctave/core/utils.dart' as octaveUtil;
import 'package:paged_datatable/paged_datatable.dart';
import 'package:saathi/core/responsive.dart';
import 'package:saathi/core/utility/utils.dart';
import 'package:saathi/widget/dropdown.dart';

class DropdownExample extends StatefulWidget {
  String root;
  FolderData folderData;

  DropdownExample({super.key, required this.folderData, required this.root});

  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  List<FolderModel> folders = [];
  List<FolderFiles> mFiles = [];

  final List<TextEditingController> _controllers = [];
  // Sample data
  List<MyNode> nodes = [];

  List<List<FolderModel>> currentNode = [];

  List<FolderModel> historyList = [];

  late String path;
  List<String> paths = <String>[];
  String supportPath = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folders.addAll(widget.folderData.folders!);
    mFiles.addAll(widget.folderData.files!);
    nodes = buildTree(folders, mFiles);
    paths.clear();
    paths.add(widget.root);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (!isNodeExists(currentNode[index])) {
      //   push(value, value.name);
      // }
      updateFilter(widget.folderData.contentid);
      //mFilteredFiles.addAll(mFiles);
      setState(() {});
    });
  }

  // Convert a list of FolderModel to a list of TreeNode
  List<MyNode> buildTree(List<FolderModel> folders, List<FolderFiles> mFiles) {
    Map<int, MyNode> nodeMap = {};
    // Create Node objects and map them by their ContentID
    for (var folder in folders) {
      nodeMap[folder.contentId] = MyNode(
        title: folder.name,
        key: folder.contentId,
        isFile: false,
        parentID: folder.parentContentId,
        data: folder,
        children: [],
      );
    }

    // Helper function to find a node by ContentID
    MyNode? findNodeByID(int id, List<MyNode> nodes) {
      for (var node in nodes) {
        if (node.key == id) {
          return node;
        }
        final found = findNodeByID(id, node.children);
        if (found != null) {
          return found;
        }
      }
      return null;
    }

    // Assign children to their respective parent nodes
    final List<MyNode> rootNodes = [];
    for (var folder in folders) {
      final node = nodeMap[folder.contentId];
      final parentNode = nodeMap[folder.parentContentId];

      if (parentNode != null) {
        parentNode.children.add(node!);
      } else {
        // If no parent node, it's a root node
        rootNodes.add(node!);
      }
    }

    // Add files to the corresponding nodes
    for (var file in mFiles) {
      final parentID = file.categoryid!;
      final parentNode = findNodeByID(parentID, rootNodes);
      if (parentNode != null) {
        parentNode.children.add(MyNode(
          key: file.categoryid!,
          parentID: 0,
          data: file,
          title: file.fileName!,
          isFile: true,
          url: file.url!,
        ));
      }
    }

    return rootNodes;
  }

  // Helper function to find a node by ContentID
  MyNode? findNodeByID(int id, List<MyNode> nodes) {
    for (var node in nodes) {
      if (node.key == id) {
        return node;
      }
      final found = findNodeByID(id, node.children);
      if (found != null) {
        return found;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext conteFxt) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(00),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                //width: MediaQuery.of(context).size.width * 0.9,

                child: PathBar(
                  paths: paths,
                  icon: Icons.sd_card,
                  onChanged: (index) {
                    if (index == 0) {
                      paths.clear();
                      path = widget.root;
                      paths.add(widget.root);
                      supportPath = "";
                      currentNode.clear();
                      historyList.clear();
                      _controllers.clear();

                      updateFilter(widget.folderData.contentid);
                      //updateFilter(widget.folderData.folders![0].contentId);

                      //historyList.addAll(nodes);
                      //updateFilter(0);
                    } else {
                      path = paths[index];
                      int difference = currentNode.length - index;
                      for (int index = 0; index < difference; index++)
                        currentNode.removeLast();
                      _controllers.removeLast();
                    }
                    int parentId = currentNode.last.first.parentContentId;
                    //currentNode.clear();
                    paths.removeRange(index + 1, paths.length);
                    //updateFilter(parentId);
                    mFilteredFiles.clear();
                    findFiles(parentId);
                    setState(() {});
                    //pop();
                    setState(() {});
                  },
                ),
              ),
              getFilterContentGrid()
              //...nodes.map((node) => DropdownWidget(node: node)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  bool isNodeExists(List<FolderModel> node) {
    int currentIndex = -1;
    for (int index = 0; index < currentNode.length; index++) {
      if (currentNode[index].first.name == node.first.name) {
        currentIndex = currentNode.length - 1 - index;
        break;
      }
    }
    debugPrint(
        'Current Index $currentIndex ${currentNode.length} ${historyList.length}');
    if (currentIndex > 0) {
      for (int index = 0; index < currentIndex; index++) {
//         debugPrint('Remove Index $index');
        //historyList.removeLast();
        currentNode.removeLast();
        _controllers.removeLast();
        //paths.removeLast();
        supportPath = historyList.last.name;
      }

      paths.clear();
      paths.add(widget.root);
      for (int index = 0; index < _controllers.length; index++)
        paths.add(_controllers[index].text);

      debugPrint(currentNode.last.last.name);
      updateFilter(currentNode.last.last.contentId);
      return true;
    } else {
      return false;
    }
  }

  dynamic getFilterContentGrid() {
    return currentNode.isEmpty
        ? getFileContentGrid()
        : Column(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                height: Responsive.isDesktop(context)
                    ? currentNode.length > 4
                        ? currentNode.length / 4 * 100
                        : 50
                    : Responsive.isTablet(context)
                        ? currentNode.length > 3
                            ? currentNode.length / 3 * 80
                            : 45
                        : currentNode.length > 2
                            ? currentNode.length / 2 * 70
                            : 50,
                child: GridView.builder(
                  itemCount: currentNode.length,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.all(10),
                    child: ZeeDropDown(
                      title: currentNode[index].first.name,
                      textController: _controllers[index],
                      hintText: 'Select',
                      readOnly: true,
                      items: currentNode[index],
                      displayFunction: (value) => value.name,
                      onChanged: (value) {
                        if (value != null) {
                          if (!isNodeExists(currentNode[index])) {
                            push(value, value.name);
                          }
                        } else {
//                           debugPrint('current index $index');
                        }
                      },
                    ),
                  ),
                  gridDelegate:
                      util.Utility.getResponsiveFilterGridViewStyle(context),
                ),
              ),
              getFileContentGrid()
            ],
          );
  }

  SizedBox getFileContentGrid() {
//     debugPrint('in getFile Containt Grid ${mFilteredFiles.length}');
    return SizedBox(
      height: true
          ? MediaQuery.of(context).size.height * 0.7
          : MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      child: mFilteredFiles.isEmpty
          ? util.Utility.emptyData(context, 'Please Select the Filters')
          : Responsive.isDesktop(context) || Responsive.isTablet(context)
              ? _tableview(mFilteredFiles)
              : GridView.builder(
                  itemCount: mFilteredFiles.length,
                  itemBuilder: (context, index) =>
                      _listTile(mFilteredFiles[index]),
                  gridDelegate:
                      util.Utility.getResponsiveGridViewStyle(context),
                ),
    );
    // return Responsive.isDesktop(context) || Responsive.isTablet(context) ? _tableview(mFilteredFiles) : GridView.builder(
    //       itemCount: mFilteredFiles.length,
    //       itemBuilder: (context, index) =>
    //           _listTile(mFilteredFiles[index]),
    //       gridDelegate: util.Utility.getResponsiveGridViewStyle(context),
    //     );
  }

  Container _leading(FolderFiles files) {
    return Container(
      color: LightColors.kLightGrayM,
      child: FolderButton(
        icon: SizedBox(
          height: 24,
          width: 24,
          child: Card(
              elevation: 1,
              color: Colors.white,
              child: files.type == 'file'
                  ? Image(image: AssetImage('assets/icons/ic_file.png'))
                  : isImage(files.url!)
                      ? FadeInImage(
                          placeholder:
                              AssetImage(getAttachmentIcon(files.url!)),
                          image: NetworkImage(files.url!),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image(
                                image:
                                    AssetImage(getAttachmentIcon(files.url!)));
                          },
                        )
                      : Image.asset(
                          getAttachmentIcon(files.url!),
                          width: 24,
                          height: 24,
                        )),
        ),
        isOpen: null,
        onPressed: null,
      ),
    );
  }

  final tableController = PagedDataTableController<String, FolderFiles>();

  MyDataTable<FolderFiles> _tableview(List<FolderFiles> files) {
    return MyDataTable(
      headers: ['File Name', 'Description', 'Size', 'Action'],
      title: 'Zll Documents',
      tableController: tableController,
      items: files,
      displayFunction: (index, item) {
        switch (index) {
          case 0:
            return Text(
              item.fileName!,
              style: LightColors.textvSmallStyle,
              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
            );
          case 1:
            return item.description != null && item.description!.isNotEmpty
                ? Text(item.description!,
                    style: LightColors.textvSmallStyle,
                    textScaler:
                        TextScaler.linear(ScaleSize.textScaleFactor(context)))
                : Text('');
          case 2:
            return item.size != null && item.size!.isNotEmpty
                ? Text(item.size!,
                    style: LightColors.textvSmallStyle,
                    textScaler:
                        TextScaler.linear(ScaleSize.textScaleFactor(context)))
                : Text('');
          case 3:
            return item.type != null && item.type!.isNotEmpty
                ? Text(item.type!,
                    style: LightColors.textvSmallStyle,
                    textScaler:
                        TextScaler.linear(ScaleSize.textScaleFactor(context)))
                : Text('');
        }
        return Text('');
      },
      onClick: (index, value) {
        //debugPrint('onFile Tap with ${value.isDownlaod}');
        octaveUtil.Utils.onFileTapKidzee(context, value.fileName!, value.url!,
            value.password ?? '', isDownloadAccess(value.categoryid));
      },
      fetch: (pageSize, sortModel, filterModel, pageToken) async {
        return getItemsForPage(
            int.parse(pageToken) - 1, pageSize, mFilteredFiles);
      },
      getColoumSize: (index) {
        switch (index) {
          case 2:
            return const FixedColumnSize(100);
          case 3:
            return const FixedColumnSize(100);
        }
        return RemainingColumnSize();
      },
    );
  }

  bool isDownloadAccess(int parentId) {
//     debugPrint('Download Access ----');
    try {
      FolderModel? model = findFolderById(parentId);
      if (model == null) {
//         debugPrint('Download Access false');
        return false;
      } else {
//         debugPrint('Download Access ${model.isDownload}');
        return model.isDownload;
      }
    } catch (e) {}
    return false;
  }

  List<FolderFiles> getItemsForPage(
      int pageIndex, int itemPerPage, List<FolderFiles> items) {
    final int startIndex = pageIndex * itemPerPage;
    final int endIndex = (startIndex + itemPerPage) < items.length
        ? (startIndex + itemPerPage)
        : items.length;

    return items.sublist(startIndex, endIndex);
  }

  InkWell _listTile(FolderFiles files) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () {
        octaveUtil.Utils.onFileTapKidzee(context, files.fileName!, files.url!,
            files.password ?? '', isDownloadAccess(files.categoryid!));
      },
      child: Card(
        color: Colors.white,
        child: Center(
          child: ListTile(
            leading: _leading(files),
            trailing: files.photoDate == null || files.photoDate!.isEmpty
                ? null
                : Text(files.photoDate!),
            title: Text(
              files.fileName!.isEmpty ? 'NA' : files.fileName!,
              style: LightColors.textHeaderStyle13,
            ),
            subtitle: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // Ensures Column height fits content
                children: [
                  if (files.description != null &&
                      files.description!.isNotEmpty)
                    Text(
                      files.description!,
                      style: LightColors.subTextStyle,
                    ),
                  if (files.size != null && files.size!.isNotEmpty)
                    Text(
                      'Size : ${files.size!}',
                      style: LightColors.subTextStyle,
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card _gridView(FolderFiles files) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: ListTile(
        leading: FolderButton(
          icon: SizedBox(
            height: 30,
            width: 30,
            child: Card(
              elevation: 1,
              color: Colors.white,
              child: files.type == 'file'
                  ? Image(
                      image:
                          AssetImage('{ZLLSaathiPKG}assets/icons/ic_file.png'))
                  : isImage(files.url!)
                      ? FadeInImage(
                          placeholder:
                              AssetImage(getAttachmentIcon(files.url!)),
                          image: NetworkImage(files.url!),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image(
                                image:
                                    AssetImage(getAttachmentIcon(files.url!)));
                          },
                        )
                      : Image(image: AssetImage(getAttachmentIcon(files.url!))),
            ),
          ),
          isOpen: null,
          onPressed: null,
        ),
        subtitle: Text(files.description!),
        title: InkWell(
          onTap: () {
            octaveUtil.Utils.onFileTapKidzee(
                context,
                files.fileName!,
                files.url!,
                files.password ?? '',
                isDownloadAccess(files.categoryid!));
          },
          child: Text(
            files.title!.isEmpty ? 'FILE NAME NOT FOUND' : files.title!,
            style: LightColors.textHeaderStyle13,
          ),
        ),
      ),
    );
  }

  Container getFilesContent() {
    return Container(
        child: ListView.builder(
      itemCount: mFilteredFiles.length,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
            child: Row(
              children: [
                // Add a widget to indicate the expansion state of this node.
                // See also: ExpandIcon.
                FolderButton(
                  icon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      child: mFilteredFiles[i].type == 'file'
                          ? Image(
                              image: AssetImage(
                                  '{ZLLSaathiPKG}assets/icons/ic_file.png'))
                          : isImage(mFilteredFiles[i].url!)
                              ? FadeInImage(
                                  placeholder: AssetImage(getAttachmentIcon(
                                      mFilteredFiles[i].url!)),
                                  image: NetworkImage(mFilteredFiles[i].url!),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image(
                                        image: AssetImage(getAttachmentIcon(
                                            mFilteredFiles[i].url!)));
                                  },
                                )
                              : Image(
                                  image: AssetImage(getAttachmentIcon(
                                      mFilteredFiles[i].url!))),
                    ),
                  ),
                  isOpen: null,
                  onPressed: null,
                ),
                InkWell(
                  onTap: () {
                    octaveUtil.Utils.onFileTapKidzee(
                        context,
                        mFilteredFiles[i].fileName!,
                        mFilteredFiles[i].url!,
                        mFilteredFiles[i].password ?? '',
                        isDownloadAccess(mFilteredFiles[i].categoryid!));
                  },
                  child: Text(
                    mFilteredFiles[i].title!,
                    style: LightColors.textHeaderStyle13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  void findNodes(List<MyNode> currentNodes, int parentID) {
    for (var node in currentNodes) {
      if (node.parentID == parentID) {
        //currentNode.add(node);
        // Recursively search through children
        //findNodes(node.children,parentID);
      } else {
        // Search children of nodes that are not a match
        findNodes(node.children, parentID);
      }
    }
  }

  List<FolderFiles> mFilteredFiles = [];
  List<FolderModel> mFolderModels = [];
  void findFiles(int parentID) {
    mFilteredFiles.clear();
    if (parentID == widget.folderData.contentid) {
      //mFilteredFiles.addAll(mFiles);
    } else {
      for (var node in mFiles) {
        if (node.categoryid == parentID) {
          mFilteredFiles.add(node);
        }
      }
    }
  }

  List<FolderModel> findFolders(int parentID) {
    List<FolderModel> mFolderModels = [];
    for (var node in folders) {
      if (node.parentContentId == parentID) {
        mFolderModels.add(node);
      }
    }

    return mFolderModels;
  }

  void updateFilter(int parentId) {
    List<FolderModel> list = findFolders(parentId);
    if (list.isNotEmpty) {
      currentNode.add(list);
      _controllers.add(TextEditingController());
    } else {
      paths.removeLast();
      if (historyList.isNotEmpty) {
        historyList.removeLast();
      }
    }
    if (parentId > 0) findFiles(parentId);
    setState(() {});
    tableController.refresh();
  }

  void pop() {
    historyList.removeLast();
    supportPath = historyList.last.name;
    updateFilter(historyList.last.contentId);
  }

  FolderModel? findFolderById(int contentId) {
    // debugPrint(contentId);
    try {
      return folders.firstWhere((folder) => folder.contentId == contentId);
    } catch (e) {
      // Return null if not found
      return null;
    }
  }

  void push(FolderModel data, String supportName) {
    bool isPathExists = paths.contains(data.name);
    if (isPathExists) {
      updateFilter(data.contentId);
    } else {
      String path = data.name;
      if (supportPath.isEmpty) {
        supportPath = data.name;
      } else {
        supportPath = "$supportPath/${data.name}";
      }
      paths.add(data.name);
      //path = supportPath;
      historyList.add(data);
      updateFilter(data.contentId);
    }
  }
}

class DropdownWidget extends StatefulWidget {
  final MyNode node;

  const DropdownWidget({super.key, required this.node});

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  MyNode? _selectedNode;

  @override
  void initState() {
    super.initState();
    // Initialize selectedNode if needed
    _selectedNode =
        widget.node.children.isNotEmpty ? widget.node.children[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<MyNode>(
      hint: Text(widget.node.title),
      value: _selectedNode,
      onChanged: (MyNode? newValue) {
        setState(() {
          _selectedNode = newValue;
        });
      },
      items: widget.node.children.map<DropdownMenuItem<MyNode>>((MyNode node) {
        return DropdownMenuItem<MyNode>(
          value: node,
          child: Text(node.title),
        );
      }).toList(),
    );
  }
}

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 4400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
