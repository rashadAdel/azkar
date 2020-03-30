import 'package:azkar/Routes/Router.gr.dart';
import 'package:azkar/model/zekr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      isFavorite: true);
  TextEditingController _txtZekr, _txtAbout, _txtTarget;
  FocusNode _targetFocus;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _txtZekr = TextEditingController()..text = widget.zekrModel?.name;
    _txtAbout = TextEditingController()..text = widget.zekrModel?.about;
    _txtTarget = TextEditingController()
      ..text = widget.zekrModel?.target?.toString();

    _targetFocus = FocusNode()
      ..addListener(() {
        _txtTarget.selection =
            TextSelection(baseOffset: 0, extentOffset: _txtTarget.text.length);
      });
    _txtZekr.selection =
        TextSelection(baseOffset: 0, extentOffset: _txtZekr.text.length);
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
    return AlertDialog(
      backgroundColor: Colors.orange[100],
      title: Text(widget.zekrModel == null ? "أضافة ذكر" : "تعديل ذكر",
          textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _txtZekr,
                validator: (val) => val.isEmpty ? "يجب ادخال الذكر " : null,
                autofocus: true,
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
                      setState(
                        () {
                          if (!val) {
                            _txtTarget.text = "";
                            FocusScope.of(context).requestFocus(_targetFocus);
                          }
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
                      validator: (val) {
                        if (!infinity) {
                          return val.isEmpty
                              ? "يحب ادخال رقم"
                              : int.tryParse(val) == null ||
                                      int.tryParse(val) < 0
                                  ? "يجب ادخال قيمة اعلى من صفر"
                                  : null;
                        }
                        return null;
                      },
                      controller: _txtTarget,
                      focusNode: _targetFocus,
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
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            if (!_formKey.currentState.validate()) return;
            if (widget.zekrModel == null) {
              _getData.insert();
            } else {
              widget.zekrModel.update(map: _getData.toMap);
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
