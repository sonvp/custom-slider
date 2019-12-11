import 'package:flutter/material.dart';
import 'package:flutter_custom_slider/custom_slider.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = SliderTheme.of(context).copyWith(
        trackHeight: 10,
        overlayColor: Colors.lightGreen.withAlpha(32),
        activeTickMarkColor: Colors.lightGreen,
        activeTrackColor: Colors.grey[300],
        inactiveTrackColor: Colors.grey[300],
        inactiveTickMarkColor: Colors.grey[500]
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Slider Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Horizontal with Divisions"),
            CustomSlider(
              activeTrackColor:Colors.green,
              activeTickMarkColor:Colors.amber,
              activeThumpColor:Colors.blue,
              inactiveTrackColor: Colors.grey,
              inactiveTickMarkColor:Colors.red,
              thumpSize: 15,
              tickMarkShape: 9,
              trackHeight: 9,
              onChanged: (value) {
                // Do something
              },
              value: 3,
              divisions: 5,
              trackTrackShape: 30,
            ),

            Divider(),
            Text("Default"),
            CustomSlider(
              onChanged: (value) { /* no-op */ },
            ),
            Divider(),
            Text("Vertical Orientation"),
            SliderTheme(
              data: themeData,
              child: CustomSlider(
                orientation: RadioSliderOrientation.Vertical,
                onChanged: (value) {
                  print("Value changed: ${value.toString()}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
