import 'package:flutter/material.dart';

class CustomSliderThumbShape extends SliderComponentShape {
  Color activeColor;
  double thumpSize;

  CustomSliderThumbShape({this.activeColor,this.thumpSize});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation, Animation<double> enableAnimation,
        bool isDiscrete, TextPainter labelPainter, RenderBox parentBox,
        SliderThemeData sliderTheme, TextDirection textDirection,
        double value}) {

    var innerValueStyle = Paint()
      ..color = this.activeColor ?? sliderTheme.activeTickMarkColor
      ..style = PaintingStyle.fill;

    context.canvas.drawCircle(center, thumpSize, innerValueStyle);
  }
}

class CustomSliderTickMarkShape extends SliderTickMarkShape {
  double tickMarkShape;
  CustomSliderTickMarkShape({this.tickMarkShape});

  @override
  Size getPreferredSize({SliderThemeData sliderTheme, bool isEnabled}) {
    return Size.fromRadius(0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {RenderBox parentBox, SliderThemeData sliderTheme,
        Animation<double> enableAnimation, Offset thumbCenter, bool isEnabled,
        TextDirection textDirection}) {
    Color begin;
    Color end;
    switch (textDirection) {
      case TextDirection.ltr:
        final bool isTickMarkRightOfThumb = center.dx > thumbCenter.dx;
        print("---ltr---");
        begin = isTickMarkRightOfThumb ? sliderTheme.disabledInactiveTickMarkColor : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkRightOfThumb ? sliderTheme.inactiveTickMarkColor : sliderTheme.activeTickMarkColor;
        break;
      case TextDirection.rtl:
        print("---rtl---");
        final bool isTickMarkLeftOfThumb = center.dx < thumbCenter.dx;
        begin = isTickMarkLeftOfThumb ? sliderTheme.disabledInactiveTickMarkColor : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkLeftOfThumb ? sliderTheme.inactiveTickMarkColor : sliderTheme.activeTickMarkColor;
        break;
    }
    final Paint paint = Paint()..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation);

    // inner circle
    context.canvas.drawCircle(center, 9, paint);
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  final double margin;
  CustomTrackShape(this.margin);
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx+margin;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width-(margin*2);
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}