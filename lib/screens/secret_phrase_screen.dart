import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:provider/provider.dart';
import '../components/capsule_box.dart';
import '../components/custom_button.dart';
import '../components/loading_indicator.dart';
import '../services/firestore_database_service.dart';
import '../services/firebase_auth_service.dart';
import 'main_screen.dart';

class SecretPhrasesScreen extends StatefulWidget {
  const SecretPhrasesScreen({super.key});

  @override
  _SecretPhrasesScreenState createState() => _SecretPhrasesScreenState();
}

class _SecretPhrasesScreenState extends State<SecretPhrasesScreen> {
  late List<String> _mnemonicPhrases;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateMnemonic();
  }

  void _generateMnemonic() {
    setState(() => _isLoading = true);
    final mnemonic = bip39.generateMnemonic();
    _mnemonicPhrases = mnemonic.split(' ');
    setState(() => _isLoading = false);
  }

  void _continue() async {
    final dbService =
        Provider.of<FirestoreDatabaseService>(context, listen: false);
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);

    // Get the authenticated user's ID
    final user = await authService.authStateChanges.first;
    final userId = user?.uid;

    if (userId != null) {
      // Save secret phrases to Firestore
      await dbService.completeRegistration(userId, {
        'secretPhrases': _mnemonicPhrases,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Navigate to MainScreen, removing previous screens from the stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      print("Error: No authenticated user found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secret Phrases')),
      body: _isLoading
          ? const LoadingIndicator()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _mnemonicPhrases.length,
                    itemBuilder: (context, index) {
                      return CapsuleBox(text: _mnemonicPhrases[index]);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () {
                          // Capture screenshot logic here
                        },
                      ),
                      CustomButton(
                        text: 'Continue',
                        onPressed: _continue,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
