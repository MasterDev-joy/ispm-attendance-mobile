// lib/features/home/presentation/widgets/shared/home_bottom_nav.dart
//
// Barre de navigation inférieure dynamique.
// • Items configurables via List<NavItem>
// • Bouton Scanner surélevé (FAB-style) si isScanner = true
// • Couleur active paramétrable par rôle
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

// ── Modèle NavItem ────────────────────────────────────────────────────────────

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  /// Si true → rendu en bouton central surélevé (Scanner)
  final bool isScanner;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    this.isScanner = false,
  });
}

// ── Listes prédéfinies par rôle ───────────────────────────────────────────────

class HomeNavItems {
  static const professor = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Accueil',
      route: '/home',
    ),
    NavItem(
      icon: Icons.calendar_month_outlined,
      activeIcon: Icons.calendar_month_rounded,
      label: 'Emploi',
      route: '/schedule',
    ),
    NavItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
      label: 'Statistiques',
      route: '/stats',
    ),
    NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
      route: '/profile',
    ),
  ];

  static const supervisor = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Accueil',
      route: '/home',
    ),
    NavItem(
      icon: Icons.calendar_month_outlined,
      activeIcon: Icons.calendar_month_rounded,
      label: 'Emploi',
      route: '/schedule',
    ),
    NavItem(
      icon: Icons.qr_code_scanner_outlined,
      activeIcon: Icons.qr_code_scanner_rounded,
      label: 'Scanner',
      route: '/scanner',
      isScanner: true,
    ),
    NavItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
      label: 'Statistiques',
      route: '/stats',
    ),
    NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
      route: '/profile',
    ),
  ];

  static const admin = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Accueil',
      route: '/home',
    ),
    NavItem(
      icon: Icons.calendar_month_outlined,
      activeIcon: Icons.calendar_month_rounded,
      label: 'Cours',
      route: '/courses',
    ),
    NavItem(
      icon: Icons.group_outlined,
      activeIcon: Icons.group_rounded,
      label: 'Utilisateurs',
      route: '/users',
    ),
    NavItem(
      icon: Icons.insert_drive_file_outlined,
      activeIcon: Icons.insert_drive_file_rounded,
      label: 'Rapports',
      route: '/reports',
    ),
    NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
      route: '/profile',
    ),
  ];
}

// ── Widget principal ──────────────────────────────────────────────────────────

class HomeBottomNav extends StatelessWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  /// Couleur de l'élément actif
  final Color activeColor;

  const HomeBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    this.activeColor = ISPMColors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        border: const Border(
          top: BorderSide(color: Color(0xFF252525), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isActive = i == selectedIndex;

              if (item.isScanner) {
                return _ScannerButton(
                  isActive: isActive,
                  label: item.label,
                  onTap: () => onTap(i),
                );
              }

              return _NavButton(
                item: item,
                isActive: isActive,
                activeColor: activeColor,
                onTap: () => onTap(i),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ── Bouton standard ───────────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône avec switch animé
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                key: ValueKey(isActive),
                size: 21,
                color: isActive
                    ? activeColor
                    : ISPMColors.white.withOpacity(0.32),
              ),
            ),

            const SizedBox(height: 3),

            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? activeColor
                    : ISPMColors.white.withOpacity(0.32),
              ),
              child: Text(item.label, overflow: TextOverflow.ellipsis),
            ),

            const SizedBox(height: 3),

            // Indicateur actif
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: isActive ? 18 : 0,
              height: 2,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bouton Scanner surélevé ───────────────────────────────────────────────────

class _ScannerButton extends StatelessWidget {
  final bool isActive;
  final String label;
  final VoidCallback onTap;

  const _ScannerButton({
    required this.isActive,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton surélevé
            Transform.translate(
              offset: const Offset(0, -10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isActive
                      ? ISPMColors.green
                      : ISPMColors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isActive
                        ? ISPMColors.green
                        : ISPMColors.green.withOpacity(0.38),
                    width: 1.5,
                  ),
                  boxShadow: isActive
                      ? [
                    BoxShadow(
                      color: ISPMColors.green.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 3),
                    )
                  ]
                      : [
                    BoxShadow(
                      color: ISPMColors.green.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 22,
                  color: isActive ? ISPMColors.white : ISPMColors.green,
                ),
              ),
            ),

            // Label (repositionné à cause du Transform)
            Transform.translate(
              offset: const Offset(0, -10),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? ISPMColors.green
                      : ISPMColors.white.withOpacity(0.32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}