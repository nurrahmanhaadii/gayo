import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/nft_model.dart';

class NFTFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<NFTModel?> getNFTData(String nftType) async {
    DocumentSnapshot snapshot =
        await _db.collection('nft_data').doc(nftType).get();
    if (snapshot.exists) {
      return NFTModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateNFTData(NFTModel nftModel) async {
    await _db
        .collection('nft_data')
        .doc(nftModel.nftType)
        .set(nftModel.toMap());
  }

  Future<void> updateMintedCount(String nftType, int increment) async {
    await _db.collection('nft_data').doc(nftType).update({
      'mintedCount': FieldValue.increment(increment),
    });
  }

  Future<void> updateTradingVolume(
      String nftType, int buyIncrement, int sellIncrement) async {
    await _db.collection('nft_data').doc(nftType).update({
      'buyVolume': FieldValue.increment(buyIncrement),
      'sellVolume': FieldValue.increment(sellIncrement),
    });
  }
}
