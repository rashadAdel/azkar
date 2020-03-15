import 'package:azkar/Routes/Router.gr.dart';
import 'package:azkar/model/zekr.dart';
import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final ZekrModel zekrModel;
  const EditDialog({Key key, this.zekrModel = const ZekrModel()})
      : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  @override
  Widget build(BuildContext context) {
    var infinity = false;
        return AlertDialog(
          title: Text(widget.zekrModel.name == "" ? "أضافة ذكر" : "تعديل ذكر",
              textAlign: TextAlign.center),
          content: Column(
            children: <Widget>[
              TextFormField(
                initialValue: widget.zekrModel.name,
              ),
              TextFormField(
                initialValue: widget.zekrModel.about,
              ),
              ListTile(
                leading: Switch(value: infinity, onChanged: (val){
                  setState(() {
                    infinity=val;
                  });
            },),
                      title:  TextFormField(
              enabled: infinity,
              keyboardType: TextInputType.number ,
              decoration: InputDecoration(
                 hintText: "number"
              ),
              initialValue: widget.zekrModel.target.toString(),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Router.navigator.pop();
          },
          child: Text(widget.zekrModel.name == "" ? "أضافة" : "تعديل"),
        ),
        FlatButton(
          onPressed: () {
            Router.navigator.pop();
          },
          child: Text("الغاء"),
        ),
      ],
    );
  }
}
