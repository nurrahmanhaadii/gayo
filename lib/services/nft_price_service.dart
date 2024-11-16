import 'package:cloud_firestore/cloud_firestore.dart';

class NFTPriceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final int initialPriceWetGayo = 150000;
  final int initialPriceDryGayo = 300000;
  final int maxSupplyWetGayo = 1200000;
  final int maxSupplyDryGayo = 600000;
  final int gasFee = 360;

  Future<int> calculatePrice({
    required String nftType,
    required int mintedCount,
    required int buyVolume,
    required int sellVolume,
  }) async {
    int initialPrice =
        nftType == 'Wet Gayo' ? initialPriceWetGayo : initialPriceDryGayo;
    int maxSupply = nftType == 'Wet Gayo' ? maxSupplyWetGayo : maxSupplyDryGayo;

    if (mintedCount <= maxSupply * 0.1) {
      // Static pricing phase: price increases 1% every 1,000 NFTs
      return (initialPrice * (1 + (0.01 * (mintedCount / 1000)))).toInt();
    } else {
      // Dynamic pricing phase: minting + trading influence
      double tradingMultiplier = 1 + (0.05 * ((buyVolume - sellVolume) / 100));
      double mintingMultiplier = 1 + (0.01 * (mintedCount / 10000));
      return (initialPrice * mintingMultiplier * tradingMultiplier).toInt();
    }
  }

  int applyGasFee(int transactionAmount) {
    return transactionAmount + gasFee;
  }

  Future<void> logTransaction({
    required String userId,
    required String nftType,
    required int price,
    required String transactionType, // "BUY" or "SELL"
  }) async {
    await _db.collection('transactions').add({
      'userId': userId,
      'nftType': nftType,
      'price': price,
      'transactionType': transactionType,
      'gasFee': gasFee,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
