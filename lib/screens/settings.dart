import 'package:azkar/Routes/Router.gr.dart';
import '../models/info.dart';
import 'package:azkar/screens/zekr.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool vibrationValue;
    bool soundValue;
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white, width: 3),
      ),
      title: elevation(
          child: ListTile(
        title: Text(
          "الاعدادات",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )),
      actions: <Widget>[
        RaisedButton(
          elevation: 5,
          color: Theme.of(context).primaryColor,
          onPressed: () async {
            (await SharedPreferences.getInstance())
                .setBool("vibration", vibrationValue);
            (await SharedPreferences.getInstance())
                .setBool("sound", soundValue);
            Router.navigator.pop();
          },
          child: Text(
            "حفظ",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            elevation: 5,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Router.navigator.pop();
            },
            child: Text(
              "الغاء",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
      content: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              vibrationValue = snapshot.data.getBool("vibration") ?? true;
              soundValue = snapshot.data.getBool("sound") ?? true;
              return SingleChildScrollView(
                child: Wrap(
                  children: <Widget>[
                    elevation(
                      child: ListTile(
                        trailing: Text(
                          "الاهتزاز",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Switch(
                          value: vibrationValue ?? true,
                          onChanged: (bool value) {
                            vibrationValue = value;
                          },
                        ),
                      ),
                    ),
                    elevation(
                      child: ListTile(
                        trailing: Text(
                          "الصوت",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Switch(
                          value: soundValue,
                          onChanged: (bool value) {
                            soundValue = value;
                          },
                        ),
                      ),
                    ),
                    elevation(
                      child: ListTile(
                        trailing: Text(
                          "مشاركة",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(
                          Icons.share,
                          color: Colors.blue,
                        ),
                        onTap: () {
                          Share.share("""
شارك برنامج الاذكار واجعلها صدقة جاريه لك

${AppInfo.downloadLink}""");
                        },
                      ),
                    ),
                    elevation(
                      child: ListTile(
                        onTap: () {
                          AppInfo.checkUpdate(showOnFailed: true);
                        },
                        trailing: Text(
                          "تحديث",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(
                          Icons.cloud_download,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    elevation(
                      elevation: 10,
                      child: ListTile(
                        leading: Icon(
                          MdiIcons.whatsapp,
                          color: Colors.green,
                          size: 30.0,
                        ),
                        trailing: Text(
                          "للتواصل والاقتراحات",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Connectivity().checkConnectivity().then(
                            (_connect) {
                              if (_connect == ConnectivityResult.none) {
                                Router.navigator.pop();
                                ZekrPage.globalKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'لا يوجد اتصال بالانترنت',
                                      textAlign: TextAlign.center,
                                    ),
                                    action: SnackBarAction(
                                      label: "x",
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              } else {
                                canLaunch(AppInfo.whatsappLink).then(
                                  (can) {
                                    if (can)
                                      launch(AppInfo.whatsappLink).then((done) {
                                        if (done) Router.navigator.pop();
                                      });
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  LayoutBuilder elevation({Widget child, double elevation = 1}) {
    return LayoutBuilder(
      builder: (BuildContext context, _) => Card(
          elevation: elevation,
          color: Theme.of(context).primaryColor,
          child: child),
    );
  }
}
