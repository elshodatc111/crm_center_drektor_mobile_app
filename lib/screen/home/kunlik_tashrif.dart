import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crm_center_admin_charts/screen/login/splash_page.dart';
import 'package:intl/intl.dart';

class KunlikTashrif extends StatefulWidget {
  const KunlikTashrif({super.key});

  @override
  State<KunlikTashrif> createState() => _KunlikTashrifState();
}

class _KunlikTashrifState extends State<KunlikTashrif> {
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
      Future.microtask(() => Get.offAll(() => const SplashPage()));
      return;
    }

    final response = await http.get(
      Uri.parse('https://crm-center.atko.tech/api/admin/tashrif'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _data = json['data'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  Color getBalansColor(String balans) {
    if (balans.contains('-')) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  IconData getBalansIcon(String balans) {
    if (balans.contains('-')) {
      return Icons.trending_down;
    } else {
      return Icons.trending_up;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: const Text("Kunlik tashriflar"),
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
            ? const Center(child: Text("Tashriflar topilmadi"))
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _data.length,
          itemBuilder: (context, index) {
            final item = _data[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.withOpacity(0.2),
                    child: const Icon(Icons.person, color: Colors.teal),
                  ),
                  title: Text(
                    item['user'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(item['phone1']),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.home, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(item['address']),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.cake, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text("Tug‘ilgan sana: ${formatDate(item['birthday'])}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.school, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text("Guruh soni: ${item['group_count']}"),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        getBalansIcon(item['balans']),
                        color: getBalansColor(item['balans']),
                      ),
                      Text(
                        item['balans'],
                        style: TextStyle(
                          color: getBalansColor(item['balans']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
