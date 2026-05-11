import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import 'package:ispm_attendance/core/presentation/shared_widgets/admin_shared_widgets.dart';

import '../blocs/settings_cubit.dart';
import '../blocs/settings_state.dart';

const _kAmber = Color(0xFFBA7517);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();
  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Widget _stagger(int i, Widget child) {
    final start = (0.10 * i).clamp(0.0, 0.8);
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animCtrl,
        curve: Interval(start, 1.0, curve: Curves.easeOut),
      ),
      child: child,
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();
    final confirmed =
        await showDialog<bool>(
          context: context,
          barrierColor: Colors.black.withOpacity(0.65),
          builder: (_) => _DangerDialog(
            title: 'Réinitialiser la base de données',
            message: 'Supprimera TOUTES les présences. Irréversible.',
            confirmLabel: 'Réinitialiser',
            onConfirm: () => Navigator.pop(context, true),
            onCancel: () => Navigator.pop(context, false),
          ),
        ) ??
        false;
    if (confirmed) cubit.resetAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: IspmGlowBlob.circle(
              radius: 190,
              primaryColor: _kAmber.withOpacity(0.08),
              secondaryColor: Colors.transparent,
            ),
          ),
          const Positioned.fill(child: IspmMeshGrid()),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                AdminAppBar(
                  title: 'Paramètres système',
                  subtitle: 'Configuration de l\'application',
                  onBack: () => Navigator.pop(context),
                ),
                Expanded(
                  child: BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      final cubit = context.read<SettingsCubit>();
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _stagger(0, _SectionLabel(label: 'Serveur')),
                          const SizedBox(height: 10),
                          _stagger(
                            1,
                            _ServerStatusCard(
                              baseUrl: state.serverStatus?.baseUrl ?? '',
                              isOk: state.serverStatus?.isOnline ?? false,
                              status:
                                  state.serverStatus?.message ?? 'Non vérifié',
                              checking: state.isCheckingServer,
                              onCheck: cubit.checkServer,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _stagger(2, const _SectionLabel(label: 'Code QR')),
                          const SizedBox(height: 10),
                          _stagger(
                            3,
                            _SettingsToggle(
                              icon: Icons.rotate_right_rounded,
                              label: 'Rotation automatique',
                              subtitle:
                                  'Régénère le QR toutes les ${state.qrDurationSec}s',
                              value: state.qrRotationEnabled,
                              accent: _kAmber,
                              onChanged: cubit.toggleQrRotation,
                            ),
                          ),
                          _stagger(
                            4,
                            _SettingsSlider(
                              icon: Icons.timer_rounded,
                              label: 'Durée de validité du QR',
                              value: state.qrDurationSec.toDouble(),
                              min: 5,
                              max: 60,
                              divisions: 11,
                              suffix: 'sec',
                              accent: _kAmber,
                              onChanged: (v) => cubit.setQrDuration(v.round()),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _stagger(5, const _SectionLabel(label: 'Sécurité')),
                          const SizedBox(height: 10),
                          _stagger(
                            6,
                            _SettingsToggle(
                              icon: Icons.fingerprint_rounded,
                              label: 'Biométrie obligatoire',
                              subtitle: 'Force l\'empreinte digitale pour tous',
                              value: state.requireBiometrics,
                              accent: _kAmber,
                              onChanged: cubit.toggleBiometrics,
                            ),
                          ),
                          _stagger(
                            7,
                            _SettingsItem(
                              icon: Icons.key_rounded,
                              label: 'Rotation des clés JWT',
                              subtitle: 'Expire tous les tokens actifs',
                              accent: _kAmber,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(height: 24),
                          _stagger(
                            8,
                            const _SectionLabel(label: 'Maintenance'),
                          ),
                          const SizedBox(height: 10),
                          _stagger(
                            9,
                            _SettingsToggle(
                              icon: Icons.construction_rounded,
                              label: 'Mode maintenance',
                              subtitle:
                                  'Bloque l\'accès aux professeurs et superviseurs',
                              value: state.maintenanceMode,
                              accent: ISPMColors.error,
                              onChanged: cubit.toggleMaintenance,
                            ),
                          ),
                          _stagger(
                            10,
                            _SettingsItem(
                              icon: Icons.storage_rounded,
                              label: 'Sauvegarde des données',
                              subtitle:
                                  'Exporter une copie de la base de données',
                              accent: _kAmber,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(height: 24),
                          _stagger(
                            11,
                            const _SectionLabel(label: 'Application'),
                          ),
                          const SizedBox(height: 10),
                          _stagger(12, _InfoCard()),
                          const SizedBox(height: 24),
                          _stagger(
                            13,
                            _SectionLabel(
                              label: 'Zone danger',
                              color: ISPMColors.error,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _stagger(
                            14,
                            _DangerButton(
                              icon: Icons.delete_sweep_rounded,
                              label: 'Réinitialiser les présences',
                              subtitle:
                                  'Supprime toutes les données d\'attendance',
                              onTap: () => _confirmReset(context),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
//  Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({
    required this.label,
    this.color = const Color(0x66FFFFFF),
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: color,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Divider(
          color: ISPMColors.white.withOpacity(0.07),
          thickness: 0.5,
        ),
      ),
    ],
  );
}

// Statut serveur
class _ServerStatusCard extends StatelessWidget {
  final String baseUrl, status;
  final bool isOk, checking;
  final VoidCallback onCheck;
  const _ServerStatusCard({
    required this.baseUrl,
    required this.status,
    required this.isOk,
    required this.checking,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    final color = checking
        ? _kAmber
        : isOk
        ? ISPMColors.green
        : ISPMColors.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.30), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Indicateur statut
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: color.withOpacity(0.28)),
                ),
                child: checking
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          color: color,
                          strokeWidth: 2.2,
                        ),
                      )
                    : Icon(
                        isOk
                            ? Icons.cloud_done_rounded
                            : Icons.cloud_off_rounded,
                        size: 18,
                        color: color,
                      ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOk ? 'Serveur en ligne' : 'Serveur hors ligne',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: ISPMColors.white.withOpacity(0.40),
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: checking ? null : onCheck,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _kAmber.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: _kAmber.withOpacity(0.30)),
                  ),
                  child: Text(
                    'Tester',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _kAmber,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: ISPMColors.white.withOpacity(0.06), height: 0),
          const SizedBox(height: 10),

          // URL
          Row(
            children: [
              Icon(
                Icons.link_rounded,
                size: 13,
                color: ISPMColors.white.withOpacity(0.35),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  baseUrl,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.45),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: baseUrl));
                  // Vérifie si le contexte est toujours monté avant d'afficher le SnackBar
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lien copié !"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: Icon(
                  Icons.copy_rounded,
                  size: 13,
                  color: ISPMColors.white.withOpacity(0.30),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Toggle switch
class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final Color accent;
  final ValueChanged<bool> onChanged;
  const _SettingsToggle({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
    decoration: BoxDecoration(
      color: value ? accent.withOpacity(0.07) : ISPMColors.grey900,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: value
            ? accent.withOpacity(0.32)
            : ISPMColors.white.withOpacity(0.06),
        width: value ? 1.5 : 1.0,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: (value ? accent : ISPMColors.white).withOpacity(0.10),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: (value ? accent : ISPMColors.white).withOpacity(0.18),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: value ? accent : ISPMColors.white.withOpacity(0.38),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ISPMColors.white.withOpacity(value ? 1.0 : 0.75),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: ISPMColors.white.withOpacity(0.32),
                ),
              ),
            ],
          ),
        ),
        Transform.scale(
          scale: 0.84,
          child: Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: accent,
            activeTrackColor: accent.withOpacity(0.30),
            inactiveThumbColor: ISPMColors.white.withOpacity(0.40),
            inactiveTrackColor: ISPMColors.white.withOpacity(0.10),
          ),
        ),
      ],
    ),
  );
}

// Slider paramètre
class _SettingsSlider extends StatelessWidget {
  final IconData icon;
  final String label, suffix;
  final double value, min, max;
  final int divisions;
  final Color accent;
  final ValueChanged<double> onChanged;
  const _SettingsSlider({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.suffix,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.fromLTRB(15, 13, 15, 10),
    decoration: BoxDecoration(
      color: ISPMColors.grey900,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.11),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: accent.withOpacity(0.22)),
              ),
              child: Icon(icon, size: 18, color: accent),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ISPMColors.white,
                ),
              ),
            ),
            Text(
              '${value.round()} $suffix',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: accent,
            inactiveTrackColor: ISPMColors.white.withOpacity(0.10),
            thumbColor: accent,
            overlayColor: accent.withOpacity(0.15),
            trackHeight: 3,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
}

// Item standard
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color accent;
  final VoidCallback onTap;
  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.11),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: accent.withOpacity(0.22)),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ISPMColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.32),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: ISPMColors.white.withOpacity(0.25),
          ),
        ],
      ),
    ),
  );
}

// Info app
class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ISPMColors.grey900,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
    ),
    child: Column(
      children: [
        _InfoRow(label: 'Version', value: 'v1.0.0'),
        _InfoRow(label: 'Build', value: '2025.01'),
        _InfoRow(label: 'Backend', value: 'Node.js + Prisma'),
        _InfoRow(label: 'Base de données', value: 'SQLite'),
        _InfoRow(label: 'Auth', value: 'JWT 24h', isLast: true),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool isLast;
  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: ISPMColors.white.withOpacity(0.45),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ISPMColors.white,
            ),
          ),
        ],
      ),
      if (!isLast) ...[
        const SizedBox(height: 10),
        Divider(color: ISPMColors.white.withOpacity(0.06), height: 0),
        const SizedBox(height: 10),
      ],
    ],
  );
}

// Bouton danger
class _DangerButton extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final VoidCallback onTap;
  const _DangerButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: ISPMColors.error.withOpacity(0.07),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ISPMColors.error.withOpacity(0.28),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: ISPMColors.error.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: ISPMColors.error.withOpacity(0.25)),
            ),
            child: const Icon(
              Icons.delete_sweep_rounded,
              size: 18,
              color: ISPMColors.error,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ISPMColors.error,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.error.withOpacity(0.55),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: ISPMColors.error,
          ),
        ],
      ),
    ),
  );
}

// Dialog danger
class _DangerDialog extends StatelessWidget {
  final String title, message, confirmLabel;
  final VoidCallback onConfirm, onCancel;
  const _DangerDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: ISPMColors.grey900,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ISPMColors.error.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ISPMColors.error.withOpacity(0.28)),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  size: 20,
                  color: ISPMColors.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: ISPMColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: ISPMColors.white.withOpacity(0.50),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                    foregroundColor: ISPMColors.white.withOpacity(0.50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: ISPMColors.white.withOpacity(0.12),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ISPMColors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    confirmLabel,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ISPMColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
