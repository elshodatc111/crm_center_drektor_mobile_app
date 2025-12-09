import 'package:crm_center_admin_charts/screen/home/paymart_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tulovwidget extends StatelessWidget {
  final String price;
  final List<Map<String, dynamic>> paymart;

  const Tulovwidget({
    super.key,
    required this.price,
    required this.paymart,
  });

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
              /// --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payments_outlined,
                          color: Colors.deepOrangeAccent, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "Kunlik to'lovlar:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),

              /// --- Dynamic List from paymart ---
              ...paymart.asMap().entries.map((entry) {
                int index = entry.key + 1;
                final item = entry.value;
                return Column(
                  children: [
                    _buildPaymentTile(
                      index,
                      item['user'],
                      item['paymart_type'],
                      item['amount'],
                      item['created_at'],
                    ),
                    Divider(),
                  ],
                );
              }).toList(),

              /// --- Button ---
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Get.to(()=>PaymartHistory());
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
                      Icon(Icons.account_balance_wallet, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Kunlik to'lovlar",
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

  /// --- Helper Function for Each Payment Tile ---
  Widget _buildPaymentTile(
      int index, String name, String type, String amount, String time) {
    IconData icon;
    Color color;

    switch (type.toLowerCase()) {
      case "naqt":
        icon = Icons.attach_money;
        color = Colors.orange;
        break;
      case "plastik":
        icon = Icons.credit_card;
        color = Colors.purple;
        break;
      case "chegirma":
        icon = Icons.discount;
        color = Colors.blue;
        break;
      default:
        icon = Icons.money;
        color = Colors.grey;
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Text(
          "$index",
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
              Text(amount,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 18),
                  SizedBox(width: 4),
                  Text(type),
                ],
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
