import 'package:flutter/material.dart';

import '../models/users.dart'; // Import the Users model
import '../services.dart'; // Import the Services class

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  Users usersData = Users();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend"),
        backgroundColor: const Color(0xFFF29727),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (usersData != null)
              for (int index = 0; index < usersData.users.length; index++)
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
                                NetworkImage(usersData.users[index].img),
                          ),
                          title: Text(
                            usersData.users[index].name,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16.0),
                          ),
                          subtitle: Text(
                            "Email: ${usersData.users[index].email}",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 14.0),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
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
    );
  }
}
