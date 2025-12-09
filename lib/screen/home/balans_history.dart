import 'dart:convert';
import 'package:crm_center_admin_charts/ApiConst.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:crm_center_admin_charts/screen/login/splash_page.dart';

class BalansHistory extends StatefulWidget {
  const BalansHistory({super.key});

  @override
  State<BalansHistory> createState() => _BalansHistoryState();
}

class _BalansHistoryState extends State<BalansHistory> {
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
      Uri.parse('${ApiConst.apiUrl}/admin/balans'),
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
        locale: 'fr_FR',
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

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'xar_naqt':
        return Icons.money_off;
      case 'xar_plastik':
        return Icons.credit_card;
      case 'ish_naqt':
        return Icons.work;
      case 'ish_plas':
        return Icons.badge;
      case 'chiq_exson':
        return Icons.volunteer_activism;
      case 'chiq_naqt':
        return Icons.attach_money;
      case 'chiq_plastik':
        return Icons.account_balance_wallet;
      case 'plastik_chiq': //plastik_chiq naqt_chiq
      case 'naqt_chiq':
        return Icons.check_box;
      default:
        return Icons.help_outline;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'xar_naqt':
        return 'Xarajat (Naqt)';
      case 'xar_plastik':
        return 'Xarajat (Plastik)';
      case 'ish_naqt':
        return 'Ish haqi (Naqt)';
      case 'ish_plas':
        return 'Ish haqi (Plastik)';
      case 'chiq_exson':
        return 'Ehson chiqimi';
      case 'chiq_naqt':
        return 'Daromad (Naqt)';
      case 'chiq_plastik':
        return 'Daromad (Plastik)';
      case 'plastik_chiq':
        return 'Kassadan Chiqim (Plastik)';
      case 'naqt_chiq':
        return 'Kassadan Chiqim (Naqt)';
      default:
        return 'Boshqa';
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'xar_naqt':
      case 'xar_plastik':
        return Colors.redAccent;
      case 'ish_naqt':
      case 'ish_plas':
        return Colors.orange;
      case 'plastik_chiq':
      case 'naqt_chiq':
        return Colors.blue;
      case 'chiq_exson':
        return Colors.brown;
      case 'chiq_naqt':
      case 'chiq_plastik':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: const Text("Balans tarixi (Oxirgi 3 oy)"),
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
            final data = _data[index];
            final type = data['type'];
            final color = _getTypeColor(type);
            final icon = _getTypeIcon(type);

            return Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                elevation: 4,
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
                              _getTypeLabel(type),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          Text(
                            '${formatAmount(data['amount'])} UZS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['description'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['meneger'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            formatDateTime(data['succes_time']),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      )
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
