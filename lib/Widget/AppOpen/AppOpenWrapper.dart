// 🐦 Flutter imports:
import 'package:adpluginx/Widget/AppOpen/AppOpenProvider.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pmvvm/pmvvm.dart';

// 🌎 Project imports:

class AppOpenWrapper extends HookWidget {
  final Widget child;

  const AppOpenWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppOpenProvider appOpenProvider = context.watch<AppOpenProvider>();
    return Material(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          fit: StackFit.expand,
          children: [
            appOpenProvider.isAdLoading
                ? const TempAdWidget()
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
            child,
          ],
        ),
      ),
    );
  }
}

class TempAdWidget extends HookWidget {
  const TempAdWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {

      return () {};
    }, []);

    return Container();
  }
}
