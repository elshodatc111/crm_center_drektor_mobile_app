import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DebetUsers extends StatefulWidget {
  const DebetUsers({super.key});

  @override
  State<DebetUsers> createState() => _DebetUsersState();
}

class _DebetUsersState extends State<DebetUsers> {
  List<dynamic> users = [];
  bool isLoading = true;

  Future<void> fetchUsers() async {
    setState(() => isLoading = true);
    final box = GetStorage();
    final token = box.read("token");

    try {
      final response = await http.get(
        Uri.parse("https://crm-center.atko.tech/api/admin/debet"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        setState(() {
          users = body['data'];
        });
      } else {
        print("Xatolik: ${response.statusCode}");
      }
    } catch (e) {
      print("Xatolik: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: const Text("Qarzdor talabalar"),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.lightBlueAccent, Colors.teal]),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchUsers,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(user['user'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user['about'] ?? "Ma'lumot yo'q"),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 18, color: Colors.green[800]),
                            const SizedBox(width: 6),
                            Text(user['phone1']),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 18, color: Colors.green[800]),
                            const SizedBox(width: 6),
                            Text(user['phone1']),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cake, size: 18, color: Colors.purple),
                            const SizedBox(width: 6),
                            Text(user['birthday']),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, size: 18, color: Colors.redAccent),
                            const SizedBox(width: 6),
                            Text(user['address']),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.money_off_csred_outlined, color: Colors.red),
                        const SizedBox(width: 6),
                        Text(
                          "Qarzdorlik: ${user['balans']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
