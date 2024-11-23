// subscription_page.dart
import 'package:flutter/material.dart';
import 'package:quran/start%20login/registrasi.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedCurrency = 'IDR';
  double amount = 20000;
  String selectedTimeZone = 'WIB'; // Default timezone

  final Map<String, double> exchangeRates = {
    'IDR': 1.0,
    'USD': 0.000064,
    'EUR': 0.000059,
    'SGD': 0.000086,
    'MYR': 0.00030,
  };

  double getConvertedAmount() {
    return amount * exchangeRates[selectedCurrency]!;
  }

  String formatCurrency(double amount) {
    if (selectedCurrency == 'IDR') {
      return 'Rp ${amount.toStringAsFixed(0)}';
    } else {
      return '${amount.toStringAsFixed(2)} $selectedCurrency';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF121212),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/logo.png', height: 150),
                const SizedBox(height: 20),
                const Text(
                  "Subscribe to Continue",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DB954).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF1DB954),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Premium Subscription",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1DB954),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        formatCurrency(getConvertedAmount()),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<String>(
                        value: selectedCurrency,
                        dropdownColor: const Color(0xFF212121),
                        style: const TextStyle(color: Colors.white),
                        items: exchangeRates.keys.map((String currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCurrency = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BenefitItem(text: "Unlimited Access"),
                          BenefitItem(text: "Ad-free Experience"),
                          BenefitItem(text: "Premium Features"),
                          BenefitItem(text: "Priority Support"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showPaymentDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DB954),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Subscribe Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF212121),
          title: const Text(
            "Select Payment Method",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _paymentOption(
                context,
                "Bank Transfer",
                Icons.account_balance,
              ),
              _paymentOption(
                context,
                "Credit Card",
                Icons.credit_card,
              ),
              _paymentOption(
                context,
                "E-Wallet",
                Icons.account_balance_wallet,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _paymentOption(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1DB954)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        _showSuccessDialog(context);
      },
    );
  }

  String getFormattedTime(DateTime time, String timezone) {
    switch (timezone) {
      case 'WITA':
        time = time.add(const Duration(hours: 1));
        break;
      case 'WIT':
        time = time.add(const Duration(hours: 2));
        break;
      default: // WIB
        break;
    }
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }

  void _showSuccessDialog(BuildContext context) {
    DateTime now = DateTime.now();

    String formatDate(DateTime date) {
      List<String> months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];
      return "${date.day} ${months[date.month - 1]} ${date.year}";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF212121),
              title: const Text(
                "Payment Successful!",
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thank you for subscribing. You can now proceed with registration.",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Waktu Pembayaran:",
                    style: TextStyle(
                      color: Color(0xFF1DB954),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF1DB954)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal: ${formatDate(now)}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              "Zona Waktu: ",
                              style: TextStyle(color: Colors.white),
                            ),
                            DropdownButton<String>(
                              value: selectedTimeZone,
                              dropdownColor: const Color(0xFF212121),
                              style: const TextStyle(color: Colors.white),
                              items:
                                  ['WIB', 'WITA', 'WIT'].map((String timezone) {
                                return DropdownMenuItem<String>(
                                  value: timezone,
                                  child: Text(timezone),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedTimeZone = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Waktu: ${getFormattedTime(now, selectedTimeZone)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Registrasi()),
                    );
                  },
                  child: const Text(
                    "Continue to Registration",
                    style: TextStyle(color: Color(0xFF1DB954)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class BenefitItem extends StatelessWidget {
  final String text;

  const BenefitItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF1DB954),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
