import 'dart:convert';
import 'package:crm_center_admin_charts/ApiConst.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DarsJadvali extends StatefulWidget {
  const DarsJadvali({super.key});

  @override
  State<DarsJadvali> createState() => _DarsJadvaliState();
}

class _DarsJadvaliState extends State<DarsJadvali> {
  final GetStorage _storage = GetStorage();
  String _token = '';
  List<dynamic> _jadval = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _token = _storage.read('token') ?? '';
    fetchJadval();
  }

  Future<void> fetchJadval() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${ApiConst.apiUrl}/admin/jadval'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _jadval = json['data'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xatolik: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ulanishda xatolik: $e')),
      );
    }
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd, EEEE', 'uz').format(date);
    } catch (_) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        title: Text("Dars jadvali"),
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
        onRefresh: fetchJadval,
        child: ListView.builder(
          itemCount: _jadval.length,
          itemBuilder: (context, index) {
            final kun = _jadval[index];
            final items = kun['item'] as List<dynamic>;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
              child: Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    formatDate(kun['date']),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: items.map((item) {
                    return ListTile(
                      title: Text(item['group_name'] ?? '', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("O'qituvchi: ${item['techer_name']}"),
                          Text("Xona: ${item['room']}"),
                          Text("Vaqt: ${item['time']}"),
                          Text("Talabalar soni: ${item['count']}"),
                        ],
                      ),
                      leading: Icon(Icons.class_, color: Colors.teal),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
