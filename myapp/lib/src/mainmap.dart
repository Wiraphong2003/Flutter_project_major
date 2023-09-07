import 'dart:async';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Services.dart';
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

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch user data when the widget is initialized
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

  Set<Marker> _createMarkers() {
    final markers = <Marker>{};

    if (usersData != null) {
      for (int index = 0; index < usersData!.users.length; index++) {
        final user = usersData!.users[index];
        final marker = Marker(
          markerId: MarkerId(user.id.toString()),
          position: const LatLng(16.245697, 103.250159),
          infoWindow: InfoWindow(title: user.name),
        );
        markers.add(marker);
      }
    }

    return markers;
  }

  void _goToUserLocation() async {
    if (usersData != null && usersData!.users.isNotEmpty) {
      final user = usersData!.users[0];
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(
        const LatLng(16.245697, 103.250159),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(16.245697, 103.250159),
            zoom: 15,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _createMarkers(),
        ),
        BottomDrawer(
          header: Container(
            child: const Center(
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(
                  //   width: 1,
                  // ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,

                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   width: 30.0,
                      //   height: 30.0,
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter, // ชิดขอบล่าง
                      //     child: FloatingActionButton(
                      //       onPressed: () {
                      //         _goToUserLocation();
                      //       },
                      //       child: const Icon(Icons.my_location),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
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
          ),

          body: ListView.builder(
              itemCount: usersData != null ? usersData!.users.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    // เมื่อคลิกที่ ListTile จะเปิดหน้า UserDetail โดยส่งข้อมูลผู้ใช้ไปด้วย
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => UserDetail(
                    //     user: usersData.users[index],
                    //   ),
                    // ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
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
              }),

          // body: SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       if (usersData != null)
          //         for (int index = 0; index < usersData!.users.length; index++)
          //           Card(
          //             color: const Color.fromARGB(255, 255, 255, 255),
          //             child: Padding(
          //               padding: const EdgeInsets.all(5.0),
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 crossAxisAlignment: CrossAxisAlignment.stretch,
          //                 children: <Widget>[
          //                   ListTile(
          //                     leading: CircleAvatar(
          //                       backgroundImage:
          //                           NetworkImage(usersData!.users[index].img),
          //                     ),
          //                     title: Text(
          //                       usersData!.users[index].name,
          //                       style: const TextStyle(
          //                           color: Color.fromARGB(255, 0, 0, 0),
          //                           fontSize: 16.0),
          //                     ),
          //                     subtitle: Text(
          //                       "Email: ${usersData!.users[index].email}",
          //                       style: const TextStyle(
          //                           color: Color.fromARGB(255, 0, 0, 0),
          //                           fontSize: 14.0),
          //                     ),
          //                     // trailing: const Icon(Icons.arrow_forward_ios),
          //                     onTap: () {
          //                       // Navigator.of(context).push(MaterialPageRoute(
          //                       //   builder: (context) => UserDetail(
          //                       //     user: usersData!.users[index],
          //                       //   ),
          //                       // ));
          //                     },
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //     ],
          //   ),
          // ),
          headerHeight: 200.0,
          drawerHeight: 450.0,
          color: const Color.fromARGB(255, 255, 255, 255),
          controller: controller,
        ),
      ],
    );
  }
}
