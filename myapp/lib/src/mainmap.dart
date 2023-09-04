import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMapPage extends StatefulWidget {
  const MainMapPage({Key? key}) : super(key: key);

  @override
  _MainMapPageState createState() => _MainMapPageState();
}

class _MainMapPageState extends State<MainMapPage> {
  GoogleMapController? _controller;
  double _widgetPosition = 0.8; // ความสูงเริ่มต้นของ widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Main Map'),
      // ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _controller = controller;
              });
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(0.0, 0.0), // ตำแหน่งแสดงแผนที่เริ่มต้น
              zoom: 15.0, // ระดับซูมเริ่มต้น
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * _widgetPosition,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // ควบคุมการเลื่อนขึ้นลง
                setState(() {
                  if (_widgetPosition - details.delta.dy / 500 < 0.8 &&
                      _widgetPosition - details.delta.dy / 500 > 0) {
                    _widgetPosition -= details.delta.dy / 500;
                  }
                });
              },
              onVerticalDragEnd: (details) {
                // ควบคุมเมื่อเลื่อนลงจบ
                setState(() {
                  if (_widgetPosition > 0.5) {
                    _widgetPosition = 0.5;
                  } else {
                    _widgetPosition = 0.0;
                  }
                });
              },
              child: Container(
                color: const Color.fromARGB(255, 196, 196, 196),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 300,
                        color: Colors.amber,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
