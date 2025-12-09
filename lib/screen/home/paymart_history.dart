import 'dart:convert';
import 'package:crm_center_admin_charts/ApiConst.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:crm_center_admin_charts/screen/login/splash_page.dart';

class PaymartHistory extends StatefulWidget {
  const PaymartHistory({super.key});

  @override
  State<PaymartHistory> createState() => _PaymartHistoryState();
}

class _PaymartHistoryState extends State<PaymartHistory> {
  List<dynamic> _data = [];
  bool _isLoading = true;
  final GetStorage _storage = GetStorage();
  late String _token;

  @override
  void initState() {
    super.initState();
    _token = _storage.read('token') ?? '';
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    if (_token.isEmpty) {
      Future.microtask(() {
        Get.offAll(() => const SplashPage());
      });
      return;
    }

    final response = await http.get(
      Uri.parse('${ApiConst.apiUrl}/admin/paymart'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _data = data['data'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  String formatAmount(String amountString) {
    try {
      final number = double.parse(amountString);
      final formatter = NumberFormat.currency(
        locale: 'uz_UZ',
        symbol: "so'm",
        decimalDigits: 0,
      );
      return formatter.format(number);
    } catch (e) {
      return amountString;
    }
  }

  String formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final formatter = DateFormat('yyyy-MM-dd HH:mm');
      return formatter.format(dateTime);
    } catch (e) {
      return isoString;
    }
  }

  Icon getPaymentIcon(String type) {
    switch (type) {
      case 'naqt':
        return const Icon(Icons.money, color: Colors.green);
      case 'plastik':
        return const Icon(Icons.credit_card, color: Colors.blueAccent);
      case 'chegirma':
        return const Icon(Icons.discount, color: Colors.orange);
      case 'qaytarildi':
        return const Icon(Icons.disabled_by_default_outlined, color: Colors.red);
      default:
        return const Icon(Icons.attach_money, color: Colors.grey);
    }
  }

  Color getCardColor(String type) {
    switch (type) {
      case 'naqt':
        return Colors.green.withOpacity(0.1);
      case 'plastik':
        return Colors.blue.withOpacity(0.1);
      case 'chegirma':
        return Colors.orange.withOpacity(0.1);
      case 'qaytarildi':
        return Colors.redAccent.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: const Text("Kunlik to'lovlar"),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.teal],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchData,
        child: _data.isEmpty
            ? const Center(child: Text("Hech qanday ma'lumot topilmadi"))
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _data.length,
          itemBuilder: (context, index) {
            final item = _data[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: getPaymentIcon(item['paymart_type']),
                  title: Text(
                    item['user_name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Admin: ${item['admin_name']}"),
                      Text("Izoh: ${item['description']}"),
                      Text("Vaqti: ${formatDateTime(item['created_at'])}"),
                    ],
                  ),
                  trailing: Text(
                    formatAmount(item['amount']),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  isThreeLine: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
