import 'package:flutter/material.dart';

import 'custom_slider_shape.dart';

class CustomSlider extends StatefulWidget {
  final int divisions;
  final int value;
  final RadioSliderOrientation orientation;
  final ValueChanged<int> onChanged;

  final Color activeTrackColor;
  final Color activeTickMarkColor;
  final Color activeThumpColor;

  final Color inactiveTrackColor;
  final Color inactiveTickMarkColor;

  final double thumpSize;
  final double tickMarkShape;
  final double trackHeight;
  final double marginTrackShape;
  const CustomSlider({
    Key key,
    this.divisions = 1,
    this.value = 0,
    this.orientation = RadioSliderOrientation.Horizontal,
    @required this.onChanged,
    this.activeTrackColor = Colors.green,
    this.activeTickMarkColor = Colors.amber,
    this.activeThumpColor,

    this.inactiveTrackColor = Colors.grey,
    this.inactiveTickMarkColor = Colors.red,
    this.thumpSize = 15,
    this.tickMarkShape = 9,
    this.trackHeight=6,
    this.marginTrackShape=30
  })
      : assert(divisions >= 1),
        assert(value >= 0 && value <= divisions),
        super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  num _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  Widget _buildRadioSlider(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: widget.activeTrackColor ,
        activeTickMarkColor: widget.activeTickMarkColor ,
        inactiveTrackColor: widget.inactiveTrackColor,
        inactiveTickMarkColor: widget.inactiveTickMarkColor,
        tickMarkShape: CustomSliderTickMarkShape(tickMarkShape: widget.tickMarkShape),
        thumbShape: CustomSliderThumbShape(
          activeColor: widget.activeThumpColor,
          thumpSize: widget.thumpSize,
        ),
        trackHeight: 6,
        trackShape: CustomTrackShape(widget.marginTrackShape),
      ),
      child: Slider(
        min: 0,
        max: widget.divisions.toDouble(),
        value: _value.toDouble(),
        divisions: widget.divisions,
        onChanged: (value) {
          if (_value != value) {
            setState(() {
              _value = value;
            });
            widget.onChanged(value.toInt());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orientation == RadioSliderOrientation.Vertical) {
      return RotatedBox(quarterTurns: 1, child: _buildRadioSlider(context));
    } else {
      return _buildRadioSlider(context);
    }
  }
}

enum RadioSliderOrientation {
  Vertical,
  Horizontal,
}
