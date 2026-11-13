import 'package:flutter/material.dart';

import 'main_screen.dart';
import 'map.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.explore_rounded,
                    size: 42,
                    color: Color(0xFF17453D),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'ArmTravel',
                      style: TextStyle(
                        color: Color(0xFF17453D),
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Բարի գալուստ',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF202925),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Մուտք գործեք և շարունակեք ձեր ճանապարհորդությունը.',
                            style: TextStyle(
                              color: Color(0xFF737B75),
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 22),
                          TextField(
                            controller: _email,
                            decoration: const InputDecoration(
                              labelText: 'Էլ. փոստ',
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _password,
                            obscureText: true,
                            autofillHints: const [AutofillHints.password],
                            decoration: const InputDecoration(
                              labelText: 'Գաղտնաբառ',
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainScreen(),
                                ),
                              ),
                              child: const Text('Մուտք'),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              ),
                              child: const Text('Ստեղծել հաշիվ'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MapScreen()),
                    ),
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Զննել որպես հյուր'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
