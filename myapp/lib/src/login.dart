import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/Navbar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('Forgot your password?'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    // ใช้ try-catch เพื่อจัดการข้อผิดพลาด
                    try {
                      final response = await http.post(
                        Uri.parse(
                            'https://plain-ruby-piranha.cyclic.app/login'),
                        body: {"username": "Max", "password": "1234"},
                      );

                      if (response.statusCode == 200) {
                        // ทำตามขั้นตอนที่คุณต้องการหลังจากเรียก API สำเร็จ
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavbarPage(),
                          ),
                        );
                      } else {
                        // กรณีเกิดข้อผิดพลาดในการเรียก API
                        // ให้ทำการแสดงข้อความหรือจัดการข้อผิดพลาดตามที่คุณต้องการ
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login failed. Please try again.'),
                          ),
                        );
                      }
                    } catch (error) {
                      // กรณีเกิดข้อผิดพลาดในการเชื่อมต่อ
                      // ให้ทำการแสดงข้อความหรือจัดการข้อผิดพลาดตามที่คุณต้องการ
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'An error occurred. Please try again later.'),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    fixedSize:
                        MaterialStateProperty.all<Size>(const Size(600, 40)),
                  ),
                  child: const Text('Login')),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // ใส่โค้ดสำหรับการทำงานเมื่อกดปุ่ม Login with Facebook ที่นี่
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF1877F2)), // สีของ Facebook
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.facebook, color: Colors.white), // ไอคอน Facebook
                    SizedBox(width: 10),
                    Text(
                      'Login with Facebook',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Don't have an account yet? Subscribe"),
            ],
          ),
        ),
      ),
    );
  }
}
