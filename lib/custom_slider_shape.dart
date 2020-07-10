import 'dart:math' as math;

import 'package:flutter/material.dart';
class CustomSliderThumbShape extends SliderComponentShape {
  Color activeColor;
  double thumpRadius;

  CustomSliderThumbShape({this.activeColor,this.thumpRadius});

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

    context.canvas.drawCircle(center, thumpRadius, innerValueStyle);
  }
}

class CustomSliderTickMarkShape extends SliderTickMarkShape {
  double tickMarkRadius;
  CustomSliderTickMarkShape({this.tickMarkRadius});

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
    context.canvas.drawCircle(center, tickMarkRadius, paint);
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  final double margin;
  final double tickMarkRadius;
  CustomTrackShape(this.margin,this.tickMarkRadius);
   double disabledThumbGapWidth=0.0;

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


  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        @required RenderBox parentBox,
        @required SliderThemeData sliderTheme,
        @required Animation<double> enableAnimation,
        @required TextDirection textDirection,
        @required Offset thumbCenter,
        bool isDiscrete = false,
        bool isEnabled = false,
      }) {
    assert(context != null);
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider track height is less than or equal to 0, then it makes no
    // difference whether the track is painted or not, therefore the painting
    // can be a no-op.
    if (sliderTheme.trackHeight <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(begin: sliderTheme.disabledActiveTrackColor, end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(begin: sliderTheme.disabledInactiveTrackColor, end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation);
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation);
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    double leftTmp = sliderTheme.trackHeight / 2 > tickMarkRadius ? (sliderTheme
        .trackHeight / 2) - 1 : tickMarkRadius;
    // The arc rects create a semi-circle with radius equal to track height.
    final Rect leftTrackArcRect = Rect.fromLTWH(trackRect.left-leftTmp, trackRect.top, trackRect.height, trackRect.height);
    if (!leftTrackArcRect.isEmpty)
      context.canvas.drawArc(leftTrackArcRect, math.pi / 2, math.pi, false, leftTrackPaint);
    final Rect rightTrackArcRect = Rect.fromLTWH(trackRect.right - trackRect.height / 2, trackRect.top, trackRect.height, trackRect.height);
    if (!rightTrackArcRect.isEmpty)
      context.canvas.drawArc(rightTrackArcRect, -math.pi / 2, math.pi, false, rightTrackPaint);

    final Size thumbSize = sliderTheme.thumbShape.getPreferredSize(isEnabled, isDiscrete);
    final Rect leftTrackSegment = Rect.fromLTRB(trackRect.left + trackRect.height / 2 -leftTmp, trackRect.top, thumbCenter.dx - thumbSize.width / 2, trackRect.bottom);
    if (!leftTrackSegment.isEmpty)
      context.canvas.drawRect(leftTrackSegment, leftTrackPaint);
    final Rect rightTrackSegment = Rect.fromLTRB(thumbCenter.dx + thumbSize.width / 2, trackRect.top, trackRect.right, trackRect.bottom);
    if (!rightTrackSegment.isEmpty)
      context.canvas.drawRect(rightTrackSegment, rightTrackPaint);
  }
}