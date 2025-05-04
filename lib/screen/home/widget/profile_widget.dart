import 'package:crm_center_admin_charts/screen/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final box = GetStorage();

  String nameFirst = '';
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _checkAndLoadUser();
  }

  void _checkAndLoadUser() {
    nameFirst = box.read('first') ?? '';
    name = box.read('name') ?? '';
    email = box.read('email') ?? '';

    if (nameFirst.isEmpty || name.isEmpty || email.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: Text(
            nameFirst,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              email,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14.0,
              ),
            ),
          ],
        )
      ],
    );
  }
}
