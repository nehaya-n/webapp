import 'package:flutter/material.dart';
import 'dart:async'; // نحتاج هذه الحزمة لـ Timer لتشغيل الحركة التلقائية

// --- Custom Colors (Defined here for self-containment) ---
const Color primaryBrown = Color(0xFF16610E); // Deep Green
const Color lightBeige = Colors.white;
const Color errorRed = Color(0xFFDB4437); 
const Color darkBeige = Color(0xFFD7CCC8); // لون فاتح ثانوي

// ================================================================
// 1. HomeScreen Class (الصفحة الرئيسية) - تم تحويلها إلى StatefulWidget
// ================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // =========================================================
  // === تم التعديل: العودة لاستخدام الصور المحلية (Assets) ===
  // تأكدي أن هذه الملفات موجودة في مسار assets/ في جذر المشروع
  // =========================================================
  final List<String> imgList = const [
    'assets/money_save.png', // الصورة 1: نمو وتوفير
    'assets/budget_planning.png', // الصورة 2: تخطيط وميزانية
    'assets/report_chart.png', // الصورة 3: تقارير وتحليل
  ];

  // حالة جديدة لإخفاء/إظهار الرصيد
  bool _isBalanceVisible = true; 

  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // لترك جزء صغير من الصورة التالية مرئياً
    _pageController = PageController(viewportFraction: 0.9);
    
    // إعداد مؤقت (Timer) للتنقل التلقائي كل 3 ثواني
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (imgList.isNotEmpty) {
        // حساب الصفحة التالية، والعودة للصفر إذا وصلنا للنهاية
        if (_currentPage < imgList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0; 
        }
        
        // الانتقال إلى الصفحة الجديدة مع تأثير حركي ناعم
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // مهم جداً لإلغاء المؤقت ومنع تسرب الذاكرة
    super.dispose();
  }
  
  // ========================================
  // دالة بناء شريط الشرائح المتحركة (Carousel) باستخدام PageView
  // ========================================
  Widget _buildImageCarousel(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: imgList.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final String item = imgList[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBrown.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  // === تم التعديل: استخدام Image.asset للصور المحلية ===
                  child: Image.asset(
                    item, 
                    fit: BoxFit.cover, 
                    width: double.infinity,
                    // يمكن إضافة مؤشر تحميل وهمي هنا إذا كانت عملية جلب الصورة تستغرق وقتاً
                    // ولكن لصور الـ assets، يكون التحميل عادةً فورياً.
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: errorRed.withOpacity(0.1),
                        child: const Center(
                          child: Text(
                            'Failed to load asset image. Check pubspec.yaml and file path.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: errorRed, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                  // ========================================================
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // مؤشرات النقاط (Dots Indicator)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: _currentPage == entry.key ? 25.0 : 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentPage == entry.key ? primaryBrown : primaryBrown.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // =======================================================
  // دالة بناء شريط الأرصدة (Balance Bar) مع خاصية الإخفاء/الإظهار التفاعلية
  // =======================================================
  Widget _buildBalanceBar() {
    // تم جلب البيانات من المكون السابق
    const double totalAmount = 5200.50;
    const double remainingAmount = 1550.00;
    final double percentage = (remainingAmount / totalAmount).clamp(0.0, 1.0);
    
    // القيمة المعروضة بناءً على حالة الإظهار
    final String displayedTotal = _isBalanceVisible 
        ? '\$${totalAmount.toStringAsFixed(2)}' 
        : '*****';
    
    final String displayedRemaining = _isBalanceVisible 
        ? '\$${remainingAmount.toStringAsFixed(2)}' 
        : '**';

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: primaryBrown,
        borderRadius: BorderRadius.circular(15.0),
        gradient: const LinearGradient(
          colors: [primaryBrown, Color(0xFF388E3C)], // لون أخضر داكن متدرج
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBrown.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // الرصيد الكلي
              Text(
                displayedTotal,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: lightBeige,
                ),
              ),
              
              // زر الإخفاء/الإظهار
              IconButton(
                icon: Icon(
                  _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  color: lightBeige,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // القسم السفلي (الرصيد المتبقي وشريط التقدم)
          if (_isBalanceVisible) 
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Remaining:',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    Text(
                      displayedRemaining,
                      style: const TextStyle(fontSize: 18, color: lightBeige, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // شريط التقدم 
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percentage, 
                    backgroundColor: Colors.white38,
                    valueColor: const AlwaysStoppedAnimation<Color>(lightBeige),
                    minHeight: 10,
                  ),
                ),
              ],
            ) 
          else 
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: const Text(
                'Balance Hidden',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // خلفية فاتحة جداً
      appBar: AppBar(
        // === تم التعديل: العنوان هو "Outaly" ===
        title: const Text('Outaly', style: TextStyle(fontWeight: FontWeight.bold)),
        // ========================================
        backgroundColor: lightBeige,
        foregroundColor: primaryBrown,
        elevation: 1, // ظل خفيف
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // توجيه لصفحة الإشعارات
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. الصور المتحركة (تم التنفيذ الآن)
            _buildImageCarousel(context),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. شريط الأرصدة (Balance Bar)
                  const Text(
                    'My Total Balance',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w500, 
                      color: Colors.grey
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // استدعاء الدالة الجديدة التي تدعم الإخفاء/الإظهار
                  _buildBalanceBar(), 

                  const SizedBox(height: 30),

                  // 3. قسم التقارير (Report Section)
                  const Text(
                    'Report',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryBrown,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // الرسم البياني اليومي (Placeholder)
                  const _DailyChartPlaceholder(),
                  
                  const SizedBox(height: 20),
                  
                  // تقارير إضافية أو قائمة معاملات
                  const _DailyReportSummary(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

} // نهاية _HomeScreenState

// ================================================================
// 2. العناصر المساعدة لـ HomeScreen 
// ================================================================

// 2.2. مكان وهمي للرسم البياني
class _DailyChartPlaceholder extends StatelessWidget {
  const _DailyChartPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: lightBeige,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: primaryBrown.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "Daily Spending Chart (Place your Chart Library here)",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}

// 2.3. ملخص التقارير اليومية (بطاقة صغيرة)
class _DailyReportSummary extends StatelessWidget {
  const _DailyReportSummary();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryItem(
              icon: Icons.arrow_circle_up,
              color: Colors.green,
              title: 'Income Today',
              amount: 500.00,
            ),
            _SummaryItem(
              icon: Icons.arrow_circle_down,
              color: errorRed,
              title: 'Expenses Today',
              amount: 120.50,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final double amount;

  const _SummaryItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
