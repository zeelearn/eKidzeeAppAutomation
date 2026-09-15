import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyInfoScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyInfo createState() => _MyInfo();
}

class _MyInfo extends State<MyInfoScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String displayName = '';
  var emailId;
  String userType = '';
  String mobileNumber = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String userId = prefs.getString(LocalConstant.KEY_UID)!;
    String userId = prefs.getString(LocalConstant.KEY_USER_ID) ?? "uid";
    //debugPrint('//debugPrint(userId); ${userId}');
    displayName = prefs.getString(LocalConstant.KEY_DISPLAY_NAME) as String;
    emailId = prefs.getString(LocalConstant.KEY_EMAILID);
    mobileNumber = prefs.getString(LocalConstant.KEY_MOBILENO) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE_NAME) as String;
    //debugPrint('email ${emailId} DP ${displayName} MOB ${mobileNumber} TYPE ${userType}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.save), onPressed: () {})
        ],
      ),*/
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.verified_user_sharp),
            title: Text(displayName),
            subtitle: const Text('Name'),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(emailId == null ? '' : emailId),
            subtitle: const Text('E-Mail'),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: const Text('User Type'),
            subtitle: Text(userType == null ? '' : userType),
          ),
          Divider(
            height: 1.0,
          ),
          (userType == 'P')
              ? Center(
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: new EdgeInsets.all(7.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: new EdgeInsets.all(7.0),
                                  child: new Text(
                                    'IllumeKit',
                                    style: new TextStyle(fontSize: 18.0),
                                  ),
                                ),
                                Padding(
                                  padding: new EdgeInsets.all(7.0),
                                  child: new Icon(Icons.check),
                                ),
                                Padding(
                                  padding: new EdgeInsets.all(7.0),
                                  child: new Text('KG KIT',
                                      style: new TextStyle(fontSize: 18.0)),
                                ),
                                Padding(
                                  padding: new EdgeInsets.all(7.0),
                                  child: new Icon(Icons.check),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                )
              : Text(''),
        ],
      ),
    );
  }
}
