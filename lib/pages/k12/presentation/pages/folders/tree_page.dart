import 'package:ekidzee/pages/k12/data/models/directory/folder_model.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:literaoctave/core/utils.dart' as octaveUtil;
import 'package:saathi/core/utility/utils.dart';

class FolderTree extends StatefulWidget {
  final FolderData folderData;
  const FolderTree({super.key, required this.folderData});

  @override
  State<FolderTree> createState() => _MyTreeViewState();
}

class _MyTreeViewState extends State<FolderTree> {
  // This controller is responsible for both providing your hierarchical data
  // to tree views and also manipulate the states of your tree nodes.
  late final TreeController<MyNode> treeController;
  List<FolderModel> folders = [];
  List<FolderFiles> mFiles = [];
  final TextEditingController _controller = TextEditingController();

  List<MyNode> _filteredNodes = [];
  String _searchQuery = '';
  var nodes;
  @override
  void initState() {
    super.initState();
    folders.addAll(widget.folderData.folders!);
    mFiles.addAll(widget.folderData.files!);
    nodes = buildTree(folders, mFiles);
    treeController = TreeController<MyNode>(
      // Provide the root nodes that will be used as a starting point when
      // traversing your hierarchical data.
      roots: nodes,
      // Provide a callback for the controller to get the children of a
      // given node when traversing your hierarchical data. Avoid doing
      // heavy computations in this method, it should behave like a getter.
      childrenProvider: (MyNode node) => node.children,
    );
  }

  @override
  void dispose() {
    // Remember to dispose your tree controller to release resources.
    treeController.dispose();
    super.dispose();
  }

  // Method to perform recursive search
  List<MyNode> _searchNodes(List<MyNode> nodes, String query) {
    List<MyNode> results = [];

    for (var node in nodes) {
      if (node.title.toLowerCase().contains(query.toLowerCase())) {
        results.add(node);
      }
      if (node.children.isNotEmpty) {
        results.addAll(_searchNodes(node.children, query));
      }
    }

    return results;
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredNodes = _searchNodes(nodes, _searchQuery);
      treeController.roots = _filteredNodes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              height: 45,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Search ',
                ),
                onChanged: (value) {
                  _updateSearchQuery(_controller.text);
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              child: TreeView<MyNode>(
                // This controller is used by tree views to build a flat representation
                // of a tree structure so it can be lazy rendered by a SliverList.
                // It is also used to store and manipulate the different states of the
                // tree nodes.
                treeController: treeController,
                // Provide a widget builder callback to map your tree nodes into widgets.
                nodeBuilder: (BuildContext context, TreeEntry<MyNode> entry) {
                  // Provide a widget to display your tree nodes in the tree view.
                  //
                  // Can be any widget, just make sure to include a [TreeIndentation]
                  // within its widget subtree to properly indent your tree nodes.
                  return MyTreeTile(
                    // Add a key to your tiles to avoid syncing descendant animations.
                    key: ValueKey(entry.node),
                    // Your tree nodes are wrapped in TreeEntry instances when traversing
                    // the tree, these objects hold important details about its node
                    // relative to the tree, like: expansion state, level, parent, etc.
                    //
                    // TreeEntrys are short lived, each time TreeController.rebuild is
                    // called, a new TreeEntry is created for each node so its properties
                    // are always up to date.
                    entry: entry,
                    // Add a callback to toggle the expansion state of this node.
                    onTap: () => treeController.toggleExpansion(entry.node),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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

  // Convert a list of FolderModel to a list of TreeNode
  List<MyNode> buildTree(List<FolderModel> folders, List<FolderFiles> mFiles) {
    final Map<int, MyNode> nodeMap = {};

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
          key: file.pID!,
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
}

class MyNode {
  MyNode({
    required this.title,
    required this.key,
    required this.parentID,
    required this.isFile,
    this.url,
    required this.data,
    this.children = const <MyNode>[],
  });

  final String title;
  final int key;
  final int parentID;
  final bool isFile;
  String? url = '';
  dynamic data;
  final List<MyNode> children;
}

// Create a widget to display the data held by your tree nodes.
class MyTreeTile extends StatelessWidget {
  const MyTreeTile({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final TreeEntry<MyNode> entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // Wrap your content in a TreeIndentation widget which will properly
      // indent your nodes (and paint guides, if required).
      //
      // If you don't want to display indent guides, you could replace this
      // TreeIndentation with a Padding widget, providing a padding of
      // `EdgeInsetsDirectional.only(start: TreeEntry.level * indentAmount)`
      child: TreeIndentation(
        entry: entry,
        // Provide an indent guide if desired. Indent guides can be used to
        // add decorations to the indentation of tree nodes.
        // This could also be provided through a DefaultTreeIndentGuide
        // inherited widget placed above the tree view.
        guide: const IndentGuide.connectingLines(indent: 48),
        // The widget to render next to the indentation. TreeIndentation
        // respects the text direction of `Directionality.maybeOf(context)`
        // and defaults to left-to-right.
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
                    child: !entry.node.isFile
                        ? Image(
                            image: AssetImage(
                                '{ZLLSaathiPKG}assets/icons/ic_file.png'))
                        : isImage(entry.node.url!)
                            ? FadeInImage(
                                placeholder: AssetImage(
                                    getAttachmentIcon(entry.node.url!)),
                                image: NetworkImage(entry.node.url!),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image(
                                      image: AssetImage(
                                          getAttachmentIcon(entry.node.url!)));
                                },
                              )
                            : Image(
                                image: AssetImage(
                                    getAttachmentIcon(entry.node.url!))),
                  ),
                ),
                isOpen: entry.hasChildren ? entry.isExpanded : null,
                onPressed: entry.hasChildren ? onTap : null,
              ),
              entry.node.isFile
                  ? InkWell(
                      onTap: () {
//                         debugPrint('on File Tap ${entry.node.url!}');
                        octaveUtil.Utils.onFileTapKidzee(
                            context, '', entry.node.url!, '', false);
                      },
                      child: Text(
                        entry.node.title,
                        style: LightColors.textHeaderStyle13,
                      ),
                    )
                  : Text(
                      entry.node.title,
                      style: LightColors.textHeaderStyle13,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
