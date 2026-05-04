import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:agrovet/utils/app_theme.dart';
import 'package:agrovet/utils/validators.dart';

class LoginVeterinarianScreen extends StatefulWidget {
  const LoginVeterinarianScreen({super.key});

  @override
  State<LoginVeterinarianScreen> createState() => _LoginVeterinarianScreenState();
}

class _LoginVeterinarianScreenState extends State<LoginVeterinarianScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushReplacementNamed('/home_veterinarian');
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String semanticLabel,
  }) {
    return SizedBox(
      width: 52,
      height: 52,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Semantics(
          label: semanticLabel,
          button: true,
          child: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinario - Iniciar Sesión'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.stethoscope,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  const Text(
                    'Acceso Veterinario',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo Electronico',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Ingresar',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'O continúa con',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.gray),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildSocialButton(
                        icon: const FaIcon(FontAwesomeIcons.google),
                        semanticLabel: 'Google',
                      ),
                      _buildSocialButton(
                        icon: const FaIcon(FontAwesomeIcons.github),
                        semanticLabel: 'GitHub',
                      ),
                      _buildSocialButton(
                        icon: const FaIcon(FontAwesomeIcons.facebookF),
                        semanticLabel: 'Facebook',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes una cuenta? '),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/register');
                              },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Registrate gratis',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
