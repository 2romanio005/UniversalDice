import 'package:flutter/material.dart';
import "package:vector_math/vector_math.dart";
import "package:bezier/bezier.dart";

class CurveCubicBezier extends Curve {
  CurveCubicBezier(double x1, double x2, double x3, double x4)
      : _curve = CubicBezier([
          Vector2(0, 0),
          Vector2(x1, x2),
          Vector2(x3, x4),
          Vector2(1, 1),
        ]),
        super();

  @override
  double transformInternal(double t) {
    return _curve.pointAt(t).y;
  }

  final CubicBezier _curve;
}

//1 - (pow(e, -t / _a) * cos(t * _w));
