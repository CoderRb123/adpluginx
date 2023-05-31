// 📦 Package imports:
import 'package:dart_ping/dart_ping.dart';
import 'package:dio/dio.dart';

class NetworkUtils {
  static final NetworkUtils _singleton = NetworkUtils._internal();

  factory NetworkUtils() {
    return _singleton;
  }

  NetworkUtils._internal();

  List<Ping> pingsList = [];
  List<int> pingTimes = [];

  getCoins({
    String forceUrl =
        "https://miracocopepsi.com/admin/mayur/data_darsh/reward.json",
    String listKey = "rewards",
    int? checkIndex = 1,
    String checkKey = "isspin",
    required Function(List coins) onCompleted,
    required Function(String error) onError,
  }) async {
    try {
      Response response = await Dio().get(forceUrl);
      if (checkIndex != null) {
        List temp = [];
        List coinList =
            (listKey.isEmpty ? response.data : response.data[listKey]) ?? [];
        for (int i = 0; i < coinList.length; i++) {
          if (coinList[i][checkKey] == checkIndex) {
            temp.add(coinList[i]);
          }
        }
        onCompleted(
          temp,
        );
      }
      onCompleted(
        listKey.isEmpty ? response.data : response.data[listKey] ?? [],
      );
    } on DioError catch (e) {
      onError(e.message ?? "");
    } catch (e) {
      onError(e.toString());
    }
  }

  getSpin({
    String forceUrl =
        "https://miracocopepsi.com/admin/mayur/data_darsh/reward.json",
    String listKey = "rewards",
    int? checkIndex = 0,
    String checkKey = "isspin",
    required Function(List spins) onCompleted,
    required Function(String error) onError,
  }) async {
    try {
      Response response = await Dio().get(forceUrl);
      if (checkIndex != null) {
        List temp = [];
        List coinList =
            (listKey.isEmpty ? response.data : response.data[listKey]) ?? [];
        for (int i = 0; i < coinList.length; i++) {
          if (coinList[i][checkKey] == checkIndex) {
            temp.add(coinList[i]);
          }
        }
        onCompleted(
          temp,
        );
      }
      onCompleted(
        listKey.isEmpty ? response.data : response.data[listKey] ?? [],
      );
    } on DioError catch (e) {
      onError(e.message ?? "");
    } catch (e) {
      onError(e.toString());
    }
  }

  getFastServer(
      List<String> servers, Function(List<int> timeList) onPingTestCompleted) {
    pingTimes = List.generate(servers.length, (index) => index);
    for (int i = 0; i < servers.length; i++) {
      pingsList.insert(i, Ping(servers[i]));
      pingsList[i].stream.listen((event) {
        pingTimes[i] = event.response?.time?.inMilliseconds ?? 0;
      });
    }
    Future.delayed(const Duration(seconds: 2), () {
      onPingTestCompleted(pingTimes);
      // Stop Pings
      for (final o in pingsList) {
        o.stop();
      }
    });
  }

  List<Map> sortListByFastest(
      List<String> servers, List<int> pingsTimeStamp, List jsonUrl) {
    List<Map> temp = [];
    for (int i = 0; i < servers.length; i++) {
      temp.add(
        {
          "server": servers[i],
          "time": pingsTimeStamp[i],
          "mainJson": getJsonUrl(servers[i], jsonUrl),
        },
      );
    }
    temp.sort(
      (a, b) => (int.tryParse(a['time'].toString()) ?? 0)
          .compareTo((int.tryParse(b['time'].toString()) ?? 0)),
    );
    temp.removeWhere(
      (element) => element['mainJson'] == null,
    );
    temp.removeWhere(
      (element) => element['time'] == 0,
    );
    return temp;
  }

  String? getJsonUrl(String prefix, List jsonUrl) {
    List temp = jsonUrl
        .where(
          (element) => element.toString().toLowerCase().contains(
                prefix.toLowerCase(),
              ),
        )
        .toList();

    return temp.isEmpty ? null : temp[0];
  }
}
