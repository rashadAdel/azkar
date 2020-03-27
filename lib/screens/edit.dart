import 'package:azkar/Routes/Router.gr.dart';
import 'package:azkar/model/zekr.dart';
import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final ZekrModel zekrModel;
  EditDialog({Key key, this.zekrModel}) : super(key: key) {
    infinity = zekrModel == null || zekrModel.target == 0;
  }
  @override
  _EditDialogState createState() => _EditDialogState();
}

bool infinity;

class _EditDialogState extends State<EditDialog> {
  ZekrModel get _getData => ZekrModel(
        about: txtAbout.text,
        name: txtZekr.text,
        target: infinity ? 0 : int.tryParse("${txtTarget.text}"),
      );

  TextEditingController txtZekr = TextEditingController();
  TextEditingController txtAbout = TextEditingController();
  TextEditingController txtTarget = TextEditingController();

  @override
  Widget build(BuildContext context) {
    txtZekr.text = widget.zekrModel?.name;
    txtAbout.text = widget.zekrModel?.about;
    txtTarget.text = widget.zekrModel?.target?.toString();
    return AlertDialog(
      backgroundColor: Colors.orange[100],
      title: Text(widget.zekrModel == null ? "أضافة ذكر" : "تعديل ذكر",
          textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextField(
              autofocus: true,
              controller: txtZekr,
              textDirection: TextDirection.rtl,
              maxLines: null,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: "الذكر",
                labelStyle: TextStyle(fontSize: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  gapPadding: 0,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: txtAbout,
              textDirection: TextDirection.rtl,
              maxLines: null,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  gapPadding: 0,
                ),
                filled: true,
                labelText: "الفضل",
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.withOpacity(.7),
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Switch(
                  value: infinity,
                  onChanged: (val) {
                    print(infinity);
                    setState(
                      () {
                        infinity = val;
                      },
                    );
                  },
                ),
                Text(
                  "عدد لا نهائى",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            infinity
                ? Container()
                : TextField(
                    controller: txtTarget,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        gapPadding: 0,
                      ),
                      filled: true,
                      labelText: "العدد",
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.withOpacity(.7),
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (widget.zekrModel == null) {
              _getData.insert();
            } else {
              widget.zekrModel.update(_getData);
            }
            Router.navigator.pop(widget.zekrModel ?? _getData);
          },
          child: Text(widget.zekrModel == null ? "أضافة" : "تعديل"),
        ),
        FlatButton(
          onPressed: () {
            Router.navigator.pop(null);
          },
          child: Text("الغاء"),
        ),
      ],
    );
  }
}
