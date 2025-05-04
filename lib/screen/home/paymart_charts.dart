import 'package:flutter/material.dart';
class PaymartCharts extends StatefulWidget {
  const PaymartCharts({super.key});

  @override
  State<PaymartCharts> createState() => _PaymartChartsState();
}

class _PaymartChartsState extends State<PaymartCharts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        title: Text("To'lovlar Statistikasi"),
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
    );
  }
}
