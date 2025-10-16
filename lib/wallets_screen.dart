import 'package:flutter/material.dart';
import 'dart:math';

// استيراد الشاشات المنفصلة
import 'login_screen.dart';

// ================================================================
// 1. Custom Colors and Constants (الألوان والثوابت)
// ================================================================

// الألوان المخصصة
const Color primaryBrown = Color(0xFF16610E); // Deep Green (Dark Moss Green)
const Color vibrantGreen = Color(
  0xFF4CAF50,
); // Vibrant Green (like a success color)
const Color lightGreenBackground = Color(
  0xFFF1F7E8,
); // Very light yellow-green background
const Color lightBeige = Colors.white;
const Color errorRed = Color(0xFFDB4437);
const Color successGreen = Color(0xFF2E7D32); // Darker green for completeness
const Color vibrantGreenAccent = Color(0xFFA5D6A7); // Lightest accent green

// ================================================================
// 2. Data Models (نماذج البيانات)
// ================================================================

// ------------------- Transaction Model -------------------
class Transaction {
  final String description;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.description,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}

// ------------------- Goal Model -------------------
class Goal {
  final String id;
  final String name;
  double savedAmount;
  final double targetAmount;
  final IconData icon;
  final Color color;

  Goal({
    required this.id,
    required this.name,
    required this.savedAmount,
    required this.targetAmount,
    required this.icon,
    required this.color,
  });

  bool get isComplete => savedAmount >= targetAmount;

  double get progressPercentage => min(1.0, savedAmount / targetAmount);
  double get remainingAmount => max(0.0, targetAmount - savedAmount);

  void addAmount(double amount) {
    savedAmount += amount;
  }
}

// ------------------- Wallet Model -------------------
class Wallet {
  final String id;
  final String name;
  double balance;
  final IconData icon;
  final Color color;
  final bool isGoalManager;
  final List<Transaction> transactions; // سجل المعاملات

  Wallet({
    required this.id,
    required this.name,
    required this.balance,
    required this.icon,
    required this.color,
    this.isGoalManager = false,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? []; // تهيئة سجل المعاملات

  void updateBalance(double amount) {
    balance += amount;
  }
}

// ================================================================
// 3. MAIN APPLICATION (MyApp)
// ================================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryBrown,
        scaffoldBackgroundColor: lightGreenBackground,
        appBarTheme: const AppBarTheme(backgroundColor: primaryBrown, elevation: 0),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Roboto', color: Colors.black87),
          bodyMedium: TextStyle(fontFamily: 'Roboto', color: Colors.black87),
          titleLarge: TextStyle(fontFamily: 'Roboto', color: primaryBrown),
        ),
        useMaterial3: true,
      ),
      // تبدأ بشاشة الدخول أولاً
      home: const LoginScreen(),
      // home: const MainScreen(),
    );
  }
}

// ================================================================
// 4. Wallets Screen (شاشة المحافظ)
// ================================================================

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key});

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  // بيانات المحافظ (Mock Data) - تم إضافة ID لكل محفظة
  final List<Wallet> _wallets = [
    Wallet(
      id: 'w1',
      name: 'Bank Account',
      balance: 3250.00,
      icon: Icons.account_balance,
      color: primaryBrown,
      transactions: [
        Transaction(
          description: 'Initial Deposit',
          amount: 3000.00,
          date: DateTime(2023, 10, 1),
          isIncome: true,
        ),
        Transaction(
          description: 'Salary',
          amount: 2000.00,
          date: DateTime(2023, 10, 5),
          isIncome: true,
        ),
        Transaction(
          description: 'Online Shopping',
          amount: 1750.00,
          date: DateTime(2023, 10, 10),
          isIncome: false,
        ),
      ],
    ),
    Wallet(
      id: 'w2',
      name: 'Cash',
      balance: 150.50,
      icon: Icons.credit_card_outlined,
      color: primaryBrown,
      transactions: [
        Transaction(
          description: 'ATM Withdrawal',
          amount: 200.00,
          date: DateTime(2023, 10, 12),
          isIncome: true,
        ),
        Transaction(
          description: 'Coffee',
          amount: 49.50,
          date: DateTime(2023, 10, 13),
          isIncome: false,
        ),
      ],
    ),
    Wallet(
      id: 'w3',
      name: 'Goals Manager',
      balance: 0.00, // الرصيد المبدئي للأهداف هو صفر
      icon: Icons.star_border,
      color: vibrantGreenAccent,
      isGoalManager: true,
    ),
  ];

  // بيانات الأهداف (فارغة في البداية)
  final List<Goal> _goals = [];

  // ==================================================
  // حساب الرصيد الإجمالي (فقط للحسابات غير الأهداف)
  // ==================================================
  double get _totalWalletBalance {
    return _wallets
        .where((w) => !w.isGoalManager) // استثناء Goals Manager
        .map((w) => w.balance)
        .fold(0.0, (a, b) => a + b); // استخدام fold للحساب
  }
  // ==================================================

  // دالة تُستدعى لتحديث بيانات المحفظة (بعد الإيداع/الصرف في شاشة التفاصيل)
  void _updateWalletBalance() {
    setState(() {
      // هذه الدالة لا تفعل شيئاً حالياً سوى إعادة بناء الواجهة
      // ويمكن استخدامها في المستقبل لتحديث البيانات من قاعدة بيانات حقيقية
    });
  }

  // دالة تُستدعى لتحديث رصيد "Goals Manager" (في حال تم إضافة هدف)
  void _updateGoalManagerBalance() {
    // يمكن هنا حساب مجموع المدخرات في الأهداف وتحديث رصيد Goals Manager
    final totalGoalsSavedAmount = _goals
        .map((g) => g.savedAmount)
        .fold(0.0, (a, b) => a + b);

    setState(() {
      final goalsManager = _wallets.firstWhere((w) => w.isGoalManager);
      goalsManager.balance = totalGoalsSavedAmount;
    });
  }

  // --- Handlers ---
  void _handleWalletTap(Wallet wallet) {
    if (wallet.isGoalManager) {
      // توجيه إلى شاشة الأهداف
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoalsManagerScreen(
            goals: _goals,
            onGoalsUpdated: _updateGoalManagerBalance,
          ),
        ),
      );
    } else {
      // توجيه إلى شاشة تفاصيل المحفظة (Bank/Cash)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WalletDetailScreen(
            wallet: wallet,
            onUpdate:
                _updateWalletBalance, // تمرير الدالة لتحديث الواجهة الرئيسية
          ),
        ),
      );
    }
  }

  void _handleFloatingActionButtonTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feature: Add New Account/Wallet')),
    );
  }

  // --- UI Builders ---
  Widget _buildEmptyWalletsView() {
    // ... (نفس الكود السابق)
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.wallet, size: 50, color: primaryBrown),
          SizedBox(height: 10),
          Text(
            'لا توجد محافظ بعد!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBrown,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'انقر على علامة (+) لإضافة أول حساب بنكي أو نقدي.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // المحافظ التي سيتم عرضها (الحسابات البنكية والنقدية فقط)
    final List<Wallet> displayWallets = _wallets
        .where((w) => !w.isGoalManager)
        .toList();

    // استخراج بطاقة الأهداف لضمان وجودها في قائمة _wallets فقط
    final Wallet goalsManagerWallet = _wallets.firstWhere(
      (w) => w.isGoalManager,
      orElse: () => Wallet(
        id: 'w_dummy',
        name: 'Goals Manager',
        balance: 0.00,
        icon: Icons.star_border,
        color: vibrantGreenAccent,
        isGoalManager: true,
      ),
    );

    return Scaffold(
      backgroundColor: lightGreenBackground,
      appBar: AppBar(
        title: const Text(
          'Wallets',
          style: TextStyle(color: primaryBrown, fontWeight: FontWeight.bold),
        ),
        backgroundColor: lightGreenBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _handleFloatingActionButtonTap,
        backgroundColor: primaryBrown,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الرصيد الإجمالي (التي تحتوي فقط على رصيد البنك والكاش)
            _TotalBalanceCard(totalBalance: _totalWalletBalance),
            const SizedBox(height: 25),

            // عنوان المحافظ
            const Text(
              'My Accounts',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryBrown,
              ),
            ),
            const SizedBox(height: 15),

            // قائمة المحافظ (الحسابات البنكية والنقدية فقط)
            if (displayWallets.isEmpty)
              _buildEmptyWalletsView()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayWallets.length,
                itemBuilder: (context, index) {
                  final wallet = displayWallets[index];
                  return _WalletItem(
                    wallet: wallet,
                    onWalletTap: _handleWalletTap,
                  );
                },
              ),

            const SizedBox(height: 25),

            // عنوان الأهداف (Goals Manager) - يبقى كمنفذ للدخول إلى شاشة الأهداف
            const Text(
              'My Financial Goals',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryBrown,
              ),
            ),
            const SizedBox(height: 15),

            // بطاقة Goals Manager (ليست ضمن المجموع، ولكن كمنفذ)
            _WalletItem(
              wallet: goalsManagerWallet,
              onWalletTap: _handleWalletTap,
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- UI Components for WalletsScreen -------------------

// بطاقة الرصيد الإجمالي
class _TotalBalanceCard extends StatelessWidget {
  final double totalBalance;
  const _TotalBalanceCard({required this.totalBalance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: primaryBrown,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: primaryBrown.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Net Worth (Cash + Bank)',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                '\$${totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(blurRadius: 2, color: Colors.black12)],
                ),
              ),
            ],
          ),
          const Icon(
            Icons.account_balance_wallet,
            color: Colors.white70,
            size: 28,
          ),
        ],
      ),
    );
  }
}

// عنصر المحفظة أو المدير
class _WalletItem extends StatelessWidget {
  final Wallet wallet;
  final Function(Wallet) onWalletTap;

  const _WalletItem({required this.wallet, required this.onWalletTap});

  @override
  Widget build(BuildContext context) {
    // لون خلفية بطاقة الأهداف
    final itemColor = wallet.isGoalManager ? vibrantGreenAccent : primaryBrown;

    return InkWell(
      onTap: () => onWalletTap(wallet),
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: itemColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: itemColor.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(wallet.icon, color: Colors.white, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                wallet.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  wallet.isGoalManager
                      ? 'Manage Goals'
                      : '\$${wallet.balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: wallet.isGoalManager ? primaryBrown : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (wallet.isGoalManager)
                  Text(
                    'Total Saved: \$${wallet.balance.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
              ],
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.arrow_forward_ios,
              color: wallet.isGoalManager ? primaryBrown : Colors.white70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// 5. Wallet Detail Screen (شاشة تفاصيل المحفظة - الجديدة)
// ================================================================

class WalletDetailScreen extends StatefulWidget {
  final Wallet wallet;
  final VoidCallback onUpdate; // دالة للتحديث في شاشة المحافظ الرئيسية

  const WalletDetailScreen({
    super.key,
    required this.wallet,
    required this.onUpdate,
  });

  @override
  State<WalletDetailScreen> createState() => _WalletDetailScreenState();
}

class _WalletDetailScreenState extends State<WalletDetailScreen> {
  // لحساب إجمالي الإيرادات والمصروفات
  double get totalIncome {
    return widget.wallet.transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return widget.wallet.transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // لفتح مربع الحوار لإضافة معاملة
  void _showTransactionDialog(BuildContext context, bool isIncome) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isIncome ? 'Add Income' : 'Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: isIncome
                      ? 'Source (e.g., Salary, Gift)'
                      : 'Description (e.g., Rent, Groceries)',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount (\$)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: errorRed)),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                final description = descriptionController.text.trim();

                if (amount != null && amount > 0 && description.isNotEmpty) {
                  _addTransaction(amount, description, isIncome);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter valid amount and description.',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isIncome ? successGreen : errorRed,
              ),
              child: Text(
                isIncome ? 'Add Income' : 'Add Expense',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // لإضافة معاملة وتحديث الرصيد
  void _addTransaction(double amount, String description, bool isIncome) {
    setState(() {
      final newTransaction = Transaction(
        description: description,
        amount: amount,
        date: DateTime.now(),
        isIncome: isIncome,
      );

      widget.wallet.transactions.insert(
        0,
        newTransaction,
      ); // إضافة المعاملة للأعلى

      // تحديث الرصيد
      if (isIncome) {
        widget.wallet.updateBalance(amount);
      } else {
        widget.wallet.updateBalance(-amount); // الصرف قيمة سالبة
      }

      // إخطار الشاشة الرئيسية بالتحديث
      widget.onUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreenBackground,
      appBar: AppBar(
        title: Text(
          widget.wallet.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryBrown,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الرصيد الحالي
            _CurrentBalanceCard(wallet: widget.wallet),
            const SizedBox(height: 20),

            // بطاقات الإيراد والمصروف
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TransactionSummaryCard(
                  title: 'Total Income',
                  amount: totalIncome,
                  color: successGreen,
                  icon: Icons.arrow_downward,
                ),
                _TransactionSummaryCard(
                  title: 'Total Expense',
                  amount: totalExpense,
                  color: errorRed,
                  icon: Icons.arrow_upward,
                ),
              ],
            ),
            const SizedBox(height: 30),

            // أزرار المعاملات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TransactionButton(
                  label: 'Add Income',
                  color: successGreen,
                  icon: Icons.add,
                  onPressed: () => _showTransactionDialog(context, true),
                ),
                _TransactionButton(
                  label: 'Add Expense',
                  color: errorRed,
                  icon: Icons.remove,
                  onPressed: () => _showTransactionDialog(context, false),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // سجل المعاملات
            const Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryBrown,
              ),
            ),
            const SizedBox(height: 15),

            if (widget.wallet.transactions.isEmpty)
              const Center(child: Text("No transactions recorded yet."))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.wallet.transactions.length,
                itemBuilder: (context, index) {
                  final t = widget.wallet.transactions[index];
                  return _TransactionItem(t: t);
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ------------------- WalletDetailScreen Components -------------------

// بطاقة الرصيد الحالي
class _CurrentBalanceCard extends StatelessWidget {
  final Wallet wallet;
  const _CurrentBalanceCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryBrown,
        borderRadius: BorderRadius.circular(20.0),
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
          Text(
            'Current Balance in ${wallet.name}',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            '\$${wallet.balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// بطاقة ملخص الإيراد والمصروف
class _TransactionSummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _TransactionSummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// زر إضافة / صرف
class _TransactionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _TransactionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}

// عنصر المعاملة في السجل
class _TransactionItem extends StatelessWidget {
  final Transaction t;

  const _TransactionItem({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            t.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: t.isIncome ? successGreen : errorRed,
            size: 24,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryBrown,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${t.date.day}/${t.date.month}/${t.date.year}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${t.isIncome ? '+' : '-'}\$${t.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: t.isIncome ? successGreen : errorRed,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// 6. Goals Manager Screen (شاشة إدارة الأهداف)
// ================================================================

// ... (GoalManagerScreen و CreateGoalScreen تبقى كما هي مع تحديث بسيط في المظهر)
class GoalsManagerScreen extends StatefulWidget {
  final List<Goal> goals;
  final VoidCallback onGoalsUpdated;

  const GoalsManagerScreen({
    super.key,
    required this.goals,
    required this.onGoalsUpdated,
  });

  @override
  State<GoalsManagerScreen> createState() => _GoalsManagerScreenState();
}

class _GoalsManagerScreenState extends State<GoalsManagerScreen> {
  // دالة إضافة هدف جديد
  void _addNewGoal(Goal newGoal) {
    setState(() {
      widget.goals.add(newGoal);
      widget.onGoalsUpdated(); // لتحديث المحفظة الرئيسية
    });
  }

  // دالة إضافة مبلغ إلى هدف موجود
  void _addAmountToGoal(Goal goal, double amount) {
    setState(() {
      goal.addAmount(amount);
      widget.onGoalsUpdated(); // لتحديث المحفظة الرئيسية
    });
  }

  // دالة لإنشاء هدف جديد
  void _createNewGoal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateGoalScreen(onNewGoalCreated: _addNewGoal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreenBackground,
      appBar: AppBar(
        backgroundColor: primaryBrown, // لون شريط الأهداف
        title: const Text(
          'Financial Goals',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // زر عائم لإنشاء هدف جديد
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewGoal,
        backgroundColor: primaryBrown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        label: const Text(
          'Create New Goal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),

      body: widget.goals.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border, size: 60, color: primaryBrown),
                    SizedBox(height: 15),
                    Text(
                      "You haven't set any goals yet!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryBrown,
                      ),
                    ),
                    Text(
                      "Click 'Create New Goal' to start saving for your dreams.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: widget.goals.map((goal) {
                  return _GoalManagerItem(
                    goal: goal,
                    onAddAmount: _addAmountToGoal,
                  );
                }).toList(),
              ),
            ),
    );
  }
}

// عنصر الهدف الواحد
class _GoalManagerItem extends StatelessWidget {
  final Goal goal;
  final Function(Goal, double) onAddAmount;

  const _GoalManagerItem({required this.goal, required this.onAddAmount});

  @override
  Widget build(BuildContext context) {
    // ... (كود الهدف)
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: goal.color,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: goal.color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(goal.icon, color: Colors.white, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    goal.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (goal.isComplete)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: successGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'ACHIEVED!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  'Remaining: \$${goal.remainingAmount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
            ],
          ),
          const SizedBox(height: 15),

          // شريط التقدم
          LinearProgressIndicator(
            value: goal.progressPercentage,
            backgroundColor: Colors.white.withOpacity(0.5),
            color: Colors.white,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved: \$${goal.savedAmount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                'Target: \$${goal.targetAmount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),

          if (!goal.isComplete)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showAddAmountDialog(context, goal),
                  icon: const Icon(Icons.attach_money, color: Colors.white),
                  label: const Text(
                    'Add Funds',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // دالة لعرض مربع حوار لإضافة المبلغ
  void _showAddAmountDialog(BuildContext context, Goal goal) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add funds to ${goal.name}'),
          content: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount to add (\$)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: errorRed)),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  onAddAmount(goal, amount);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid amount.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryBrown),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

// ================================================================
// 7. Create Goal Screen (شاشة إنشاء هدف جديد)
// ================================================================

class CreateGoalScreen extends StatefulWidget {
  final Function(Goal) onNewGoalCreated;

  const CreateGoalScreen({super.key, required this.onNewGoalCreated});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  // ... (نفس الكود السابق)
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _savedController = TextEditingController();

  IconData _selectedIcon = Icons.star;
  Color _selectedColor = Colors.blue;

  final List<IconData> _availableIcons = [
    Icons.directions_car_filled,
    Icons.flight_takeoff,
    Icons.trending_up,
    Icons.home,
    Icons.school,
    Icons.shopping_bag,
    Icons.favorite,
  ];

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.orange,
    Colors.teal,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.indigo,
  ];

  void _submitGoal() {
    if (_formKey.currentState!.validate()) {
      final newGoal = Goal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        targetAmount: double.parse(_targetController.text),
        savedAmount: double.parse(_savedController.text),
        icon: _selectedIcon,
        color: _selectedColor,
      );

      widget.onNewGoalCreated(newGoal);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (نفس واجهة إنشاء هدف)
    return Scaffold(
      backgroundColor: lightGreenBackground,
      appBar: AppBar(
        backgroundColor: primaryBrown,
        title: const Text(
          'Create New Goal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اسم الهدف
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Goal Name (e.g., New Car, House Down Payment)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // المبلغ المستهدف
              TextFormField(
                controller: _targetController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Target Amount (\$)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid target amount.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // المبلغ المدخر حالياً
              TextFormField(
                controller: _savedController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Currently Saved Amount (\$)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.parse(value) < 0) {
                    return 'Please enter a valid saved amount (can be 0).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // اختيار الأيقونة
              const Text(
                'Select Icon:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryBrown,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _availableIcons
                    .map(
                      (icon) => GestureDetector(
                        onTap: () => setState(() => _selectedIcon = icon),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _selectedIcon == icon
                                ? primaryBrown
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: primaryBrown.withOpacity(0.5),
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: _selectedIcon == icon
                                ? Colors.white
                                : primaryBrown,
                            size: 28,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // اختيار اللون
              const Text(
                'Select Color:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryBrown,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _availableColors
                    .map(
                      (color) => GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 40),

              // زر إنشاء الهدف
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _submitGoal,
                  icon: const Icon(Icons.add_task, color: Colors.white),
                  label: const Text(
                    'Create Goal',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBrown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
