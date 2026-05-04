// lib/features/admin/presentation/pages/users_page.dart
//
// Page Gestion des utilisateurs — Admin uniquement.
// Affiche la liste des professeurs et superviseurs.
// Permet : créer · modifier · désactiver un compte.
// Appels API réels via AuthLocalDao pour le token.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../../core/presentation/widgets/ispm_text_field.dart';
import '../../../../core/presentation/widgets/ispm_button.dart';

const _kAmber = Color(0xFFBA7517);
const _kBlue  = Color(0xFF378ADD);

// ── Modèle utilisateur admin ──────────────────────────────────────────────────

class _AdminUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final bool   isActive;

  const _AdminUser({
    required this.id, required this.firstName, required this.lastName,
    required this.email, required this.role, required this.isActive,
  });

  String get fullName => '$firstName $lastName';
  String get initial  =>
      firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';

  bool get isProfessor  => role.toLowerCase() == 'professor';
  bool get isSupervisor =>
      role.toLowerCase() == 'supervisor' ||
          role.toLowerCase() == 'superviseur';

  Color roleColor(BuildContext ctx) =>
      isProfessor ? ISPMColors.green : _kBlue;

  String get roleLabel =>
      isProfessor ? 'Professeur' : 'Superviseur';

  factory _AdminUser.fromJson(Map<String, dynamic> j) => _AdminUser(
    id:        j['id'] ?? '',
    firstName: j['firstName'] ?? '',
    lastName:  j['lastName']  ?? '',
    email:     j['email']     ?? '',
    role:      j['role']      ?? 'professor',
    isActive:  j['isActive']  ?? true,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage>
    with SingleTickerProviderStateMixin {

  List<_AdminUser> _users    = [];
  List<_AdminUser> _filtered = [];
  bool   _loading = true;
  String _error   = '';
  String _filter  = 'all'; // 'all' | 'professor' | 'supervisor'
  final _search   = TextEditingController();
  late AnimationController _animCtrl;

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 600))..forward();
    _loadUsers();
    _search.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _search.dispose();
    super.dispose();
  }

  // ── API ────────────────────────────────────────────────────────────────────

  Future<String?> get _token => _storage.read(key: 'jwt_token');

  Future<void> _loadUsers() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final token = await _token;
      final res   = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/admin/users'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        _users = data.map((j) => _AdminUser.fromJson(j)).toList();
        _applyFilter();
        setState(() => _loading = false);
      } else {
        setState(() {
          _error   = 'Erreur serveur (${res.statusCode})';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _toggleActive(_AdminUser user) async {
    try {
      final token = await _token;
      await http.patch(
        Uri.parse('${AppConfig.baseUrl}/api/admin/users/${user.id}/toggle'),
        headers: {'Authorization': 'Bearer $token'},
      );
      _loadUsers();
    } catch (_) {}
  }

  void _applyFilter() {
    final q = _search.text.toLowerCase();
    setState(() {
      _filtered = _users.where((u) {
        final matchRole = _filter == 'all' ||
            (_filter == 'professor' && u.isProfessor) ||
            (_filter == 'supervisor' && u.isSupervisor);
        final matchSearch = q.isEmpty ||
            u.fullName.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q);
        return matchRole && matchSearch;
      }).toList();
    });
  }

  void _openCreateSheet() => _openUserSheet(null);
  void _openEditSheet(_AdminUser u) => _openUserSheet(u);

  Future<void> _openUserSheet(_AdminUser? user) async {

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UserFormSheet(user: user, token: _token as String),
    );
    if (result == true) _loadUsers();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final professors  = _users.where((u) => u.isProfessor).length;
    final supervisors = _users.where((u) => u.isSupervisor).length;

    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(
        children: [
          Positioned(top: -80, right: -60,
              child: IspmGlowBlob.circle(radius: 190,
                  primaryColor: _kAmber.withOpacity(0.09),
                  secondaryColor: Colors.transparent)),
          const Positioned.fill(child: IspmMeshGrid()),

          SafeArea(
            bottom: false,
            child: Column(children: [
              // AppBar
              AdminAppBar(
                title: 'Utilisateurs',
                subtitle: '$professors profs · $supervisors superviseurs',
                onBack: () => Navigator.pop(context),
                action: ActionBtn(
                  icon: Icons.person_add_rounded,
                  onTap: _openCreateSheet,
                ),
              ),

              // Recherche
              _SearchBar(controller: _search),

              // Filtres
              _FilterChips(
                selected: _filter,
                onSelect: (f) { setState(() => _filter = f); _applyFilter(); },
              ),

              const SizedBox(height: 8),

              // Liste
              Expanded(child: _loading
                  ? const Center(child: CircularProgressIndicator(
                  color: _kAmber, strokeWidth: 2.5))
                  : _error.isNotEmpty
                  ? ErrorPanel(message: _error, onRetry: _loadUsers,
                  accent: _kAmber)
                  : _filtered.isEmpty
                  ? EmptyPanel(accent: _kAmber)
                  : _UserList(
                users:      _filtered,
                animCtrl:   _animCtrl,
                onEdit:     _openEditSheet,
                onToggle:   _toggleActive,
              ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Liste utilisateurs ────────────────────────────────────────────────────────

class _UserList extends StatelessWidget {
  final List<_AdminUser> users;
  final AnimationController animCtrl;
  final void Function(_AdminUser) onEdit;
  final void Function(_AdminUser) onToggle;
  const _UserList({required this.users, required this.animCtrl,
    required this.onEdit, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
      physics: const BouncingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (_, i) {
        final u     = users[i];
        final start = (0.08 * i).clamp(0.0, 0.7);
        return FadeTransition(
          opacity: CurvedAnimation(parent: animCtrl,
              curve: Interval(start, 1.0, curve: Curves.easeOut)),
          child: _UserCard(user: u, onEdit: onEdit, onToggle: onToggle),
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final _AdminUser user;
  final void Function(_AdminUser) onEdit;
  final void Function(_AdminUser) onToggle;
  const _UserCard({required this.user, required this.onEdit,
    required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final roleColor = user.isProfessor ? ISPMColors.green : _kBlue;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: user.isActive ? ISPMColors.grey900 : ISPMColors.grey900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: user.isActive
                ? ISPMColors.white.withOpacity(0.06)
                : ISPMColors.error.withOpacity(0.20)),
      ),
      child: Row(children: [
        // Avatar
        Opacity(opacity: user.isActive ? 1.0 : 0.45,
            child: Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                    color: roleColor.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: roleColor.withOpacity(0.30))),
                child: Center(child: Text(user.initial,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 18,
                        fontWeight: FontWeight.w700, color: roleColor))))),

        const SizedBox(width: 13),

        // Infos
        Expanded(child: Opacity(opacity: user.isActive ? 1.0 : 0.55,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.fullName,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14,
                          fontWeight: FontWeight.w600, color: ISPMColors.white)),
                  const SizedBox(height: 2),
                  Text(user.email,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
                          color: ISPMColors.white.withOpacity(0.38)),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(children: [
                    _RolePill(label: user.roleLabel, color: roleColor),
                    if (!user.isActive) ...[
                      const SizedBox(width: 6),
                      _RolePill(label: 'Désactivé', color: ISPMColors.error),
                    ],
                  ]),
                ]))),

        // Actions
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        ]),
      ]),
    );
  }
}

// ── Formulaire utilisateur (BottomSheet) ──────────────────────────────────────

class _UserFormSheet extends StatefulWidget {
  final _AdminUser? user;
  final String token;
  const _UserFormSheet({this.user, required this.token});

  @override
  State<_UserFormSheet> createState() => _UserFormSheetState();
}

class _UserFormSheetState extends State<_UserFormSheet> {
  final _firstName = TextEditingController();
  final _lastName  = TextEditingController();
  final _email     = TextEditingController();
  String _role     = 'professor';
  bool _loading    = false;
  bool _showErrors = false;

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _firstName.text = widget.user!.firstName;
      _lastName.text  = widget.user!.lastName;
      _email.text     = widget.user!.email;
      _role           = widget.user!.role;
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _showErrors = true; });
    if (_firstName.text.isEmpty || _lastName.text.isEmpty ||
        _email.text.isEmpty) return;

    setState(() => _loading = true);
    try {
      final body = jsonEncode({
        'firstName': _firstName.text.trim(),
        'lastName':  _lastName.text.trim(),
        'email':     _email.text.trim(),
        'role':      _role,
      });
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };
      final http.Response res;
      if (_isEdit) {
        res = await http.put(
            Uri.parse('${AppConfig.baseUrl}/api/admin/users/${widget.user!.id}'),
            headers: headers, body: body);
      } else {
        res = await http.post(
            Uri.parse('${AppConfig.baseUrl}/api/admin/users'),
            headers: headers, body: body);
      }
      if (mounted) {
        if (res.statusCode == 200 || res.statusCode == 201) {
          Navigator.pop(context, true);
        } else {
          final data = jsonDecode(res.body);
          _showSnack(data['error'] ?? 'Erreur serveur');
        }
      }
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
      backgroundColor: ISPMColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      decoration: const BoxDecoration(
          color: ISPMColors.grey900,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Handle
            Center(child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                    color: ISPMColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),

            Text(_isEdit ? 'Modifier l\'utilisateur' : 'Nouvel utilisateur',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 18,
                    fontWeight: FontWeight.w700, color: ISPMColors.white)),
            const SizedBox(height: 20),

            IspmTextField(
                controller: _firstName, label: 'Prénom',
                prefixIcon: Icons.person_outline_rounded,
                showError: _showErrors, errorText: 'Requis'),
            IspmTextField(
                controller: _lastName, label: 'Nom',
                prefixIcon: Icons.person_outline_rounded,
                showError: _showErrors, errorText: 'Requis'),
            IspmTextField(
                controller: _email, label: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                showError: _showErrors, errorText: 'Requis'),

            // Sélecteur rôle
            const SizedBox(height: 4),
            Text('RÔLE', style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                fontWeight: FontWeight.w600, letterSpacing: 0.8,
                color: ISPMColors.white.withOpacity(0.45))),
            const SizedBox(height: 8),
            Row(children: [
              _RoleToggle(label: 'Professeur', value: 'professor',
                  selected: _role, accent: ISPMColors.green,
                  onSelect: (v) => setState(() => _role = v)),
              const SizedBox(width: 10),
              _RoleToggle(label: 'Superviseur', value: 'supervisor',
                  selected: _role, accent: _kBlue,
                  onSelect: (v) => setState(() => _role = v)),
            ]),

            const SizedBox(height: 24),
            IspmButton(
                text: _isEdit ? 'Enregistrer' : 'Créer le compte',
                onPressed: _submit, isLoading: _loading,
                icon: _isEdit ? Icons.save_rounded : Icons.person_add_rounded),
          ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Widgets partagés Admin pages
// ─────────────────────────────────────────────────────────────────────────────

class AdminAppBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final Widget? action;
  const AdminAppBar({super.key, required this.title, required this.subtitle,
    required this.onBack, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(children: [
        GestureDetector(
            onTap: onBack,
            child: Container(width: 40, height: 40,
                decoration: BoxDecoration(
                    color: ISPMColors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ISPMColors.white.withOpacity(0.09))),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 15, color: ISPMColors.white))),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'Poppins',
                  fontSize: 17, fontWeight: FontWeight.w700,
                  color: ISPMColors.white)),
              Text(subtitle, style: TextStyle(fontFamily: 'Poppins',
                  fontSize: 11, color: ISPMColors.white.withOpacity(0.38))),
            ])),
        if (action != null) action!,
      ]),
    );
  }
}

class ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const ActionBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(width: 40, height: 40,
            decoration: BoxDecoration(
                color: _kAmber.withOpacity(0.13),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kAmber.withOpacity(0.35))),
            child: Icon(icon, size: 18, color: _kAmber)));
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
            color: ISPMColors.grey900, borderRadius: BorderRadius.circular(13),
            border: Border.all(color: ISPMColors.white.withOpacity(0.07))),
        child: TextField(
          controller: controller,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13,
              color: ISPMColors.white),
          cursorColor: _kAmber,
          decoration: InputDecoration(
              hintText: 'Rechercher un utilisateur…',
              hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                  color: ISPMColors.white.withOpacity(0.30)),
              prefixIcon: Icon(Icons.search_rounded,
                  size: 18, color: ISPMColors.white.withOpacity(0.40)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12)),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _FilterChips({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(children: [
        _Chip(label: 'Tous', value: 'all', selected: selected,
            onSelect: onSelect),
        const SizedBox(width: 8),
        _Chip(label: 'Professeurs', value: 'professor', selected: selected,
            onSelect: onSelect, color: ISPMColors.green),
        const SizedBox(width: 8),
        _Chip(label: 'Superviseurs', value: 'supervisor', selected: selected,
            onSelect: onSelect, color: _kBlue),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label, value, selected;
  final ValueChanged<String> onSelect;
  final Color color;
  const _Chip({required this.label, required this.value,
    required this.selected, required this.onSelect,
    this.color = _kAmber});

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
                  color: isActive ? color.withOpacity(0.45) : ISPMColors.white.withOpacity(0.06),
                  width: isActive ? 1.5 : 1.0)),
          child: Text(label,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? color : ISPMColors.white.withOpacity(0.45)))),
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
      decoration: BoxDecoration(color: color.withOpacity(0.13),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.28))),
      child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
          fontWeight: FontWeight.w600, color: color)));
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(width: 32, height: 32,
          decoration: BoxDecoration(
              color: color.withOpacity(0.11),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: color.withOpacity(0.25))),
          child: Icon(icon, size: 15, color: color)));
}

class _RoleToggle extends StatelessWidget {
  final String label, value, selected;
  final Color accent;
  final ValueChanged<String> onSelect;
  const _RoleToggle({required this.label, required this.value,
    required this.selected, required this.accent,
    required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isActive = value == selected;
    return Expanded(child: GestureDetector(
      onTap: () => onSelect(value),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
              color: isActive ? accent.withOpacity(0.13) : ISPMColors.grey800,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isActive ? accent.withOpacity(0.45) : ISPMColors.white.withOpacity(0.07),
                  width: isActive ? 1.5 : 1.0)),
          child: Center(child: Text(label,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? accent : ISPMColors.white.withOpacity(0.45))))),
    ));
  }
}

class ErrorPanel extends StatelessWidget {
  final String message;
  final Color accent;
  final VoidCallback onRetry;
  const ErrorPanel({super.key, required this.message, required this.accent,
    required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.wifi_off_rounded, size: 36, color: ISPMColors.error),
    const SizedBox(height: 12),
    Text(message, textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
            color: ISPMColors.white.withOpacity(0.40))),
    const SizedBox(height: 16),
    GestureDetector(onTap: onRetry,
        child: Container(padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: accent.withOpacity(0.13),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: accent.withOpacity(0.35))),
            child: Text('Réessayer', style: TextStyle(fontFamily: 'Poppins',
                fontSize: 13, fontWeight: FontWeight.w600, color: accent)))),
  ]));
}

class EmptyPanel extends StatelessWidget {
  final Color accent;
  const EmptyPanel({required this.accent});

  @override
  Widget build(BuildContext context) => Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 64, height: 64,
        decoration: BoxDecoration(color: accent.withOpacity(0.10),
            shape: BoxShape.circle,
            border: Border.all(color: accent.withOpacity(0.25))),
        child: Icon(Icons.group_outlined, size: 28, color: accent)),
    const SizedBox(height: 16),
    Text('Aucun utilisateur trouvé',
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 15,
            fontWeight: FontWeight.w600, color: ISPMColors.white)),
  ]));
}