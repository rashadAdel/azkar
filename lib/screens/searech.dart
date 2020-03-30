import 'package:azkar/Routes/Router.gr.dart';
import 'package:azkar/bloc/azkar/azkar_bloc.dart';
import 'package:azkar/model/zekr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchControll = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchControll,
          textInputAction: TextInputAction.search,
          onChanged: (val) {
            setState(() {});
          },
          onEditingComplete: () {
            BlocProvider.of<AzkarBloc>(context)
                .add(Search.byName(_searchControll.text));

            Router.navigator.pop();
          },
          decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              hintText: "بحث"),
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.right,
          autofocus: true,
          textDirection: TextDirection.rtl,
        ),
      ),
      body: lstView(),
    );
  }

  Widget lstView() {
    return FutureBuilder<List<ZekrModel>>(
      future: ZekrModel.fromDataBase(
          where: "`name` like '%${_searchControll.text}%'"),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ZekrModel zekr = snapshot.data[index];

                  return ListTile(
                    onTap: () {
                      BlocProvider.of<AzkarBloc>(context)
                          .add(Search.byId(zekr.id));
                      Router.navigator.pop();
                    },
                    contentPadding: EdgeInsets.all(20),
                    title: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          gapPadding: 0,
                        ),
                        filled: true,
                        labelText: zekr.category,
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.withOpacity(.7),
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      controller: TextEditingController(text: zekr.name)
                        ..selection = (_searchControll.text != null)
                            ? TextSelection(
                                baseOffset:
                                    zekr.name.indexOf(_searchControll.text),
                                extentOffset:
                                    zekr.name.indexOf(_searchControll.text) +
                                        _searchControll.text.length)
                            : null,
                      enabled: false,
                      maxLines: null,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  );
                },
              );
      },
    );
  }
}
