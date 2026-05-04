// lib/features/auth/presentation/pages/login_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/ispm_button.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_header.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../../core/presentation/widgets/ispm_text_field.dart';
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

  bool _showEmailError = false;
  bool _showPasswordError = false;
  Timer? _errorTimer;
  static const _kErrorDuration = Duration(seconds: 3);

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _triggerErrors() {
    _errorTimer?.cancel();
    setState(() {
      _showEmailError = _emailController.text.trim().isEmpty;
      _showPasswordError = _passwordController.text.trim().isEmpty;
    });
    _errorTimer = Timer(_kErrorDuration, () {
      if (mounted) {
        setState(() {
          _showEmailError = false;
          _showPasswordError = false;
        });
      }
    });
  }

  Widget _animatedItem(int index, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animController,
        curve: Interval((0.1 * index).clamp(0, 1.0), 1.0,
            curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animController,
          curve: Interval((0.1 * index).clamp(0, 1.0), 1.0,
              curve: Curves.easeOutCubic),
        )),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utilise ISPMColors.black pour un fond plus profond que grey900
      backgroundColor: ISPMColors.black,
      body: Stack(
        children: [
          // ── Blob vert haut-gauche ──────────────────────────
          Positioned(
            top: -100,
            left: -60,
            child: IspmGlowBlob.circle(
              radius: 160,
              primaryColor: ISPMColors.greenDark.withOpacity(0.09),
              secondaryColor: ISPMColors.greenDark.withOpacity(0.07),
            ),
          ),
          // ── Blob vert bas-droite ───────────────────────────
          Positioned(
            bottom: -60,
            right: -40,
            child: IspmGlowBlob.circle(
              radius: 160,
              primaryColor: ISPMColors.greenDark.withOpacity(0.09),
              secondaryColor: ISPMColors.greenDark.withOpacity(0.07),
            ),
          ),
          // ── Grille mesh SVG CustomPaint ────────────────────
          const Positioned.fill(child: IspmMeshGrid()),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: ISPMColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    } else if (state is AuthAuthenticated) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    } else if (state is AuthRequiresPasswordChange) {
                      Navigator.of(context).pushReplacementNamed(
                        '/change-password',
                        arguments: state.user,
                      );
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo + titre + sous-titre
                          _animatedItem(
                            0,
                            const IspmHeader(
                              title: 'Portail Professeur',
                              subtitle: 'Veuillez vous identifier',
                            ),
                          ),

                          // Séparateur labelisé
                          _animatedItem(
                              1,
                              _SectionDivider(label: 'Identifiants')),

                          // Champ email
                          _animatedItem(
                            2,
                            IspmTextField(
                              controller: _emailController,
                              label: 'Email professionnel',
                              hint: 'prenom.nom@ispm.mg',
                              prefixIcon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              showError: _showEmailError,
                              errorText: 'Email requis',
                              validator: (v) =>
                              v!.isEmpty ? 'Email requis' : null,
                            ),
                          ),

                          // Champ mot de passe
                          _animatedItem(
                            3,
                            IspmTextField(
                              controller: _passwordController,
                              label: 'Mot de passe',
                              hint: 'Votre mot de passe',
                              prefixIcon: Icons.lock_outline_rounded,
                              isPassword: _obscurePassword,
                              showError: _showPasswordError,
                              errorText: 'Mot de passe requis',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: ISPMColors.grey400,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                              ),
                              validator: (v) =>
                              v!.isEmpty ? 'Mot de passe requis' : null,
                            ),
                          ),

                          // Mot de passe oublié
                          _animatedItem(
                            4,
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                  ISPMColors.green.withOpacity(0.8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                ),
                                child: const Text(
                                  'Mot de passe oublié ?',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Bouton connexion
                          _animatedItem(
                            5,
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: IspmButton(
                                text: 'CONNEXION',
                                isLoading: state is AuthLoading,
                                onPressed: (){
                                  _triggerErrors();
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      LoginRequestedEvent(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Footer
                          _animatedItem(
                            6,
                            Text(
                              'Institut Supérieur Polytechnique de Madagascar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ISPMColors.white.withOpacity(0.2),
                                fontSize: 11,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
//  Séparateur avec label centré
// ─────────────────────────────────────────────────
class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: ISPMColors.white.withOpacity(0.1),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: ISPMColors.white.withOpacity(0.2),
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: ISPMColors.white.withOpacity(0.1),
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}