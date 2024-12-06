import 'package:ecommerce_app_with_flutter/src/core/app_bar_colors.dart';
import 'package:ecommerce_app_with_flutter/src/data/helper/database/helper_db.dart';
import 'package:ecommerce_app_with_flutter/src/data/session/session.dart';
import 'package:ecommerce_app_with_flutter/src/presentation/widgets/export_widgets.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  final SessionManager _sessionManager = SessionManager();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      int? userId = await _sessionManager.getUserId();
      if (userId != null) {
        final user = await _dbHelper.getUser(userId);
        if (mounted) {
          setState(() {
            userData = user;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _showLogoutConfirmation() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Tidak logout
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Melanjutkan logout
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _logout();
    }
  }

  Future<void> _logout() async {
    await _sessionManager.clearSession();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: AppBarColors.darkIcons,
        leading: const BackButton(color: Colors.black54),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black54, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed:
                _showLogoutConfirmation, // Mengganti dengan fungsi konfirmasi
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xff76bbaa),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    userData?['username']?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData?['username'] ?? 'User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(userData?['email'] ?? 'email@example.com'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            ProfileItemCard(
              title: 'Personal Data',
              icon: UniconsLine.user,
              onTap: () {
                Navigator.pushNamed(context, '/personal-data');
              },
            ),
            ProfileItemCard(
              title: 'About',
              icon: UniconsLine.info_circle,
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            ProfileItemCard(
              title: 'Time Converter',
              icon: UniconsLine.clock,
              onTap: () {
                Navigator.pushNamed(context, '/time-converter');
              },
            ),
          ],
        ),
      ),
    );
  }
}
