import 'package:crm_center_admin_charts/screen/home/paymart_charts.dart';
import 'package:crm_center_admin_charts/screen/home/tasgrif_charts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Get.to(() => TasgrifCharts());
          },
          child: _buildStatCard(
            icon: Icons.people_alt_rounded,
            title: "Tashriflar Statistikasi",
            gradientColors: [Colors.deepPurpleAccent, Colors.indigo],
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(() => PaymartCharts());
          },
          child: _buildStatCard(
            icon: Icons.payments_rounded,
            title: "To'lovlar Statistikasi",
            gradientColors: [Colors.green, Colors.teal],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required List<Color> gradientColors,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 0.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: gradientColors),
              ),
              width: Get.width * 0.38,
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
