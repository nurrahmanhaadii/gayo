import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/wallet_card_widget.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Navigate back to LoginScreen after logging out
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID directly from FirebaseAuth
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GAYO NFT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Make the entire screen scrollable
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          // Vertical padding only
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // WalletCardWidget will now fill the width
              WalletCardWidget(userId: userId),
              const SizedBox(height: 20),

              // Sales Graph with adjusted height
              const SizedBox(
                height: 150, // Set height explicitly for clarity
                width: double.infinity,
                child: NFTSalesChart(),
              ),
              const SizedBox(height: 20),

              // NFT Information Box
              const NFTInformationBox(),
            ],
          ),
        ),
      ),
    );
  }
}

// Sales Graph Widget
class NFTSalesChart extends StatelessWidget {
  const NFTSalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 3),
              const FlSpot(1, 2),
              const FlSpot(2, 5),
              const FlSpot(3, 3.5),
              const FlSpot(4, 4),
              const FlSpot(5, 3),
              const FlSpot(6, 4.5),
            ],
            isCurved: true,
            color: Colors.green, // Use `color` instead of `colors`
            barWidth: 2,
          ),
        ],
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
      ),
    );
  }
}

// NFT Information Box
class NFTInformationBox extends StatelessWidget {
  const NFTInformationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Fill the horizontal space
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("NFT Name: Wet Gayo"),
          Text("Description: High-quality wet processed coffee NFT."),
          Text("Owner: John Doe"),
          Text("Supply: 50 NFTs"),
          // Add more information as needed
        ],
      ),
    );
  }
}
