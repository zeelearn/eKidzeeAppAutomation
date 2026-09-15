import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/pages/k12/data/models/directory/class_subject_model.dart';
import 'package:ekidzee/pages/k12/data/models/directory/folder_model.dart';
import 'package:ekidzee/pages/k12/presentation/pages/folders/dropdownexample.dart';
import 'package:ekidzee/pages/k12/presentation/providers/folder_provider.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:saathi/core/responsive.dart';

class FolderPage extends StatefulWidget {
  String classId;
  int subject;
  String parentFolderName;
  int projectid;
  String userName;

  FolderPage(
      {super.key,
      required this.classId,
      required this.parentFolderName,
      required this.projectid,
      required this.subject,
      required this.userName});

  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late Future<FoldersStructureModel> _foldersFuture;

  late Future<ClassSubjectMasterModel> _subjectMasterFuture;

  ClassSubjectModel? mSelectedClass;
  SubjectModel? mSelectedSubject;

  List<SubjectModel> mSubjectList = [];

  FolderData mFolderData = FolderData(folders: [], files: [], contentid: 0);

  final TextEditingController _contClass = TextEditingController();
  final TextEditingController _contSubject = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the Future to fetch folders
    loadFolders();
  }

  @override
  Widget build(BuildContext context) {
    double screentype = Responsive.isMobile(context)
        ? 2.4
        : Responsive.isTablet(context)
            ? 4.6
            : 4.4;
    return Scaffold(
      body: _folderstructure(),
    );
  }

  _folderstructure() {
    return mFolderData.files!.isNotEmpty || mFolderData.folders!.isNotEmpty
        ? Container(
            color: LightColors.kLightGrayM,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.78,
            child: DropdownExample(
              folderData: mFolderData,
              root: widget.parentFolderName,
            ),
            //child: FolderTree(folderData: mFolderData)
          )
        : Center(
            child: Utility.emptyData(context, 'Data not avaliable'),
          );
  }

  loadFolders() async {
    FoldersStructureModel data = await FolderStructureProvider.getFolders(
        widget.classId, null, widget.parentFolderName, 1, widget.userName);
    setState(() {
      mFolderData.files!.clear();
      mFolderData.folders!.clear();
      if (data.data!.isNotEmpty) {
        if (data.data![0].files != null && data.data![0].files!.isNotEmpty)
          mFolderData.files!.addAll(data.data![0].files!);
        if (data.data![0].folders != null && data.data![0].folders!.isNotEmpty)
          mFolderData.folders!.addAll(data.data![0].folders!);
        mFolderData.contentid = data.data![0].contentid;

//           debugPrint('Folders ${mFolderData.folders!.length}');
      }
    });
  }
}
