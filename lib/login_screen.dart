import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';


// --- Custom Dark Theme Colors ---
const Color darkNavy = Color(0xFF0A0E21); // الخلفية الرئيسية القاتمة
const Color darkerNavy = Color(0xFF070B18); // درجة أغمق قليلاً للأجزاء الداخلية
const Color deepBlue = Color(0xFF10182B); // لحقول النص
const Color darkGreen = Color(0xFF2E7D32); // الأخضر الغامق للأزرار
const Color textLight = Color(0xFFB0BEC5); // رمادي فاتح للنصوص

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _selectedTabIndex = 0;
  String? _loginErrorMessage;

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerFullNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();
  final _registerPhoneNumberController = TextEditingController();

 Future<void> loginUser() async {
  try {
    final url = Uri.parse("http://192.168.0.24:3000/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _loginEmailController.text,
        "password": _loginPasswordController.text,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() => _loginErrorMessage = null);

      // عرض رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? "Login successful")),
      );

      // الانتقال للصفحة الرئيسية بعد نجاح تسجيل الدخول
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

    } else {
      setState(() {
        _loginErrorMessage = data['message'] ?? "Invalid email or password";
      });
    }
  } catch (e) {
    setState(() {
      _loginErrorMessage = "Connection error. Please check your server.";
    });
  }
}


  Future<void> registerUser() async {
    if (_registerPasswordController.text != _registerConfirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      final url = Uri.parse("http://192.168.0.24:3000/register");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "full_name": _registerFullNameController.text,
          "email": _registerEmailController.text,
          "password": _registerPasswordController.text,
          "phone_number": _registerPhoneNumberController.text,
        }),
      );

      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? "Registration complete")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error connecting to server")),
      );
    }
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerFullNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    _registerPhoneNumberController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: textLight),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey.shade400),
          filled: true,
          fillColor: deepBlue,
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: darkGreen, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          controller: _loginEmailController,
          hintText: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildInputField(
          controller: _loginPasswordController,
          hintText: 'Password',
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        if (_loginErrorMessage != null) ...[
          const SizedBox(height: 6),
          Text(_loginErrorMessage!, style: const TextStyle(color: Colors.red, fontSize: 14)),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: loginUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            ),
            child: const Text('LOG IN',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        _buildInputField(controller: _registerFullNameController, hintText: 'Full Name', icon: Icons.person_outline),
        _buildInputField(controller: _registerEmailController, hintText: 'Email', icon: Icons.email_outlined),
        _buildInputField(controller: _registerPasswordController, hintText: 'Password', icon: Icons.lock_outline, isPassword: true),
        _buildInputField(controller: _registerConfirmPasswordController, hintText: 'Confirm Password', icon: Icons.lock_open_outlined, isPassword: true),
        _buildInputField(controller: _registerPhoneNumberController, hintText: 'Phone Number', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: registerUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            ),
            child: const Text('SIGN UP',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget currentForm = _selectedTabIndex == 0 ? _buildLoginForm() : _buildRegisterForm();
    final String welcomeText = _selectedTabIndex == 0 ? 'Welcome Back' : 'Create Account';

    return Scaffold(
      backgroundColor: darkNavy,
      body: Row(
        children: [
          // LEFT SIDE (Login/Register)
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: darkerNavy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const CustomAppLogo(size: 80, color: darkGreen),
                      const SizedBox(height: 16),
                      Text(welcomeText,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TabButton(label: 'Login', isSelected: _selectedTabIndex == 0, onTap: () => setState(() => _selectedTabIndex = 0)),
                          const SizedBox(width: 8),
                          _TabButton(label: 'Sign Up', isSelected: _selectedTabIndex == 1, onTap: () => setState(() => _selectedTabIndex = 1)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      currentForm,
                      const SizedBox(height: 16),
                      const Text('Forgot Password?',
                          style: TextStyle(color: textLight, fontWeight: FontWeight.w600, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ),

         
          // RIGHT SIDE (For Image)
Expanded(
  flex: 1,
  child: Container(
    color: darkNavy,
    child: Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            Image.asset(
  'assets/images/rise.jpeg',
  fit: BoxFit.cover,
  alignment: Alignment.centerRight, // ← يركز على الطرف الأيمن من الصورة
  width: double.infinity,
  height: double.infinity,
),
            // Overlay gradient to blend edges
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.9,
                  colors: [
                    Colors.transparent,
                    darkNavy, // لون الخلفية
                  ],
                  stops: [0.8, 1.0],
                ),
              ),
            ),
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

// --- UI COMPONENTS ---
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? darkGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : textLight, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CustomAppLogo extends StatelessWidget {
  final double size;
  final Color color;
  const CustomAppLogo({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter(color: color)),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color color;
  _LogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2 * 0.9;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Paint bgPaint = Paint()..color = deepBlue;
    canvas.drawCircle(center, radius, bgPaint);

    final Paint arcPaint = Paint()..color = color;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 250 * pi / 180, true, arcPaint);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '\$',
        style: TextStyle(color: Colors.white, fontSize: size.width * 0.45, fontWeight: FontWeight.w900),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => false;
}
