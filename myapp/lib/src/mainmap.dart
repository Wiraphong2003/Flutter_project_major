import 'dart:async';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Services.dart';
import '../models/user.dart';
import '../models/users.dart';

class MainMapPage extends StatefulWidget {
  const MainMapPage({Key? key}) : super(key: key);

  @override
  _MainMapPageState createState() => _MainMapPageState();
}

class _MainMapPageState extends State<MainMapPage> {
  BottomDrawerController controller = BottomDrawerController();
  Users? usersData;
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition? _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch user data when the widget is initialized
    _initialCameraPosition = const CameraPosition(
      target: LatLng(16.245697, 103.250159),
      zoom: 15,
    );
  }

  Future<void> fetchData() async {
    try {
      final data = await Services.getUsers();
      setState(() {
        usersData = data;
      });
    } catch (e) {
      // Handle any errors that may occur during the HTTP request
      print('Error fetching data: $e');
    }
  }

  Set<Marker> _createMarkers(LatLng latLng) {
    final markers = <Marker>{};

    if (usersData != null) {
      for (int index = 0; index < usersData!.users.length; index++) {
        final user = usersData!.users[index];
        final marker = Marker(
          markerId: MarkerId(user.id.toString()),
          position: latLng,
          infoWindow: InfoWindow(title: user.name),
        );
        markers.add(marker);
      }
    }

    return markers;
  }

  Future<Set<Marker>> _createMarkersUSER(List<User> users) async {
    final markers = <Marker>{};

    for (final user in users) {
      final marker = Marker(
        markerId: MarkerId(user.id.toString()),
        position: LatLng(user.address.geo.lat as double,
            user.address.geo.lng as double), // ใช้ตำแหน่งจากข้อมูลของผู้ใช้
        infoWindow: InfoWindow(title: user.name),
      );
      markers.add(marker);
    }
    return markers;
  }

  Future<LatLng> _getUserLocationNow() async {
    try {
      final Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final LatLng userLatLng = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      return userLatLng;
    } catch (e) {
      // จัดการข้อผิดพลาดที่เกิดขึ้นในการดึงตำแหน่งปัจจุบัน
      print('เกิดข้อผิดพลาดในการดึงตำแหน่งปัจจุบัน: $e');
      rethrow; // ส่งคืนข้อผิดพลาดให้กับผู้เรียก
    }
  }

  // Future<void> _goToUserLocation() async {
  //   if (usersData != null && usersData!.users.isNotEmpty) {
  //     final user = usersData!.users[0];
  //     final GoogleMapController controller = await _controller.future;
  //     controller.animateCamera(CameraUpdate.newLatLng(
  //       const LatLng(16.245697, 103.250159),
  //     ));
  //   }
  // }

  Future<Set<Marker>> _goToUserLocation(List<User> users) async {
    final markers = <Marker>{};

    for (final user in users) {
      final marker = Marker(
        markerId: MarkerId(user.id.toString()),
        position: const LatLng(16.245697, 103.250159),
        infoWindow: InfoWindow(title: user.name),
      );
      markers.add(marker);
    }
    return markers;
  }

  Future<void> _updateUserLocationOnMap() async {
    try {
      final LatLng userLatLng = await _getUserLocationNow();

      setState(() {
        _initialCameraPosition = CameraPosition(
          target: userLatLng,
          zoom: 15,
        );
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(userLatLng));
    } catch (e) {
      // จัดการข้อผิดพลาดที่เกิดขึ้นในการดึงตำแหน่งปัจจุบัน
      print('เกิดข้อผิดพลาดในการอัปเดตตำแหน่งผู้ใช้บนแผนที่: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // FutureBuilder<LatLng> (
        //   future: _getUserLocationNow(),
        //   builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot)  {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       // แสดง Loader หรือรายการอื่น ๆ ในระหว่างรอข้อมูล
        //       return const CircularProgressIndicator(); // ตัวอย่างเท่านั้น
        //     } else if (snapshot.hasError) {
        //       // แสดงข้อผิดพลาดหากมีข้อผิดพลาดในการดึงตำแหน่งปัจจุบัน
        //       return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        //     } else {
        //       // ใช้ค่าตำแหน่งปัจจุบันเพื่อกำหนด initialCameraPosition ใน GoogleMap
        //       return GoogleMap(
        //         mapType: MapType.normal,
        //         initialCameraPosition: CameraPosition(
        //           target: snapshot.data ?? const LatLng(16.245697, 103.250159),
        //           zoom: 15,
        //         ),
        //         onMapCreated: (GoogleMapController controller) {
        //           _controller.complete(controller);
        //         },
        //         markers: Set<Marker>.from(await _createMarkersUSER(usersData?.users ?? [])),
        //         // markers: _createMarkers(
        //         //     snapshot.data ?? const LatLng(16.245697, 103.250159)),
        //       );
        //     }
        //   },
        // ),
        FutureBuilder<LatLng>(
          future: _getUserLocationNow(),
          builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // แสดง Loader หรือรายการอื่น ๆ ในระหว่างรอข้อมูล
              return const CircularProgressIndicator(); // ตัวอย่างเท่านั้น
            } else if (snapshot.hasError) {
              // แสดงข้อผิดพลาดหากมีข้อผิดพลาดในการดึงตำแหน่งปัจจุบัน
              return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
            } else {
              // ใช้ค่าตำแหน่งปัจจุบันเพื่อกำหนด initialCameraPosition ใน GoogleMap
              return FutureBuilder<Set<Marker>>(
                future: _createMarkersUSER(usersData?.users ?? []),
                builder: (BuildContext context,
                    AsyncSnapshot<Set<Marker>> markersSnapshot) {
                  if (markersSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    // แสดง Loader หรือรายการอื่น ๆ ในระหว่างรอข้อมูล Markers
                    return const CircularProgressIndicator(); // ตัวอย่างเท่านั้น
                  } else if (markersSnapshot.hasError) {
                    // แสดงข้อผิดพลาดหากมีข้อผิดพลาดในการสร้าง Markers
                    return Text(
                        'เกิดข้อผิดพลาดในการสร้าง Markers: ${markersSnapshot.error}');
                  } else {
                    // ใช้ค่าตำแหน่งปัจจุบันและ Markers เพื่อกำหนด GoogleMap
                    return GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: snapshot.data ??
                            const LatLng(16.245697, 103.250159),
                        zoom: 15,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      // markers: markersSnapshot.data ?? {},
                    );
                  }
                },
              );
            }
          },
        ),
        ClipRRect(
          child: BottomDrawer(
            header: Container(
              decoration: const BoxDecoration(
                color:
                    Color.fromARGB(255, 255, 255, 255), // เพิ่มสีให้กับ Header
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: Align(
                          alignment: Alignment.bottomCenter, // ชิดขอบล่าง
                          child: FloatingActionButton(
                            onPressed: () {
                              _updateUserLocationOnMap();
                            },
                            child: const Icon(Icons.my_location),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 120.0),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.horizontal_rule_outlined,
                        size: 50,
                        color: Color.fromARGB(196, 196, 196, 196),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color:
                    Color.fromARGB(255, 255, 255, 255), // เพิ่มสีให้กับ Header
              ),
              child: ListView.builder(
                itemCount: usersData != null ? usersData!.users.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      // Handle onTap logic
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: ListTileTheme(
                        contentPadding: EdgeInsets.zero,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30.0, // ปรับขนาดรูปภาพตามที่คุณต้องการ
                            backgroundImage:
                                NetworkImage(usersData!.users[index].img),
                          ),
                          title: Text(
                            usersData!.users[index].name,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18.0,
                            ),
                          ),
                          subtitle: Text(
                            "Email: ${usersData!.users[index].email}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            headerHeight: 200,
            drawerHeight: 350,
            color: const Color.fromARGB(0, 0, 0, 0),
            controller: controller,
          ),
        ),
      ],
    );
  }
}
