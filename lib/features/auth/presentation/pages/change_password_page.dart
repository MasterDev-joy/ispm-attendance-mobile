// lib/features/auth/presentation/pages/change_password_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../blocs/auth_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_button.dart';
import '../../../../core/presentation/widgets/ispm_text_field.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;
  const ChangePasswordPage({super.key, required this.user});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool _showNewPassWordError = false;
  bool _showNewPasswordConfirmationError = false;
  Timer? _errorTimer;
  static const _kErrorDuration = Duration(seconds: 3);

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..forward();

    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _animController.dispose();
    _errorTimer?.cancel();
    super.dispose();
  }

  void _triggerErrors() {
    _errorTimer?.cancel();
    setState(() {
      _showNewPassWordError = _passwordController.text.trim().isEmpty;
      _showNewPasswordConfirmationError = _confirmController.text
          .trim()
          .isEmpty;
    });
    _errorTimer = Timer(_kErrorDuration, () {
      if (mounted) {
        setState(() {
          _showNewPassWordError = false;
          _showNewPasswordConfirmationError = false;
        });
      }
    });
  }

  // ── Force du mot de passe ─────────────────────────────────────────────────
  int get _strength {
    final v = _passwordController.text;
    if (v.length < 6) return 0;
    int score = 1;
    if (v.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(v)) score++;
    if (RegExp(r'[0-9]').hasMatch(v)) score++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(v)) score++;
    return score;
  }

  Color get _strengthColor {
    if (_strength <= 1) return ISPMColors.error;
    if (_strength <= 3) return ISPMColors.warning;
    return ISPMColors.green;
  }

  String get _strengthLabel {
    if (_strength <= 1) return 'Trop court';
    if (_strength == 2) return 'Faible';
    if (_strength == 3) return 'Moyen';
    if (_strength == 4) return 'Fort';
    return 'Très fort';
  }

  Widget _staggered(int index, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animController,
        curve: Interval(
          (0.1 * index).clamp(0.0, 1.0),
          1.0,
          curve: Curves.easeOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animController,
                curve: Interval(
                  (0.1 * index).clamp(0.0, 1.0),
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
  void _onSubmit() {
    _triggerErrors();
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthEvent.changePasswordRequested(
          userId: widget.user.id,
          newPassword: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: BlocConsumer<AuthBloc, AuthState>(
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
            // Mot de passe changé → accueil
            authenticated: (_) {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          );
        },
        builder: (context, state) {
          // isLoading depuis l'état freezed
          final isLoading = state.whenOrNull(loading: () => true) ?? false;

          return Stack(
            children: [
              const Positioned.fill(child: _PageBackground()),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // En-tête — accède à widget.user directement (plus de findAncestorStateOfType)
                      _staggered(0, _PageHeader(user: widget.user)),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Nouveau mot de passe
                              _staggered(
                                1,
                                IspmTextField(
                                  controller: _passwordController,
                                  label: 'Nouveau mot de passe',
                                  hint: 'Min. 6 caractères',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  isPassword: _obscurePassword,
                                  showError: _showNewPassWordError,
                                  errorText: 'Nouveau mot de passe requis',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white.withOpacity(0.3),
                                      size: 18,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                  validator: (v) => v == null || v.length < 6
                                      ? 'Minimum 6 caractères requis'
                                      : null,
                                ),
                              ),

                              // Indicateur de force
                              if (_passwordController.text.isNotEmpty)
                                _staggered(
                                  2,
                                  _StrengthIndicator(
                                    strength: _strength,
                                    color: _strengthColor,
                                    label: _strengthLabel,
                                  ),
                                ),

                              const SizedBox(height: 20),

                              // Confirmation
                              _staggered(
                                3,
                                IspmTextField(
                                  controller: _confirmController,
                                  label: 'Confirmer le mot de passe',
                                  hint: 'Votre nouveau mot de passe',
                                  prefixIcon: Icons.lock_reset_rounded,
                                  isPassword: _obscureConfirm,
                                  showError: _showNewPasswordConfirmationError,
                                  errorText:
                                      'Confirmation du mot de passe requis',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white.withOpacity(0.3),
                                      size: 18,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm,
                                    ),
                                  ),
                                  validator: (v) =>
                                      v != _passwordController.text
                                      ? 'Les mots de passe ne correspondent pas'
                                      : null,
                                ),
                              ),

                              const SizedBox(height: 24),

                              _staggered(
                                4,
                                _RulesBox(password: _passwordController.text),
                              ),

                              const SizedBox(height: 32),

                              _staggered(
                                5,
                                IspmButton(
                                  text: 'Enregistrer et continuer',
                                  isLoading: isLoading,
                                  onPressed: _onSubmit,
                                  icon: Icons.shield_outlined,
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
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPOSANTS LOCAUX
// ─────────────────────────────────────────────────────────────────────────────

class _PageBackground extends StatelessWidget {
  const _PageBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: -60,
          right: -40,
          child: IspmGlowBlob.circle(
            radius: 110,
            primaryColor: ISPMColors.green.withOpacity(0.18),
          ),
        ),
        const IspmMeshGrid(opacity: 0.022),
      ],
    );
  }
}

// ── En-tête — reçoit user en paramètre (plus de findAncestorStateOfType) ────
class _PageHeader extends StatelessWidget {
  final User user;
  const _PageHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ISPMColors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ISPMColors.green.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.security_rounded,
              color: ISPMColors.green,
              size: 24,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Première connexion',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.white.withOpacity(0.45),
                height: 1.65,
              ),
              children: [
                const TextSpan(text: 'Bonjour '),
                TextSpan(
                  text: user.fullName,
                  style: const TextStyle(
                    color: ISPMColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text:
                      ', veuillez définir un mot de passe personnel pour votre compte.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StrengthIndicator extends StatelessWidget {
  final int strength;
  final Color color;
  final String label;

  const _StrengthIndicator({
    required this.strength,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: strength / 5,
              backgroundColor: Colors.white.withOpacity(0.08),
              color: color,
              minHeight: 4,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _RulesBox extends StatelessWidget {
  final String password;
  const _RulesBox({required this.password});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CRITÈRES RECOMMANDÉS',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 12),
          _Rule(label: 'Au moins 8 caractères', ok: password.length >= 8),
          _Rule(
            label: 'Une lettre majuscule',
            ok: RegExp(r'[A-Z]').hasMatch(password),
          ),
          _Rule(label: 'Un chiffre', ok: RegExp(r'[0-9]').hasMatch(password)),
        ],
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  final String label;
  final bool ok;
  const _Rule({required this.label, required this.ok});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: ok ? ISPMColors.green : Colors.white.withOpacity(0.2),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: ok ? Colors.white : Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
