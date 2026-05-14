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
    _errorTimer?.cancel();
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
        curve: Interval(
          (0.1 * index).clamp(0, 1.0),
          1.0,
          curve: Curves.easeOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animController,
                curve: Interval(
                  (0.1 * index).clamp(0, 1.0),
                  1.0,
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
        child: child,
      ),
    );
  }

  // ── Envoi de l'event freezed ──────────────────────────────────────────────
  void _onSubmit(BuildContext context) {
    _triggerErrors();
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthEvent.loginRequested(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(
        children: [
          // ── Blobs de fond ─────────────────────────────────────────────────
          Positioned(
            top: -100,
            left: -60,
            child: IspmGlowBlob.circle(
              radius: 160,
              primaryColor: ISPMColors.greenDark.withOpacity(0.09),
              secondaryColor: ISPMColors.greenDark.withOpacity(0.07),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: IspmGlowBlob.circle(
              radius: 160,
              primaryColor: ISPMColors.greenDark.withOpacity(0.09),
              secondaryColor: ISPMColors.greenDark.withOpacity(0.07),
            ),
          ),
          const Positioned.fill(child: IspmMeshGrid()),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                // ── BlocConsumer avec états freezed ───────────────────────
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    state.whenOrNull(
                      // Erreur → SnackBar
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: ISPMColors.error,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  builder: (context, state) {
                    // isLoading : vrai si l'état courant est loading
                    final isLoading =
                        state.whenOrNull(loading: () => true) ?? false;

                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _animatedItem(
                            0,
                            const IspmHeader(
                              title: 'Portail Professeur',
                              subtitle: 'Veuillez vous identifier',
                            ),
                          ),

                          _animatedItem(
                            1,
                            _SectionDivider(label: 'Identifiants'),
                          ),

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
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Mot de passe requis' : null,
                            ),
                          ),

                          _animatedItem(
                            4,
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: ISPMColors.green.withOpacity(
                                    0.8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),
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

                          _animatedItem(
                            5,
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: IspmButton(
                                text: 'CONNEXION',
                                isLoading: isLoading,
                                onPressed: () => _onSubmit(context),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

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

// ─────────────────────────────────────────────────────────────────────────────
// Séparateur avec label centré
// ─────────────────────────────────────────────────────────────────────────────

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
