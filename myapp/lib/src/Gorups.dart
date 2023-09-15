import 'package:flutter/material.dart';
import 'package:myapp/models/groups.dart';

import '../API/api_service.dart';
// Import the Users model
// Import the Services class

class Group extends StatefulWidget {
  const Group({Key? key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<Group> {
  late Groups groupsuser = Groups(groups: []);

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch user data when the widget is initialized
  }

  Future<void> fetchData() async {
    try {
      final data = await APIService.getGroups();
      setState(() {
        groupsuser = data;
      });
    } catch (e) {
      // Handle any errors that may occur during the HTTP request
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend"),
        backgroundColor: const Color(0xFFF29727),
      ),
      body: ListView.builder(
          itemCount: groupsuser != null ? groupsuser.groups.length : 0,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTileTheme(
                  contentPadding: EdgeInsets.zero,
                  child: ListTile(
                    // leading: CircleAvatar(
                    //   radius: 30.0, // ปรับขนาดรูปภาพตามที่คุณต้องการ
                    //   backgroundImage: NetworkImage(groupsuser.groups[index]),
                    // ),
                    title: Text(
                      groupsuser.groups[index].name,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18.0,
                      ),
                    ),
                    // subtitle: Text(
                    //   "Email: ${groupsuser.groups[index].email}",
                    //   style: const TextStyle(
                    //     color: Color.fromARGB(255, 0, 0, 0),
                    //     fontSize: 14.0,
                    //   ),
                    // ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
