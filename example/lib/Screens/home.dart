import 'package:adpluginx/Engine/Native/NativeEngine.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const String route = "/home";

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List coins = [];

  @override
  void initState() {
    Future.microtask(() {
      NetworkUtils().getSpin(
        onCompleted: (coins) {
          if (mounted) {
            setState(() {
              this.coins = coins;
            });
          }
        },
        onError: (error) {
          print("Coin Error====>");
          print(error);
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        title: const Text(
          "Plugin Example",
        ),
      ),
      body: coins.isEmpty
          ? const Center(
              child: Text("Loading Ads"),
            )
          : AdGridView(
              items: coins,
              onRender: (context, index, value) {
                if (value.runtimeType == String) {
                  return NativeEngine(
                    parentContext: context,
                    onJobComplete: () {},
                  );
                }
                return Center(
                  child: Text(value['title'].toString()),
                );
              },
              parentContext: context,
            ),
    );
  }
}
