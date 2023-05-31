// 🐦 Flutter imports:
import 'package:flutter/material.dart';

enum LoaderTypes {
  waveDot,
  inkDrop,
  twistingDots,
  threeRotatingDots,
  staggeredDotsWave,
  fourRotatingDots,
  fallingDot,
  progressiveDots,
  discreteCircular,
  threeArchedCircle,
  bouncingBall,
  flickr,
  hexagonDots,
  beat,
  twoRotatingArc,
  horizontalRotatingDots,
  newtonCradle,
  stretchedDots,
  halfTriangleDot,
  dotsTriangle,
}

class LoaderConfigration {
  final double backgroundOpcaity;
  final Color backgroundColor;
  final LoaderTypes loaderTypes;
  final double loaderSize;

  const LoaderConfigration({
    this.backgroundOpcaity = 0.3,
    this.backgroundColor = Colors.black,
    this.loaderTypes = LoaderTypes.beat,
    this.loaderSize = 100,
  });
}
