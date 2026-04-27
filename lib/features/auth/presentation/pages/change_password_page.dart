// lib/features/auth/presentation/pages/change_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';
import '../../../../core/theme/app_theme.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;
  const ChangePasswordPage({super.key, required this.user});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

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
    switch (_strength) {
      case 0:
      case 1:
        return ISPMColors.error;
      case 2:
      case 3:
        return ISPMColors.warning;
      default:
        return ISPMColors.green;
    }
  }

  String get _strengthLabel {
    switch (_strength) {
      case 0:
      case 1:
        return 'Trop court';
      case 2:
        return 'Faible';
      case 3:
        return 'Moyen';
      case 4:
        return 'Fort';
      default:
        return 'Très fort';
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        ChangePasswordRequestedEvent(
          newPassword: _passwordController.text.trim(),
          user: widget.user,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F6),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ISPMColors.error,
              ),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── En-tête coloré ──
                  Container(
                    color: ISPMColors.black,
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: ISPMColors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: ISPMColors.green.withOpacity(0.3)),
                          ),
                          child: const Icon(
                            Icons.security_rounded,
                            color: ISPMColors.green,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Première connexion',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: ISPMColors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bonjour ${widget.user.name}, pour sécuriser votre compte, '
                              'veuillez définir un mot de passe personnel.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: ISPMColors.white.withOpacity(0.5),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Formulaire ──
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Nouveau mot de passe
                          _FieldLabel(label: 'Nouveau mot de passe'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Min. 6 caractères',
                              hintStyle: TextStyle(
                                  color: ISPMColors.grey400, fontSize: 14),
                              prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 20,
                                  color: ISPMColors.grey400),
                              suffixIcon: GestureDetector(
                                onTap: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                  color: ISPMColors.grey400,
                                ),
                              ),
                            ),
                            validator: (v) => v == null || v.length < 6
                                ? 'Minimum 6 caractères requis'
                                : null,
                          ),
                          // Indicateur de force
                          if (_passwordController.text.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _strength / 5,
                                      backgroundColor:
                                      ISPMColors.grey200,
                                      color: _strengthColor,
                                      minHeight: 4,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _strengthLabel,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _strengthColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 20),

                          // Confirmation
                          _FieldLabel(label: 'Confirmer le mot de passe'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confirmController,
                            obscureText: _obscureConfirm,
                            decoration: InputDecoration(
                              hintText: 'Répétez le mot de passe',
                              hintStyle: TextStyle(
                                  color: ISPMColors.grey400, fontSize: 14),
                              prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 20,
                                  color: ISPMColors.grey400),
                              suffixIcon: GestureDetector(
                                onTap: () => setState(
                                        () => _obscureConfirm = !_obscureConfirm),
                                child: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                  color: ISPMColors.grey400,
                                ),
                              ),
                            ),
                            validator: (v) =>
                            v != _passwordController.text
                                ? 'Les mots de passe ne correspondent pas'
                                : null,
                          ),
                          const SizedBox(height: 32),

                          // Règles
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ISPMColors.grey100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Critères recommandés',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: ISPMColors.grey600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _Rule(
                                  label: 'Au moins 8 caractères',
                                  ok: _passwordController.text.length >= 8,
                                ),
                                _Rule(
                                  label: 'Une lettre majuscule',
                                  ok: RegExp(r'[A-Z]')
                                      .hasMatch(_passwordController.text),
                                ),
                                _Rule(
                                  label: 'Un chiffre',
                                  ok: RegExp(r'[0-9]')
                                      .hasMatch(_passwordController.text),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Bouton
                          ElevatedButton(
                            onPressed:
                            state is AuthLoading ? null : _onSubmit,
                            child: state is AuthLoading
                                ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Text('Enregistrer et continuer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

class _Rule extends StatelessWidget {
  final String label;
  final bool ok;
  const _Rule({required this.label, required this.ok});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 14,
            color: ok ? ISPMColors.green : ISPMColors.grey400,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: ok ? ISPMColors.greenDark : ISPMColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}
