import 'package:flutter/material.dart';

// ================= Custom Colors =================
const Color primaryGreen = Color(0xFF16610E);
const Color lightBackground = Colors.white;
const Color darkGrey = Color(0xFF333333);
const Color accentColor = Color(0xFF388E3C); // لون أخضر داكن إضافي للتمييز

// Map color strings (used by AI logic) to Color objects
final Map<String, Color> colorMapping = {
  'green': Colors.green.shade600,
  'blue': Colors.blue.shade600,
  'orange': Colors.orange.shade600,
  'purple': Colors.purple.shade600,
  'red': Colors.red.shade600,
  'teal': Colors.teal.shade600,
};

// ================= Data Model =================
class Budget {
  final String name;
  final double amount;
  final IconData icon;
  final Color color;

  Budget({
    required this.name,
    required this.amount,
    required this.icon,
    required this.color,
  });
}

// ================= BudgetScreen =================
class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final List<Budget> _budgets = [];

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // State
  IconData _selectedIcon = Icons.category_outlined;
  Color _selectedColor = colorMapping['green']!;
  bool _useAI = false;
  bool _isLoading = false; // New state to manage loading/AI processing

  // Available icons (Used for both manual picker and AI mapping)
  final Map<String, IconData> _iconOptions = {
    'Food': Icons.fastfood_outlined,
    'Transport': Icons.directions_car_outlined,
    'Shopping': Icons.shopping_bag_outlined,
    'Bills': Icons.receipt_long_outlined,
    'Entertainment': Icons.movie_outlined,
    'Online Shopping': Icons.shopping_cart_outlined,
    'Health': Icons.health_and_safety_outlined,
    'Travel': Icons.flight_takeoff_outlined,
    'Savings': Icons.savings_outlined,
    'Education': Icons.school_outlined,
  };

  // Available colors (Used for manual picker)
  final List<Color> _colorOptions = colorMapping.values.toList();

  // Helper to retrieve color by name string (for AI parsing)
  Color _getColor(String colorKey) =>
      colorMapping[colorKey.toLowerCase()] ?? Colors.grey.shade600;

  // Helper to retrieve icon by name string (for AI parsing)
  IconData _getIcon(String iconKey) =>
      _iconOptions[iconKey] ?? Icons.category_outlined;

  // --- AI Simulation Function ---
  // In a real application, this function would perform the actual Gemini API call
  // using the expenseName as the prompt to get a structured JSON response.
  Future<Budget> _fetchAISuggestion(String expenseName) async {
    // 1. Simulate API delay for better UX
    await Future.delayed(const Duration(seconds: 2));

    // 2. Mock API response based on input name for demonstration
    // The Gemini model would return a JSON like this, with keys 'amount', 'iconKey', 'colorKey'.
    Map<String, dynamic> mockApiResponse;

    final lowerName = expenseName.toLowerCase();

    if (lowerName.contains('groceries') || lowerName.contains('food')) {
      mockApiResponse = {
        'amount': 500.0,
        'iconKey': 'Food',
        'colorKey': 'green',
      };
    } else if (lowerName.contains('travel') || lowerName.contains('vacation')) {
      mockApiResponse = {
        'amount': 1500.0,
        'iconKey': 'Travel',
        'colorKey': 'blue',
      };
    } else if (lowerName.contains('subscription') ||
        lowerName.contains('bill')) {
      mockApiResponse = {
        'amount': 300.0,
        'iconKey': 'Bills',
        'colorKey': 'red',
      };
    } else if (lowerName.contains('savings') || lowerName.contains('invest')) {
      mockApiResponse = {
        'amount': 1000.0,
        'iconKey': 'Savings',
        'colorKey': 'teal',
      };
    } else {
      // Default fallback
      mockApiResponse = {
        'amount': 400.0,
        'iconKey': 'Shopping',
        'colorKey': 'orange',
      };
    }

    // 3. Parse the response and map strings back to Flutter objects
    final suggestedAmount = mockApiResponse['amount'] as double;
    final suggestedIcon = _getIcon(mockApiResponse['iconKey'] as String);
    final suggestedColor = _getColor(mockApiResponse['colorKey'] as String);

    return Budget(
      name: expenseName,
      amount: suggestedAmount,
      icon: suggestedIcon,
      color: suggestedColor,
    );
  }

  void _addBudget() async {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text);

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an expense name.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Only check for amount validity if not using AI
    if (!_useAI && (amount == null || amount <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount when adding manually.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading state
    });

    try {
      Budget newBudget;

      if (_useAI) {
        // AI Flow: Fetch suggestion using only the expense name
        newBudget = await _fetchAISuggestion(name);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'AI suggested budget of ${newBudget.amount.toStringAsFixed(2)} SAR for ${newBudget.name}.',
            ),
            backgroundColor: primaryGreen,
          ),
        );
      } else {
        // Manual Flow: Use user-provided inputs
        newBudget = Budget(
          name: name,
          amount: amount!,
          icon: _selectedIcon,
          color: _selectedColor,
        );
      }

      // Add the determined budget to the list
      _budgets.add(newBudget);

      // Clear inputs
      _nameController.clear();
      _amountController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Failed to process budget suggestion.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Stop loading and refresh UI to show new budget
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleAI(bool? value) {
    setState(() {
      _useAI = value ?? false;
      // Clear amount controller when switching to AI mode
      if (_useAI) {
        _amountController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text('Budgets', style: TextStyle(color: lightBackground)),
        backgroundColor: primaryGreen,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ========== AI or Manual Toggle ==========
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: _useAI,
                  onChanged: _isLoading ? null : _toggleAI,
                  activeColor: primaryGreen,
                ),
                const Text('Use AI suggestion', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),

            // ========== Inputs ==========
            // Expense Name (Always editable unless loading)
            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Expense Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(_selectedIcon, color: _selectedColor),
              ),
            ),
            const SizedBox(height: 10),

            // Amount (Disabled if using AI or loading)
            TextField(
              controller: _amountController,
              enabled: !_isLoading && !_useAI,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _useAI
                    ? 'Amount (Determined by AI)'
                    : 'Amount (SAR)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: _useAI ? Colors.grey.shade100 : lightBackground,
                filled: _useAI,
                prefixIcon: const Icon(Icons.attach_money, color: darkGrey),
              ),
            ),
            const SizedBox(height: 10),

            // =======================================================
            // ========== Icon Picker (Improved Styling) ==========
            // =======================================================
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Choose Icon:',
                  style: TextStyle(
                    fontSize: 14,
                    color: darkGrey.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 75, // زيادة ارتفاع الحاوية
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _iconOptions.entries.map((entry) {
                  final isSelected = _selectedIcon == entry.value;
                  return GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _selectedIcon = entry.value;
                            });
                          },
                    child: AnimatedContainer(
                      // استخدام AnimatedContainer لإضافة تأثيرات بصرية
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryGreen.withOpacity(
                                0.15,
                              ) // لون خلفية خفيف للمختار
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // حواف مدورة أكثر
                        border: isSelected
                            ? Border.all(
                                color: accentColor,
                                width: 2,
                              ) // حدود واضحة عند الاختيار
                            : Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            entry.value,
                            size: 24, // زيادة حجم الأيقونة
                            color: isSelected ? accentColor : darkGrey,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? darkGrey
                                  : darkGrey.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // ========== Color Picker ==========
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Choose Color:',
                  style: TextStyle(
                    fontSize: 14,
                    color: darkGrey.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _colorOptions.map((color) {
                  return GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: _selectedColor == color
                            ? Border.all(
                                color: darkGrey,
                                width: 3,
                              ) // حدود أكثر سمكاً للون المختار
                            : null,
                        boxShadow: [
                          // إضافة ظل خفيف للوضوح
                          if (_selectedColor == color)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 15),

            // ========== Add Button (Shows spinner when loading) ==========
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _addBudget, // Disable when loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: lightBackground,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        _useAI
                            ? 'Get AI Budget Suggestion'
                            : 'Add Budget Manually',
                        style: const TextStyle(
                          color: lightBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // ========== Budgets List ==========
            Expanded(
              child: _budgets.isEmpty
                  ? const Center(
                      child: Text(
                        'No budgets added yet. Enter an expense name above!',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _budgets.length,
                      itemBuilder: (context, index) {
                        final budget = _budgets[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: budget.color.withOpacity(0.2),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Icon(
                              budget.icon,
                              color: budget.color,
                              size: 30,
                            ), // تكبير أيقونة القائمة
                            title: Text(
                              budget.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              '${budget.amount.toStringAsFixed(2)} SAR',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: darkGrey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
