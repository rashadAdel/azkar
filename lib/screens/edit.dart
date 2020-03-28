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
        about: _txtAbout.text,
        name: _txtZekr.text,
        target: infinity ? 0 : int.tryParse(_txtTarget.text) ?? 1,
      );
  TextEditingController _txtZekr;
  TextEditingController _txtAbout;
  TextEditingController _txtTarget;
  FocusNode _targetFocus;

  @override
  void initState() {
    super.initState();
    _txtZekr = TextEditingController();
    _txtAbout = TextEditingController();
    _txtTarget = TextEditingController();
    _targetFocus = FocusNode();
    _targetFocus.addListener(() {
      if (_targetFocus.hasFocus) {
        _txtTarget.selection =
            TextSelection(baseOffset: 0, extentOffset: _txtTarget.text.length);
      }
    });
  }

  @override
  void dispose() {
    _targetFocus.dispose();
    _txtZekr.dispose();
    _txtAbout.dispose();
    _txtTarget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _txtZekr.text = widget.zekrModel?.name;
    _txtAbout.text = widget.zekrModel?.about;
    _txtTarget.text = widget.zekrModel?.target?.toString();
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
              controller: _txtZekr,
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
                labelText: "الذكر",
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.withOpacity(.7),
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _txtAbout,
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
                    //Todo:txtTarget focus
                    _txtTarget.text = "";
                    if (!val) _targetFocus.requestFocus();
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
                : TextFormField(
                    focusNode: _targetFocus,
                    controller: _txtTarget,
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
