import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    // เรียกใช้งาน getUsers() และเก็บผลลัพธ์ใน usersData
    Services.getUsers().then((data) {
      setState(() {
        usersData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomDrawer(
      header: Container(
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.horizontal_rule,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              if (usersData != null)
                for (int index = 0; index < usersData!.users.length; index++)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(usersData!.users[index].img),
                            ),
                            title: Text(
                              usersData!.users[index].name,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16.0),
                            ),
                            subtitle: Text(
                              "Email: ${usersData!.users[index].email}",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 14.0),
                            ),
                            // trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => UserDetail(
                              //     user: usersData!.users[index],
                              //   ),
                              // ));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
      headerHeight: 200.0,
      drawerHeight: 450.0,
      color: const Color.fromARGB(255, 209, 209, 209),
      controller: controller,
    );
  }
}
