import 'package:flutter/material.dart';


const Color darkNavy = Color(0xFF0A0E21); // الخلفية الرئيسية القاتمة
const Color darkerNavy = Color(0xFF070B18); // درجة أغمق قليلاً للأجزاء الداخلية
const Color deepBlue = Color(0xFF10182B); // لحقول النص
const Color darkGreen = Color(0xFF2E7D32); // الأخضر الغامق للأزرار
const Color textLight = Color(0xFFB0BEC5); // رمادي فاتح للنصوص

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkNavy,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: darkGreen,
      ),
      body: const Center(
        child: Text(
          'Welcome to the Home Page!',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}