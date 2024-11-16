import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_button.dart';
import '../components/text_field_input.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_database_service.dart';
import 'secret_phrase_screen.dart';
import 'package:bip39/bip39.dart' as bip39;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    final dbService =
        Provider.of<FirestoreDatabaseService>(context, listen: false);

    final password = _passwordController.text.trim();
    final email =
        "temporary_${DateTime.now().millisecondsSinceEpoch}@app.com"; // Temporary email

    // Register user with Firebase Authentication
    final user = await authService.registerWithEmailPassword(email, password);
    if (user != null) {
      // Prepare data to save to Firestore
      final mnemonic = bip39.generateMnemonic();
      final data = {
        'passwordHash': password,
        'secretPhrases': mnemonic.split(' '),
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save temporary registration data to Firestore
      await dbService.saveTemporaryRegistrationData(user.uid, data);

      // Navigate to SecretPhrasesScreen
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const SecretPhrasesScreen()));
    } else {
      print("Registration failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/gayo_coffee.png', height: 100),
              const SizedBox(height: 20),
              TextFieldInput(
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
                inputType: TextInputType.text,
              ),
              CustomButton(
                text: 'Register Now!',
                color: Colors.green,
                onPressed: _register,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Already have an account? Login Now!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
