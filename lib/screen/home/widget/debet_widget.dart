import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crm_center_admin_charts/screen/home/debet_users.dart';

class DebetWidget extends StatelessWidget {
  final String count;
  final String price;
  final List<dynamic> users;

  const DebetWidget({
    super.key,
    required this.count,
    required this.price,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.white,
        shadowColor: Colors.teal.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Qarzdorlar soni
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.groups_rounded, color: Colors.green.shade700, size: 28),
                      ),
                      const SizedBox(height: 10),
                      const Text("Qarzdorlar",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(count, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  // Qarzdorlik summasi
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.money_off_rounded, color: Colors.orange.shade700, size: 28),
                      ),
                      const SizedBox(height: 10),
                      const Text("Qarzdorlik",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(price, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Faqat 3 ta foydalanuvchini ko'rsatish
              Column(
                children: users.take(3).map((user) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Icon(Icons.person, color: Colors.teal.shade700),
                      ),
                      title: Text(
                        user['user'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.money, size: 16, color: Colors.redAccent),
                              const SizedBox(width: 4),
                              Text(
                                user['balans'],
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // To'liq ro'yxatga o'tish tugmasi
              GestureDetector(
                onTap: () {
                  Get.to(() => const DebetUsers());
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.greenAccent],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Qarzdorliklar ro'yxati",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
