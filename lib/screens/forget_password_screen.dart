import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/text_field_input.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final List<TextEditingController> _controllers =
      List.generate(12, (_) => TextEditingController());
  bool _isValidating = false;

  void _validateSecretPhrase() {
    setState(() => _isValidating = true);

    final enteredPhrase =
        _controllers.map((controller) => controller.text.trim()).join(' ');
    // Validate the entered phrase with the stored phrase from Firestore here

    setState(() => _isValidating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Enter your 12 secret phrases',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return TextFieldInput(
                  controller: _controllers[index],
                  hintText: 'Word ${index + 1}',
                  inputType: TextInputType.text,
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Continue',
              color: Colors.blue,
              onPressed: _validateSecretPhrase,
            ),
            if (_isValidating) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
