import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  Map<String, dynamic> _userData = {
    'username': '-',
    'phone': '-',
    'privateKey': '-',
    'walletAddress': '-',
    'pinTransaction': '-',
    'nikNumber': '-',
    'fullName': '-',
    'sex': '-',
    'birthday': '-',
    'maritalStatus': '-',
  };

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinTransactionController =
      TextEditingController();
  final TextEditingController _nikNumberController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc('temporary')
          .collection('temporaryUsers')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>;
          _usernameController.text = _userData['username'] ?? '-';
          _phoneController.text = _userData['phone'] ?? '-';
          _pinTransactionController.text = _userData['pinTransaction'] ?? '-';
          _nikNumberController.text = _userData['nikNumber'] ?? '-';
          _fullNameController.text = _userData['fullName'] ?? '-';
          _sexController.text = _userData['sex'] ?? '-';
          _birthdayController.text = _userData['birthday'] ?? '-';
          _maritalStatusController.text = _userData['maritalStatus'] ?? '-';
        });
      }
    }
  }

  void _toggleEditSave() async {
    if (_isEditing) {
      if (_formKey.currentState!.validate()) {
        // Generate private key and wallet address based on SHA-256
        final privateKey =
            sha256.convert(utf8.encode(_usernameController.text)).toString();
        final walletAddress =
            sha256.convert(utf8.encode(privateKey)).toString();

        // Prepare data to save
        final userId = FirebaseAuth.instance.currentUser?.uid;
        final userData = {
          'username': _usernameController.text,
          'phone': _phoneController.text,
          'privateKey': privateKey,
          'walletAddress': walletAddress,
          'pinTransaction': _pinTransactionController.text,
          'nikNumber': _nikNumberController.text,
          'fullName': _fullNameController.text,
          'sex': _sexController.text,
          'birthday': _birthdayController.text,
          'maritalStatus': _maritalStatusController.text,
        };

        // Save data to temporary and move to users/
        if (userId != null) {
          final userDocRef =
              FirebaseFirestore.instance.collection('users').doc(userId);
          // await FirebaseFirestore.instance
          //     .collection('users')
          //     .doc('temporary')
          //     .collection('temporaryUsers')
          //     .doc(userId)
          //     .set(userData);
          await userDocRef.set(userData);
          await FirebaseFirestore.instance
              .collection('users')
              .doc('temporary')
              .collection('temporaryUsers')
              .doc(userId)
              .delete();
        }

        setState(() {
          _userData = userData;
          _isEditing = false;
        });
      }
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Username/Email", _usernameController, true),
              _buildTextField("Phone Number", _phoneController, true),
              _buildTextField("Private Key",
                  TextEditingController(text: _userData['privateKey']), false),
              _buildTextField(
                  "Wallet Address",
                  TextEditingController(text: _userData['walletAddress']),
                  false),
              _buildTextField(
                  "PIN Transaction", _pinTransactionController, true),
              _buildTextField("NIK Number", _nikNumberController, true),
              _buildTextField("Full Name", _fullNameController, false),
              _buildTextField("Sex", _sexController, false),
              _buildTextField("Birthday", _birthdayController, false),
              _buildTextField(
                  "Marital Status", _maritalStatusController, false),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _toggleEditSave,
                child: Text(_isEditing ? "SAVE" : "EDIT"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool isMandatory) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        decoration: InputDecoration(
          labelText: label + (isMandatory ? ' *' : ''),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (isMandatory && (value == null || value.isEmpty)) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }
}
