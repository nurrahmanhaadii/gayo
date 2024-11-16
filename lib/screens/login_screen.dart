import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/text_field_input.dart';
import '../components/loading_indicator.dart';
import 'register_screen.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() {
    setState(() => _isLoading = true);
    // Add login authentication logic here
    setState(() => _isLoading = false);
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
                controller: _usernameController,
                hintText: 'Username',
                inputType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
                inputType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ForgetPasswordScreen()));
                },
                child: const Text('Forgot password?'),
              ),
              CustomButton(
                text: 'Login Now!',
                color: Colors.blue, // Customize the color if desired
                onPressed: _login,
              ),
              if (_isLoading) const LoadingIndicator(color: Colors.blue),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen()));
                },
                child: const Text("Don't have an account? Register Now!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
