import 'package:flutter/material.dart';
import 'home_screen.dart'; // شاشة الرئيسية (Home)
import 'wallets_screen.dart'; // شاشة المحافظ والحسابات (Wallets)
import 'budget_screen.dart'; // تم إضافة الاستيراد المفقود هنا (Budgets)

// --- Custom Colors (الألوان المخصصة) ---
const Color primaryDeepGreen = Color(0xFF16610E); // اللون الأخضر الداكن الأساسي
const Color lightGreenBackground = Color(0xFFF0F4C3); // خلفية صفراء فاتحة / بيج

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 1. تحديد الفهرس الحالي للشاشة (الرئيسية = 0)
  int _selectedIndex = 0;

  // 2. قائمة الشاشات الفعلية
  final List<Widget> _screens = const [
    HomeScreen(),
    WalletsScreen(),
    BudgetScreen(),
    // TODO: يمكن إضافة شاشات وهمية مؤقتة هنا لشاشتي Health و More حتى يتم تطويرهما
    HomeScreen(), // مؤقتة لشاشة Health
    HomeScreen(), // مؤقتة لشاشة More
  ];

  // دالة تُستدعى عند النقر على أيقونة في شريط التنقل
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // عرض الشاشة المختارة حالياً
      body: _screens[_selectedIndex],

      // شريط التنقل السفلي (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // يجعل جميع العناصر مرئية
        backgroundColor: Colors.white,
        selectedItemColor:
            primaryDeepGreen, // لون الأيقونة المختارة (الأخضر الداكن)
        unselectedItemColor: Colors.grey.shade600, // لون الأيقونات غير المختارة
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

        currentIndex: _selectedIndex, // الفهرس الحالي
        onTap: _onItemTapped, // معالج النقر
        // عناصر شريط التنقل (5 عناصر كما في التصميم)
        items: const <BottomNavigationBarItem>[
          // 1. Home (الرئيسية)
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          // 2. Wallets (المحافظ)
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallets',
          ),
          // 3. Budgets (الميزانيات)
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Budgets',
          ),
          // 4. Health (الصحة المالية)
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Health',
          ),
          // 5. More (المزيد)
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}
