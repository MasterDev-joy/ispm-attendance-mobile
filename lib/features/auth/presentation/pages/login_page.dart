// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';
import '../../../../core/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequestedEvent(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: ISPMColors.error,
              ),
            );
          } else if (state is AuthRequiresPasswordChange) {
            Navigator.of(context).pushReplacementNamed(
              '/change-password',
              arguments: state.user,
            );
          } else if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // ── Fond décoratif haut ──
              Positioned(
                top: -60,
                right: -40,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ISPMColors.green.withOpacity(0.07),
                  ),
                ),
              ),

              // ── Carte blanche inférieure ──
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: size.height * 0.72,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F8F6),
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                ),
              ),

              // ── Contenu ──
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── En-tête sombre ──
                          Padding(
                            padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo compact
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: ISPMColors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      'assets/images/logo_ispm.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) =>
                                      const Center(
                                        child: Text(
                                          'IS',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: ISPMColors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Bienvenue',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: ISPMColors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Connectez-vous pour accéder\nà votre espace.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: ISPMColors.white.withOpacity(0.5),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),

                          // ── Formulaire sur carte blanche ──
                          Container(
                            constraints: BoxConstraints(
                              minHeight: size.height * 0.62,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF7F8F6),
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(32)),
                            ),
                            padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Label section
                                  const Text(
                                    'Connexion',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: ISPMColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Entrez vos identifiants institutionnels',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: ISPMColors.grey400,
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Champ Email
                                  _FieldLabel(label: 'Adresse email'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: 'exemple@ispm.mg',
                                      hintStyle: TextStyle(
                                        color: ISPMColors.grey400,
                                        fontSize: 14,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.alternate_email_rounded,
                                        size: 20,
                                        color: ISPMColors.grey400,
                                      ),
                                    ),
                                    validator: (v) =>
                                    v == null || v.isEmpty
                                        ? 'Veuillez entrer votre email'
                                        : null,
                                  ),
                                  const SizedBox(height: 20),

                                  // Champ Mot de passe
                                  _FieldLabel(label: 'Mot de passe'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _onLoginPressed(),
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      hintStyle: TextStyle(
                                        color: ISPMColors.grey400,
                                        fontSize: 14,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock_outline_rounded,
                                        size: 20,
                                        color: ISPMColors.grey400,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () => setState(
                                              () => _obscurePassword =
                                          !_obscurePassword,
                                        ),
                                        child: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          size: 20,
                                          color: ISPMColors.grey400,
                                        ),
                                      ),
                                    ),
                                    validator: (v) =>
                                    v == null || v.isEmpty
                                        ? 'Veuillez entrer le mot de passe'
                                        : null,
                                  ),
                                  const SizedBox(height: 36),

                                  // Bouton de connexion
                                  AnimatedContainer(
                                    duration:
                                    const Duration(milliseconds: 200),
                                    child: ElevatedButton(
                                      onPressed: state is AuthLoading
                                          ? null
                                          : _onLoginPressed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ISPMColors.green,
                                        foregroundColor: ISPMColors.white,
                                        disabledBackgroundColor:
                                        ISPMColors.green.withOpacity(0.5),
                                        elevation: 0,
                                        minimumSize:
                                        const Size.fromHeight(54),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: state is AuthLoading
                                          ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child:
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                          : const Text(
                                        'Se connecter',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Séparateur info
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: ISPMColors.greenSoft,
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ISPMColors.green
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline_rounded,
                                          size: 18,
                                          color: ISPMColors.greenDark,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Utilisez vos identifiants fournis par l\'administration ISPM.',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: ISPMColors.greenDark,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: ISPMColors.grey600,
        letterSpacing: 0.2,
      ),
    );
  }
}
