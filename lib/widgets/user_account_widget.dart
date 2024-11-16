import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

class UserAccountWidget extends StatelessWidget {
  final String username;
  final String email;
  final String phoneNumber;
  final String pinTransaction;
  final String nikNumber;
  final String fullName;
  final String sex;
  final String birthday;
  final String maritalStatus;
  final int nftStock;
  final String lastBuy;
  final String lastSell;

  const UserAccountWidget({
    super.key,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.pinTransaction,
    required this.nikNumber,
    this.fullName = '',
    this.sex = '',
    this.birthday = '',
    this.maritalStatus = '',
    required this.nftStock,
    required this.lastBuy,
    required this.lastSell,
  });

  String _generatePrivateKey(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  String _generateWalletAddress(String privateKey) {
    return sha256.convert(utf8.encode(privateKey)).toString();
  }

  @override
  Widget build(BuildContext context) {
    String privateKey = _generatePrivateKey('$username$email$nikNumber');
    String walletAddress = _generateWalletAddress(privateKey);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: $username',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Email: $email'),
            Text('Phone Number: $phoneNumber'),
            Text('NIK Number: $nikNumber'),
            Text('PIN Transaction: $pinTransaction'),
            const SizedBox(height: 10),
            Text('Private Key: $privateKey',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text('Wallet Address: $walletAddress',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),
            if (fullName.isNotEmpty) Text('Full Name: $fullName'),
            if (sex.isNotEmpty) Text('Sex: $sex'),
            if (birthday.isNotEmpty) Text('Birthday: $birthday'),
            if (maritalStatus.isNotEmpty)
              Text('Marital Status: $maritalStatus'),
            const SizedBox(height: 20),
            Text('NFT Stock: $nftStock'),
            Text('Last Buy: $lastBuy'),
            Text('Last Sell: $lastSell'),
          ],
        ),
      ),
    );
  }
}
