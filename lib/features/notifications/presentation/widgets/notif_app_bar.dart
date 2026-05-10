// lib/features/notifications/presentation/widgets/notif_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../blocs/notification_bloc.dart';

class NotifAppBar extends StatelessWidget {
  final Color accent;
  final VoidCallback onBack;

  const NotifAppBar({super.key, required this.accent, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ISPMColors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ISPMColors.white.withOpacity(0.09)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: ISPMColors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: ISPMColors.white,
                  ),
                ),
                Text(
                  'Vos alertes & rappels',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Color(0x66FFFFFF),
                  ),
                ),
              ],
            ),
          ),

          // Bouton "Tout lire" conditionnel
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (ctx, state) {
              final unreadCount = state.unreadCount;
              if (unreadCount > 0) {
                return GestureDetector(
                  onTap: () {
                    ctx.read<NotificationBloc>().add(
                      const NotificationEvent.markAllRead(),
                    );
                    HapticFeedback.selectionClick();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: accent.withOpacity(0.30)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.done_all_rounded, size: 14, color: accent),
                        const SizedBox(width: 5),
                        Text(
                          'Tout lire',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox(width: 40);
            },
          ),
        ],
      ),
    );
  }
}
