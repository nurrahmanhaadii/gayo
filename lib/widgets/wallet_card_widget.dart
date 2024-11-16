import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/nft_model.dart';

class WalletCardWidget extends StatefulWidget {
  final String? userId;

  const WalletCardWidget({super.key, required this.userId});

  @override
  _WalletCardWidgetState createState() => _WalletCardWidgetState();
}

class _WalletCardWidgetState extends State<WalletCardWidget> {
  bool _isVerified = false;
  NFTModel? _nftData;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      _checkUserVerification();
    }
  }

  Future<void> _checkUserVerification() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (userSnapshot.exists) {
      setState(() {
        _isVerified = true;
      });
      await _fetchNFTData();
    } else {
      setState(() {
        _isVerified = false;
      });
    }
  }

  Future<void> _fetchNFTData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('nft_data')
        .doc(widget.userId)
        .get();
    if (snapshot.exists) {
      setState(() {
        _nftData = NFTModel.fromMap(snapshot.data() as Map<String, dynamic>);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Make card fill horizontal space
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      // Respect safe area
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NFT Wallet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'NFT Stock: ${_isVerified ? (_nftData?.nftStock ?? '-') : '-'}',
              ),
              Text(
                'Last Buy: ${_isVerified ? (_nftData?.lastBuy ?? '-') : '-'}',
              ),
              Text(
                'Last Sell: ${_isVerified ? (_nftData?.lastSell ?? '-') : '-'}',
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Wallet Screen (Add navigation here if applicable)
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  // Make button full-width
                  backgroundColor: Colors.green, // Adjust color if needed
                ),
                child: const Text("Go to Wallet"),
              ),
              if (!_isVerified)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Complete KYC to activate NFT wallet',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
