// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pmvvm/pmvvm.dart';

// 🌎 Project imports:
import 'package:adpluginx/Model/LoaderConfigration.dart';
import 'package:adpluginx/Utils/UtilsSingleTone.dart';
import 'package:adpluginx/Widget/Loader/LoaderProvider.dart';

class GlobalAdLoader extends HookWidget {
  final Widget child;

  const GlobalAdLoader({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoaderProvider loaderProvider = context.watch<LoaderProvider>();
    return Material(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            loaderProvider.isAdLoading
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: _getWidget(),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }

  _getWidget() {
    LoaderTypes types = UtilsSingleTone().loaderConfigration.loaderTypes;
    double loaderSize = UtilsSingleTone().loaderConfigration.loaderSize;
    switch (types) {
      case LoaderTypes.waveDot:
        return LoadingAnimationWidget.waveDots(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.inkDrop:
        return LoadingAnimationWidget.inkDrop(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.twistingDots:
        return LoadingAnimationWidget.twistingDots(
          size: loaderSize,
          leftDotColor: Colors.red,
          rightDotColor: Colors.green,
        );
      case LoaderTypes.threeRotatingDots:
        return LoadingAnimationWidget.threeRotatingDots(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.staggeredDotsWave:
        return LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.fourRotatingDots:
        return LoadingAnimationWidget.fourRotatingDots(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.fallingDot:
        return LoadingAnimationWidget.fallingDot(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.progressiveDots:
        return LoadingAnimationWidget.prograssiveDots(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.discreteCircular:
        return LoadingAnimationWidget.discreteCircle(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.threeArchedCircle:
        return LoadingAnimationWidget.threeArchedCircle(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.bouncingBall:
        return LoadingAnimationWidget.bouncingBall(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.flickr:
        return LoadingAnimationWidget.flickr(
          size: loaderSize,
          leftDotColor: Colors.red,
          rightDotColor: Colors.green,
        );
      case LoaderTypes.hexagonDots:
        return LoadingAnimationWidget.hexagonDots(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.beat:
        return LoadingAnimationWidget.beat(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.twoRotatingArc:
        return LoadingAnimationWidget.twoRotatingArc(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.horizontalRotatingDots:
        return LoadingAnimationWidget.horizontalRotatingDots(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.newtonCradle:
        return LoadingAnimationWidget.newtonCradle(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.stretchedDots:
        return LoadingAnimationWidget.stretchedDots(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.halfTriangleDot:
        return LoadingAnimationWidget.halfTriangleDot(
          color: Colors.white,
          size: loaderSize,
        );
      case LoaderTypes.dotsTriangle:
        return LoadingAnimationWidget.dotsTriangle(
          color: Colors.white,
          size: loaderSize,
        );
      default:
        return LoadingAnimationWidget.inkDrop(
          color: Colors.white,
          size: loaderSize,
        );
    }
  }
}
