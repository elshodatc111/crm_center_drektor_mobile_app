import 'package:crm_center_admin_charts/screen/home/chiqim_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Kassawidget extends StatelessWidget {
  final String all_kassa;
  final String naqt_mavjud;
  final String plastik_mavjud;
  final String naqt_pedding;
  final String plastik_pedding;
  const Kassawidget({super.key, required this.all_kassa, required this.naqt_mavjud, required this.plastik_mavjud, required this.naqt_pedding, required this.plastik_pedding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.orangeAccent,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Kassada mavjud:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    all_kassa,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(Icons.account_balance, color: Colors.green[600], size: 32),
                      SizedBox(height: 6),
                      Text(
                        "Kassada Mavjud",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.blueAccent, size: 20),
                          SizedBox(width: 4),
                          Text(
                            naqt_mavjud,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.credit_card, color: Colors.purple, size: 20),
                          SizedBox(width: 4),
                          Text(
                            plastik_mavjud,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.outbox_rounded, color: Colors.orangeAccent, size: 32),
                      SizedBox(height: 6),
                      Text(
                        "Chiqim Kutilmoqda",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.blueAccent, size: 20),
                          SizedBox(width: 4),
                          Text(
                            naqt_pedding,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.credit_card, color: Colors.purple, size: 20),
                          SizedBox(width: 4),
                          Text(
                            plastik_pedding,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              GestureDetector(
            onTap: () {
              Get.to(()=>ChiqimHistory());
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.greenAccent],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Kutilayotgan chiqimlar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
