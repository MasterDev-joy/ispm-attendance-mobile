// lib/features/admin/users/presentation/pages/users_page.dart
//
// ✅ AVANT : state.status == UserStatus.loading / state.saveDone
//    APRÈS : state.when() / state.whenOrNull() (freezed)
//
// ✅ UserLoadRequested → UserEvent.load()
//    UserToggleRequested → UserEvent.toggle()
//    UserSaveRequested   → UserEvent.save()
//    UserFilterChanged   → UserEvent.filterChanged()
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../../../core/presentation/widgets/ispm_text_field.dart';
import '../../../../../core/presentation/widgets/ispm_button.dart';
import '../../domain/entities/admin_user.dart';
import '../blocs/user_bloc.dart';
import '../../../../core/presentation/shared_widgets/admin_shared_widgets.dart';

const _kAmber = Color(0xFFBA7517);
const _kBlue = Color(0xFF378ADD);

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage>
    with SingleTickerProviderStateMixin {
  final _search = TextEditingController();
  String _filter = 'all';
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    // ✅ Event freezed
    context.read<UserBloc>().add(const UserEvent.load());

    _search.addListener(() {
      context.read<UserBloc>().add(
        UserEvent.filterChanged(filter: _filter, query: _search.text),
      );
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _openUserSheet([AdminUser? user]) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<UserBloc>(),
        child: _UserFormSheet(user: user),
      ),
    );
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
              primaryColor: _kAmber.withOpacity(0.09),
              secondaryColor: Colors.transparent,
            ),
          ),
          const Positioned.fill(child: IspmMeshGrid()),

          SafeArea(
            bottom: false,
            child: BlocConsumer<UserBloc, UserState>(
              // ✅ Listener : saveDone → ferme le sheet automatiquement
              listener: (context, state) {
                state.whenOrNull(
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          message,
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
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
                // Computed depuis l'état loaded
                final profCount =
                    state.whenOrNull(
                      loaded: (users, filtered, filter, query) =>
                          users.where((u) => u.isProfessor).length,
                    ) ??
                    0;
                final supCount =
                    state.whenOrNull(
                      loaded: (users, filtered, filter, query) =>
                          users.where((u) => u.isSupervisor).length,
                    ) ??
                    0;

                return Column(
                  children: [
                    AdminAppBar(
                      title: 'Utilisateurs',
                      subtitle: '$profCount profs · $supCount superviseurs',
                      onBack: () => Navigator.pop(context),
                      action: ActionBtn(
                        icon: Icons.person_add_rounded,
                        onTap: () => _openUserSheet(null),
                      ),
                    ),

                    _SearchBar(controller: _search),

                    _FilterChips(
                      selected: _filter,
                      onSelect: (f) {
                        setState(() => _filter = f);
                        context.read<UserBloc>().add(
                          UserEvent.filterChanged(
                            filter: f,
                            query: _search.text,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // ✅ Builder avec state.when()
                    Expanded(child: _buildBody(context, state)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserState state) => state.when(
    initial: () => const Center(
      child: CircularProgressIndicator(color: _kAmber, strokeWidth: 2.5),
    ),
    loading: () => const Center(
      child: CircularProgressIndicator(color: _kAmber, strokeWidth: 2.5),
    ),
    saving: () => const Center(
      child: CircularProgressIndicator(color: _kAmber, strokeWidth: 2.5),
    ),
    saveDone: () => const SizedBox.shrink(),
    error: (message) => AdminErrorPanel(
      message: message,
      onRetry: () => context.read<UserBloc>().add(const UserEvent.load()),
      accent: _kAmber,
    ),
    loaded: (users, filtered, filter, query) => filtered.isEmpty
        ? const AdminEmptyPanel(accent: _kAmber)
        : _UserList(
            users: filtered,
            animCtrl: _animCtrl,
            onEdit: _openUserSheet,
            // ✅ Event freezed
            onToggle: (user) =>
                context.read<UserBloc>().add(UserEvent.toggle(user.id)),
          ),
  );
}

// ── Liste ─────────────────────────────────────────────────────────────────────

class _UserList extends StatelessWidget {
  final List<AdminUser> users;
  final AnimationController animCtrl;
  final void Function(AdminUser) onEdit;
  final void Function(AdminUser) onToggle;
  const _UserList({
    required this.users,
    required this.animCtrl,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
    physics: const BouncingScrollPhysics(),
    itemCount: users.length,
    itemBuilder: (_, i) {
      final u = users[i];
      final start = (0.08 * i).clamp(0.0, 0.7);
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animCtrl,
          curve: Interval(start, 1.0, curve: Curves.easeOut),
        ),
        child: _UserCard(user: u, onEdit: onEdit, onToggle: onToggle),
      );
    },
  );
}

class _UserCard extends StatelessWidget {
  final AdminUser user;
  final void Function(AdminUser) onEdit;
  final void Function(AdminUser) onToggle;
  const _UserCard({
    required this.user,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ roleColor resté dans la présentation (entity ne l'a plus)
    final roleColor = user.isProfessor ? ISPMColors.green : _kBlue;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: user.isActive
            ? ISPMColors.grey900
            : ISPMColors.grey900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: user.isActive
              ? ISPMColors.white.withOpacity(0.06)
              : ISPMColors.error.withOpacity(0.20),
        ),
      ),
      child: Row(
        children: [
          Opacity(
            opacity: user.isActive ? 1.0 : 0.45,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: roleColor.withOpacity(0.13),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: roleColor.withOpacity(0.30)),
              ),
              child: Center(
                child: Text(
                  user.initial,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: roleColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Opacity(
              opacity: user.isActive ? 1.0 : 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ISPMColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: ISPMColors.white.withOpacity(0.38),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _RolePill(label: user.roleLabel, color: roleColor),
                      if (!user.isActive) ...[
                        const SizedBox(width: 6),
                        const _RolePill(
                          label: 'Désactivé',
                          color: ISPMColors.error,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _IconBtn(
                icon: Icons.edit_rounded,
                color: _kAmber,
                onTap: () => onEdit(user),
              ),
              const SizedBox(height: 6),
              _IconBtn(
                icon: user.isActive
                    ? Icons.block_rounded
                    : Icons.check_circle_rounded,
                color: user.isActive ? ISPMColors.error : ISPMColors.green,
                onTap: () => onToggle(user),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Formulaire (BottomSheet) ──────────────────────────────────────────────────

class _UserFormSheet extends StatefulWidget {
  final AdminUser? user;
  const _UserFormSheet({this.user});

  @override
  State<_UserFormSheet> createState() => _UserFormSheetState();
}

class _UserFormSheetState extends State<_UserFormSheet> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  String _role = 'professor';
  bool _showErrors = false;

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _firstName.text = widget.user!.firstName;
      _lastName.text = widget.user!.lastName;
      _email.text = widget.user!.email;
      _role = widget.user!.role;
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _showErrors = true);
    if (_firstName.text.isEmpty ||
        _lastName.text.isEmpty ||
        _email.text.isEmpty)
      return;
    // ✅ Event freezed
    context.read<UserBloc>().add(
      UserEvent.save(
        id: widget.user?.id,
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        role: _role,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<UserBloc, UserState>(
      listenWhen: (prev, curr) =>
          curr.whenOrNull(saveDone: () => true, error: (_) => true) != null,
      listener: (context, state) {
        state.whenOrNull(
          saveDone: () => Navigator.pop(context),
          error: (message) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: ISPMColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
      builder: (context, state) {
        // ✅ isLoading depuis l'état freezed
        final isLoading = state.whenOrNull(saving: () => true) ?? false;

        return Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
          decoration: const BoxDecoration(
            color: ISPMColors.grey900,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ISPMColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isEdit ? 'Modifier l\'utilisateur' : 'Nouvel utilisateur',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ISPMColors.white,
                ),
              ),
              const SizedBox(height: 20),
              IspmTextField(
                controller: _firstName,
                label: 'Prénom',
                prefixIcon: Icons.person_outline_rounded,
                showError: _showErrors,
                errorText: 'Requis',
              ),
              IspmTextField(
                controller: _lastName,
                label: 'Nom',
                prefixIcon: Icons.person_outline_rounded,
                showError: _showErrors,
                errorText: 'Requis',
              ),
              IspmTextField(
                controller: _email,
                label: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                showError: _showErrors,
                errorText: 'Requis',
              ),
              const SizedBox(height: 4),
              Text(
                'RÔLE',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: ISPMColors.white.withOpacity(0.45),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _RoleToggle(
                    label: 'Professeur',
                    value: 'professor',
                    selected: _role,
                    accent: ISPMColors.green,
                    onSelect: (v) => setState(() => _role = v),
                  ),
                  const SizedBox(width: 10),
                  _RoleToggle(
                    label: 'Superviseur',
                    value: 'supervisor',
                    selected: _role,
                    accent: _kBlue,
                    onSelect: (v) => setState(() => _role = v),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              IspmButton(
                text: _isEdit ? 'Enregistrer' : 'Créer le compte',
                onPressed: isLoading ? null : _submit,
                isLoading: isLoading,
                icon: _isEdit ? Icons.save_rounded : Icons.person_add_rounded,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Widgets locaux ────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
    child: Container(
      height: 44,
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: ISPMColors.white.withOpacity(0.07)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: ISPMColors.white,
        ),
        cursorColor: _kAmber,
        decoration: InputDecoration(
          hintText: 'Rechercher un utilisateur…',
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: ISPMColors.white.withOpacity(0.30),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 18,
            color: ISPMColors.white.withOpacity(0.40),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    ),
  );
}

class _FilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _FilterChips({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    child: Row(
      children: [
        _Chip(
          label: 'Tous',
          value: 'all',
          selected: selected,
          onSelect: onSelect,
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Professeurs',
          value: 'professor',
          selected: selected,
          onSelect: onSelect,
          color: ISPMColors.green,
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Superviseurs',
          value: 'supervisor',
          selected: selected,
          onSelect: onSelect,
          color: _kBlue,
        ),
      ],
    ),
  );
}

class _Chip extends StatelessWidget {
  final String label, value, selected;
  final ValueChanged<String> onSelect;
  final Color color;
  const _Chip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelect,
    this.color = _kAmber,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = value == selected;
    return GestureDetector(
      onTap: () => onSelect(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : ISPMColors.grey900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? color.withOpacity(0.45)
                : ISPMColors.white.withOpacity(0.06),
            width: isActive ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? color : ISPMColors.white.withOpacity(0.45),
          ),
        ),
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  final String label;
  final Color color;
  const _RolePill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: color.withOpacity(0.13),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.withOpacity(0.28)),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    ),
  );
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Icon(icon, size: 15, color: color),
    ),
  );
}

class _RoleToggle extends StatelessWidget {
  final String label, value, selected;
  final Color accent;
  final ValueChanged<String> onSelect;
  const _RoleToggle({
    required this.label,
    required this.value,
    required this.selected,
    required this.accent,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = value == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isActive ? accent.withOpacity(0.13) : ISPMColors.grey800,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? accent.withOpacity(0.45)
                  : ISPMColors.white.withOpacity(0.07),
              width: isActive ? 1.5 : 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? accent : ISPMColors.white.withOpacity(0.45),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
