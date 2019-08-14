import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:restorder/logic/bloc/drawer_bloc.dart';
import 'package:restorder/models/drawer/drawer_response.dart';
import 'package:restorder/ui/widgets/common_scaffold.dart';
import 'package:restorder/utils/translations.dart';
import 'package:restorder/utils/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  DrawerBloc drawerBloc;
  File _image;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    drawerBloc = new DrawerBloc();
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = image;

    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('profile', "");
    sharedPreferences.setString('profile', _image.path);

    drawerBloc.userController.add(DrawerResponse(
        username: sharedPreferences.get("userName"),
        email: sharedPreferences.get("mobile"),
        photo: _image));
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appTitle: Translations.of(context).text("drawer_profile").toUpperCase(),
      showDrawer: false,
      scaffoldKey: _scaffoldState,
      bodyData: _bodyData(),
      showBottomNav: false,
      showOrderItems: false,
    );
  }

  _bodyData() {
    return ListView(
      children: <Widget>[
        StreamBuilder<DrawerResponse>(
            stream: drawerBloc.user,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Stack(
                      children: <Widget>[
                        Container(
                          height: 280.0,
                          width: double.infinity,
                        ),
                        Container(
                          height: 200.0,
                          width: double.infinity,
                          color: Color(0xFFF5F5F5),
                        ),
                        Positioned(
                          top: 125.0,
                          left: 15.0,
                          right: 15.0,
                          child: Material(
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20.0),
                                  top: Radius.circular(2.0)),
                            ),
                            child: Container(
                              height: 150.0,
                              /*  decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Colors.white),*/
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40.0,
                          left: (MediaQuery.of(context).size.width / 2 - 70.0),
                          child: Container(
                            child: new Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 0.0),
                                  child:
                                      new Stack(fit: StackFit.loose, children: <
                                          Widget>[
                                    new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Center(
                                          child: snapshot.data.photo == null
                                              ? new CircleAvatar(
                                                  backgroundImage:
                                                      new ExactAssetImage(
                                                          UIData.imageProfile),
                                                  radius: 65.0,
                                                )
                                              : new CircleAvatar(
                                                  backgroundImage:
                                                      new FileImage(
                                                          snapshot.data.photo),
                                                  radius: 65.0,
                                                ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 90.0, left: 90.0),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new FloatingActionButton(
                                              foregroundColor: Colors.grey,
                                              backgroundColor: Colors.white,
                                              onPressed: getImage,
                                              tooltip: 'Pick Image',
                                              child: Icon(Icons.add_a_photo),
                                            ),
                                          ],
                                        )),
                                  ]),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 200.0,
                          left: 15.0,
                          right: 15.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snapshot.data.username,
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0),
                              ),
                              SizedBox(height: 12.0),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.email,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontSize: 17.0,
                                          color: Color(0xFFFFB74D)),
                                    )
                                  ])
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container();
            })
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
