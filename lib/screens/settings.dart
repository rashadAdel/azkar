import 'package:azkar/Routes/Router.gr.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white, width: 3),
      ),
      title: elevation(
          child: Text(
        "الاعدادات",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      )),
      actions: <Widget>[
        elevation(
          child: FlatButton(
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
        elevation(
          child: FlatButton(
            onPressed: () {},
            child: Text(
              "حفظ",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
      content: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            return Wrap(
              children: <Widget>[
                ListTile(
                  trailing: Text(
                    "الاهتزاز",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Switch(
                    value: snapshot.data.getBool("vibration") ?? true,
                    onChanged: (bool value) {
                      snapshot.data.setBool("vibration", value);
                    },
                  ),
                ),
                ListTile(
                  trailing: Text(
                    "الصوت",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Switch(
                    value: snapshot.data.getBool("sound") ?? true,
                    onChanged: (bool value) {
                      snapshot.data.setBool("sound", value);
                    },
                  ),
                ),
                ListTile(
                  trailing: Text(
                    "مشاركة",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  ),
                ),
                ListTile(
                  trailing: Text(
                    "تحديث",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.cloud_download,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  ),
                ),
                IconButton(
                  icon: Icon(
                    MdiIcons.whatsapp,
                    color: Colors.green,
                  ),
                  onPressed: () async {},
                ),
              ],
            );
          }),
    );
  }

  LayoutBuilder elevation({Widget child}) {
    return LayoutBuilder(
      builder: (BuildContext context, _) => Card(
          elevation: 10, color: Theme.of(context).primaryColor, child: child),
    );
  }
}
