import 'package:azkar/Routes/Router.gr.dart';
import 'package:azkar/screens/category.dart';
import 'package:azkar/screens/zekr.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfo {
  static const String downloadLink = 'https://flutter4u.page.link/download';
  static const String whatsappLink = "https://wa.me/201017949727";
  static const double version = 1;

  static void checkUpdate({bool showOnFailed = false}) {
    ScaffoldState scafoldState = (showOnFailed)
        ? ZekrPage.globalKey.currentState
        : Category.global.currentState;
    Connectivity().checkConnectivity().then((_connect) {
      // no network
      if (_connect == ConnectivityResult.none) {
        if (showOnFailed) {
          Router.navigator.pop();
          scafoldState.showSnackBar(
            SnackBar(
              content: Text(
                "لا يوجد اتصال بالانترنت",
                textAlign: TextAlign.center,
              ),
              action: SnackBarAction(
                  label: "x",
                  onPressed: () {
                    scafoldState.hideCurrentSnackBar();
                  }),
            ),
          );
        }
        // there is network
      } else {
        cloudVersion.then(
          (_version) {
            //There is update
            if (_version > version) {
              if (showOnFailed) Router.navigator.pop();
              scafoldState.showSnackBar(
                SnackBar(
                  content: Text(
                    "يوجد اصدار جديد",
                    textAlign: TextAlign.center,
                  ),
                  action: SnackBarAction(
                      label: "تحديث",
                      onPressed: () {
                        canLaunch(downloadLink).then(
                          (can) {
                            if (can) {
                              launch(downloadLink).then((open) {
                                if (open) {
                                  Router.navigator.pop();
                                }
                              });
                            }
                          },
                        );
                      }),
                ),
              );
            }
            // u in the latest version
            else {
              if (showOnFailed) {
                Router.navigator.pop();
                scafoldState.showSnackBar(SnackBar(
                  content: Text(
                    "انت على اخر اصدار",
                    textAlign: TextAlign.center,
                  ),
                  action: SnackBarAction(
                      label: "x",
                      onPressed: () {
                        scafoldState.hideCurrentSnackBar();
                      }),
                ));
              }
            }
          },
        );
      }
    });
  }

  ///Todo:get from firebase
  static Future<double> get cloudVersion async => 2;
}
