import 'package:ecommerce_app_with_flutter/src/data/helper/database/helper_db.dart';
import 'package:ecommerce_app_with_flutter/src/data/session/session.dart';
import 'package:flutter/material.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({Key? key}) : super(key: key);

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  Map<String, dynamic>? userData;
  final SessionManager _sessionManager = SessionManager();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    int? userId = await _sessionManager.getUserId();
    if (userId != null) {
      final user = await _dbHelper.getUser(userId);
      setState(() {
        userData = user as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Personal Details',
          style: TextStyle(color: Colors.black54, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black54),
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoTile('Name', userData!['username']),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildInfoTile('Email', userData!['email']),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildInfoTile(
                      'Phone Number', userData!['phone'] ?? 'Not set'),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildInfoTile('Password', userData!['password']),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
