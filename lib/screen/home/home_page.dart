import 'dart:convert';

import 'package:crm_center_admin_charts/screen/home/widget/aktiv_tashrif_widget.dart';
import 'package:crm_center_admin_charts/screen/home/widget/balansWidget.dart';
import 'package:crm_center_admin_charts/screen/home/widget/chart_widget.dart';
import 'package:crm_center_admin_charts/screen/home/widget/darsjadval_widget.dart';
import 'package:crm_center_admin_charts/screen/home/widget/debet_widget.dart';
import 'package:crm_center_admin_charts/screen/home/widget/kassaWidget.dart';
import 'package:crm_center_admin_charts/screen/home/widget/profile_widget.dart';
import 'package:crm_center_admin_charts/screen/home/widget/tashrifWidget.dart';
import 'package:crm_center_admin_charts/screen/home/widget/tulovWidget.dart';
import 'package:crm_center_admin_charts/screen/login/splash_page.dart';
import 'package:crm_center_admin_charts/screen/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> _homeData = {};
  bool _isLoading = true;
  final GetStorage _storage = GetStorage();
  late String _token;

  @override
  void initState() {
    super.initState();
    _token = _storage.read('token') ?? '';
    fetchHomes();
  }

  Future<void> fetchHomes() async {
    if (_token.isEmpty) {
      Future.microtask(() {
        Get.offAll(() => SplashPage());
      });
      return;
    }
    final response = await http.get(
      Uri.parse('https://crm-center.atko.tech/api/admin/home'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _homeData = data;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () {
            Get.to(() => ProfilePage());
          },
          borderRadius: BorderRadius.circular(12),
          child: ProfileWidget(),
        ),
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
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  backgroundColor: Colors.white,
                  strokeWidth: 2.0,
                ),
              )
              : _homeData.isEmpty
              ? const Center(child: Text("Guruhlar topilmadi"))
              : SafeArea(
                child: RefreshIndicator(
                  onRefresh: fetchHomes,
                  displacement: 50,
                  // Vertical displacement of the spinner
                  color: Colors.blue,
                  // Spinner color
                  backgroundColor: Colors.white,
                  // Background color of the spinner
                  strokeWidth: 2.0,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Balanswidget(
                            all_price:
                                _homeData['balans']['all_price'] ?? '0 UZS',
                            naqt_price:
                                _homeData['balans']['naqt_price'] ?? '0 UZS',
                            plastik_price:
                                _homeData['balans']['plastik_price'] ?? '0 UZS',
                            exson_price:
                                _homeData['balans']['exson_price'] ?? '0 UZS',
                          ),
                          Kassawidget(
                            all_kassa:
                                _homeData['kassa']['all_kassa'] ?? '0 UZS',
                            naqt_mavjud:
                                _homeData['kassa']['naqt_mavjud'] ?? '0 UZS',
                            plastik_mavjud:
                                _homeData['kassa']['plastik_mavjud'] ?? '0 UZS',
                            naqt_pedding:
                                _homeData['kassa']['naqt_pedding'] ?? '0 UZS',
                            plastik_pedding:
                                _homeData['kassa']['plastik_pedding'] ??
                                '0 UZS',
                          ),
                          DebetWidget(count: "${_homeData['debet_count']['count']}",price: _homeData['debet_count']['summa'],users: _homeData['debet_count']['users'],),
                          Tulovwidget(
                            price: _homeData['paymarts']['price'] ?? '0 UZS',
                            paymart: List<Map<String, dynamic>>.from(
                              _homeData['paymarts']['paymarts'] ?? [],
                            ),
                          ),
                          Tashrifwidget(count: _homeData['tashrif_count'] ?? 0),
                          AktivTashrifWidget(
                            count: _homeData['active_count'] ?? 0,
                          ),
                          DarsjadvalWidget(
                            count: _homeData['jadval']['count'] ?? 0,
                            data: _homeData['jadval']['data'] ?? 0,
                            jadval: List<Map<String, dynamic>>.from(
                              _homeData['jadval']['jadval'] ?? [],
                            ),
                          ),
                          //ChartWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
