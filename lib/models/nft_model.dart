class NFTModel {
  final String nftType;
  final int mintedCount;
  final int buyVolume;
  final int sellVolume;
  final int nftStock; // New field for NFT stock owned by the user
  final String lastBuy; // New field for last buy date or transaction
  final String lastSell; // New field for last sell date or transaction

  NFTModel({
    required this.nftType,
    required this.mintedCount,
    required this.buyVolume,
    required this.sellVolume,
    this.nftStock = 0,
    this.lastBuy = '-',
    this.lastSell = '-',
  });

  Map<String, dynamic> toMap() {
    return {
      'nftType': nftType,
      'mintedCount': mintedCount,
      'buyVolume': buyVolume,
      'sellVolume': sellVolume,
      'nftStock': nftStock,
      'lastBuy': lastBuy,
      'lastSell': lastSell,
    };
  }

  factory NFTModel.fromMap(Map<String, dynamic> map) {
    return NFTModel(
      nftType: map['nftType'] ?? '',
      mintedCount: map['mintedCount'] ?? 0,
      buyVolume: map['buyVolume'] ?? 0,
      sellVolume: map['sellVolume'] ?? 0,
      nftStock: map['nftStock'] ?? 0,
      lastBuy: map['lastBuy'] ?? '-',
      lastSell: map['lastSell'] ?? '-',
    );
  }
}
