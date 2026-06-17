import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác Thực Tài Khoản'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'Màn hình Đăng nhập / Đăng ký (Sẽ code ở bước tiếp theo)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}