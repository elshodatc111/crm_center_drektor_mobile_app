import 'package:crm_center_admin_charts/screen/home/dars_jadvali.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DarsjadvalWidget extends StatelessWidget {
  final int count;
  final String data;
  final List<Map<String, dynamic>> jadval;
  const DarsjadvalWidget({super.key, required this.count, required this.jadval, required this.data});

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
                        Icons.date_range,
                        color: Colors.brown,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Dars jadvali: ($data)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "$count",
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
              ...jadval.map((item) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${item['group_name']}", style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            "O'qituvchi: ${item['techer_name']}",
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.door_back_door_outlined, color: Colors.green, size: 18),
                                  SizedBox(width: 4),
                                  Text("${item['room']}"),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.lock_clock, color: Colors.green, size: 18),
                                  SizedBox(width: 4),
                                  Text("${item['time']}"),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    )
                  ],
                );
              }).toList(),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Get.to(()=>DarsJadvali());
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
                      Icon(Icons.view_week, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Haftalik dars jadvali",
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
