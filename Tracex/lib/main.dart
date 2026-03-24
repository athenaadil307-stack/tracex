import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screen_brightness/screen_brightness.dart';

void main() {
runApp(const TraceXApp());
}

class TraceXApp extends StatelessWidget {
const TraceXApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'TraceX',
theme: ThemeData.dark(),
home: const HomePage(),
);
}
}

class HomePage extends StatefulWidget {
const HomePage({super.key});

@override
State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
File? _image;
double _opacity = 0.5;
bool _locked = false;
bool _blackBg = true;
bool _showGrid = false;

final picker = ImagePicker();

Future<void> pickImage() async {
final picked = await picker.pickImage(source: ImageSource.gallery);
if (picked != null) {
setState(() {
_image = File(picked.path);
});
}
}

void toggleLock() {
setState(() {
_locked = !_locked;
});
}

void toggleBg() {
setState(() {
_blackBg = !_blackBg;
});
}

void toggleGrid() {
setState(() {
_showGrid = !_showGrid;
});
}

Future<void> boostBrightness() async {
await ScreenBrightness().setScreenBrightness(1.0);
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: _blackBg ? Colors.black : Colors.white,
body: Stack(
children: [
if (_image != null)
Center(
child: InteractiveViewer(
panEnabled: !_locked,
scaleEnabled: !_locked,
child: Opacity(
opacity: _opacity,
child: Image.file(_image!),
),
),
),

```
      if (_showGrid)
        IgnorePointer(
          child: CustomPaint(
            size: Size.infinite,
            painter: GridPainter(),
          ),
        ),

      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black54,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: _opacity,
                min: 0.1,
                max: 1.0,
                onChanged: (val) {
                  setState(() {
                    _opacity = val;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: pickImage,
                  ),
                  IconButton(
                    icon: Icon(_locked ? Icons.lock : Icons.lock_open),
                    onPressed: toggleLock,
                  ),
                  IconButton(
                    icon: const Icon(Icons.grid_on),
                    onPressed: toggleGrid,
                  ),
                  IconButton(
                    icon: const Icon(Icons.brightness_high),
                    onPressed: boostBrightness,
                  ),
                  IconButton(
                    icon: const Icon(Icons.flip),
                    onPressed: toggleBg,
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ],
  ),
);
```

}
}

class GridPainter extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {
final paint = Paint()
..color = Colors.grey.withOpacity(0.5)
..strokeWidth = 0.5;

```
const step = 40;

for (double i = 0; i < size.width; i += step) {
  canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
}

for (double i = 0; i < size.height; i += step) {
  canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
}
```

}

@override
bool shouldRepaint(CustomPainter oldDelegate) => false;
}
