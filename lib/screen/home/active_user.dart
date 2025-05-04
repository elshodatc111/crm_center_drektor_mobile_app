import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:crm_center_admin_charts/screen/login/splash_page.dart';

class ActiveUser extends StatefulWidget {
  const ActiveUser({super.key});

  @override
  State<ActiveUser> createState() => _ActiveUserState();
}

class _ActiveUserState extends State<ActiveUser> {
  List<dynamic> _users = [];
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
      Uri.parse('https://crm-center.atko.tech/api/admin/active'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _users = (data['data']['users'] as Map<String, dynamic>).values.toList();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  String formatAmount(dynamic amount) {
    try {
      final number = double.parse(amount.toString());
      final formatter = NumberFormat.currency(
        locale: 'uz_UZ',
        symbol: 'so‘m',
        decimalDigits: 0,
      );
      return formatter.format(number).trim();
    } catch (e) {
      return amount.toString();
    }
  }

  String formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        title: Text("Aktiv talabalar"),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.teal],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    user['user_name'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      Text('Guruh: ${user['group_name'] ?? 'N/A'}'),
                      Text('Boshlanish: ${formatDateTime(user['lessen_start'] ?? '')}'),
                      Text('Tugash: ${formatDateTime(user['lessen_end'] ?? '')}'),
                      Text('Balans: ${formatAmount(user['balans'] ?? 0)}'),
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
