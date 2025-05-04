import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:crm_center_admin_charts/screen/login/splash_page.dart';

class ChiqimHistory extends StatefulWidget {
  const ChiqimHistory({super.key});

  @override
  State<ChiqimHistory> createState() => _ChiqimHistoryState();
}

class _ChiqimHistoryState extends State<ChiqimHistory> {
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
        Get.offAll(() => SplashPage());
      });
      return;
    }

    final response = await http.get(
      Uri.parse('https://crm-center.atko.tech/api/admin/kassa'),
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
        locale: 'fr_FR', // space bilan ajratadi
        symbol: '',
        decimalDigits: 2,
      );
      return formatter.format(number).trim();
    } catch (e) {
      return amountString;
    }
  }

  String formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      return formatter.format(dateTime);
    } catch (e) {
      return isoString;
    }
  }

  String getTypeLabel(String type) {
    switch (type) {
      case 'naqt_chiq':
        return 'Naqt chiqim';
      case 'plastik_chiq':
        return 'Plastik chiqim';
      default:
        return 'Nomaʼlum';
    }
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'naqt_chiq':
        return Colors.deepOrange;
      case 'plastik_chiq':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData getTypeIcon(String type) {
    switch (type) {
      case 'naqt_chiq':
        return Icons.money_off;
      case 'plastik_chiq':
        return Icons.credit_card;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: const Text("Tasdiqlanmagan chiqimlar"),
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
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.teal,
          strokeWidth: 4,
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: _data.length,
          itemBuilder: (ctx, index) {
            final item = _data[index];
            final color = getTypeColor(item['type']);
            final icon = getTypeIcon(item['type']);
            final label = getTypeLabel(item['type']);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(icon, color: color),
                          const SizedBox(width: 10),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          Text(
                            '${formatAmount(item['amount'])} UZS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['user_name'],
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Text(
                            formatDateTime(item['create_time']),
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if ((item['description'] ?? '').toString().trim().isNotEmpty)
                        Text(
                          item['description'],
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
