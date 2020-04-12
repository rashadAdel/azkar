import 'package:flutter/material.dart';

class CardData {
  final Color color;
  final String title;
  double angle;
  final AlignmentGeometry align;

  CardData({
    @required this.color,
    @required this.title,
    this.angle = 0,
    this.align = Alignment.center,
  });
  
}
