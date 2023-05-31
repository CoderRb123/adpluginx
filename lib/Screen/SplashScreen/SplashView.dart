// 🐦 Flutter imports:
import 'package:adpluginx/Utils/Alerts/AlertEngine.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:dio/dio.dart';
import 'package:dog/dog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:pmvvm/pmvvm.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:

class SplashView extends HookWidget {
  final Widget child;
  final bool initAdNetworks;
  final List<String> jsonUrl;
  final List<String> servers;
  final Function(BuildContext ctx, Map mainJson)? onInitComplete;

  const SplashView({
    Key? key,
    required this.child,
    required this.jsonUrl,
    required this.servers,
    this.onInitComplete,
    this.initAdNetworks = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentFetchIndex = useState<int>(0);
    final jsonWithTime = useState<List>([]);
    showUpdateDialog(String url) {
      return showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            CupertinoAlertDialog(
              title: const Text("New Update Available"),
              content: const Text(
                  "New Update for your app is now available please update app to continue"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Update Now"),
                  onPressed: () {
                    launchUrl(Uri.parse(url));
                  },
                ),
              ],
            ),
      );
    }

    mainFetchingLogic() async {
      print("Json Fetch--------> ${jsonWithTime.value[currentFetchIndex
          .value]['mainJson']}");
      Future.microtask(() async {
        try {
          Response response = await Dio().get(
            jsonWithTime.value[currentFetchIndex.value]['mainJson'],
            options: Options(
              receiveDataWhenStatusError: true,
              receiveTimeout: const Duration(minutes: 1),
            ),
          );

          print("Json Fetched--------> ${response.data}");
          if (response.data != null) {
            dog.i(
                title: "Fetching Done",
                tag: "JSON",
                "${jsonWithTime.value[currentFetchIndex.value]['mainJson']}");
            context
                .read<AdBase>()
                .data = response.data;
            if (initAdNetworks) {
              BaseClass().initAdNetworks(onInitComplete: () {
                if (response.data[PackageInfoX().version]['isUpdate'] ??
                    false) {
                  showUpdateDialog(
                      response.data[PackageInfoX().version]['updateUrl']);
                  return;
                }
                String oneSignalKey = response.data["one-signal"] ?? "";
                if (oneSignalKey.isNotEmpty) {
                  oneSignalKey.initOnesignal();
                }
                if (onInitComplete != null) {
                  onInitComplete!(context, response.data);
                } else {
                  if (response.data[PackageInfoX().version]['splashScreen'] ??
                      false) {
                    dog.i("Show Splash Screen Ad");
                    "/home".pushReplaceWithAds(context);
                  } else {
                    dog.i("Show Splash Screen 1");
                    Navigator.pushNamedAndRemoveUntil(
                      NavigationService.navigatorKey.currentContext!,
                      "/home",
                          (route) => false,
                    );
                  }
                }
              });
            } else {
              String oneSignalKey = response.data["one-signal"] ?? "";
              if (oneSignalKey.isNotEmpty) {
                oneSignalKey.initOnesignal();
              }
              if (onInitComplete != null) {
                await PackageInfoX().init();
                onInitComplete!(context, response.data);
              } else {
                if (response.data[PackageInfoX().version]['splashScreen'] ??
                    false) {
                  dog.i("Show Splash Screen Ad");
                  "/home".pushReplaceWithAds(context);
                } else {
                  dog.i("Show Splash Screen 1");
                  Navigator.pushNamedAndRemoveUntil(
                    NavigationService.navigatorKey.currentContext!,
                    "/home",
                        (route) => false,
                  );
                }
              }
            }
          }
        } on DioError catch (e) {
          if (e.type == DioErrorType.connectionTimeout) {
            dog.e(
              e.response,
              title: "Fetching Error",
              tag: "JSON",
            );
          }
          dog.e(
            e.response,
            title: "Fetching Error",
            tag: "JSON",
          );
          if (currentFetchIndex.value < (jsonWithTime.value.length - 1)) {
            currentFetchIndex.value = currentFetchIndex.value + 1;
            AlertEngine.showNetworkError(context, () {
              Navigator.pop(context);
              mainFetchingLogic();
            });
          } else {
            AlertEngine.showCloseApp(context);
            dog.e("Provide Json were Incorrect",
                title: "Json Related", tag: "JSON");
          }
        } catch (e) {
          print("Catche --------> ${e.toString()}");
        }
      });
    }

    fetchMainJson() async {
      NetworkUtils().getFastServer(
        servers,
            (timeList) async {
          jsonWithTime.value = NetworkUtils().sortListByFastest(
            servers,
            timeList,
            jsonUrl,
          );
          dog.i(
            jsonWithTime.value.toString(),
            title: "SortedJson",
          );
          mainFetchingLogic();
        },
      );
    }

    useEffect(() {
      Future.microtask(
            () {
          fetchMainJson();
        },
      );
      return () {};
    }, []);

    return Scaffold(
      body: child,
    );
  }
}
