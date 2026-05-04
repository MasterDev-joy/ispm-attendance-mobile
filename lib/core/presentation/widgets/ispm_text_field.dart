// lib/core/presentation/widgets/ispm_text_field.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class IspmTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool showError;
  final String? errorText;

  const IspmTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.showError = false,
    this.errorText,
  });

  @override
  State<IspmTextField> createState() => _IspmTextFieldState();
}

class _IspmTextFieldState extends State<IspmTextField>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  late final AnimationController _lineCtrl;
  late final Animation<double> _lineAnim;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _lineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _lineAnim = CurvedAnimation(parent: _lineCtrl, curve: Curves.easeOut);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) {
      _lineCtrl.forward();
    } else {
      _lineCtrl.reverse();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _lineCtrl.dispose();
    super.dispose();
  }

  // Vrai si le champ est vide ET qu'on demande d'afficher l'erreur
  bool get _hasError =>
      widget.showError && widget.controller.text.trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    final borderColor = _hasError
        ? ISPMColors.error
        : _isFocused
        ? ISPMColors.green
        : Colors.white.withOpacity(0.1);

    final bgColor = _hasError
        ? ISPMColors.error.withOpacity(0.06)
        : _isFocused
        ? ISPMColors.green.withOpacity(0.07)
        : Colors.white.withOpacity(0.04);


    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label flottant animé
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: _isFocused
                  ? ISPMColors.green
                  : ISPMColors.grey400.withOpacity(0.7),
            ),
            child: Text(widget.label.toUpperCase()),
          ),
          const SizedBox(height: 6),

          // Container input avec animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: borderColor,
                width: (_isFocused || _hasError) ? 1.5 : 1.0,
              ),
              boxShadow: _hasError
                  ? [
                BoxShadow(
                  color: ISPMColors.error.withOpacity(0.12),
                  blurRadius: 0,
                  spreadRadius: 3,
                )
              ]
                  : _isFocused
                  ? [
                BoxShadow(
                  color: ISPMColors.green.withOpacity(0.14),
                  blurRadius: 0,
                  spreadRadius: 3,
                )
              ]
                  : [],
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.isPassword,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              cursorColor: ISPMColors.green,
              decoration: InputDecoration(
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                prefixIcon: Icon(
                  widget.prefixIcon,
                  size: 18,
                  color: _isFocused
                      ? ISPMColors.green
                      : Colors.white.withOpacity(0.3),
                ),
                suffixIcon: widget.suffixIcon,
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: _isFocused
                      ? ISPMColors.green
                      : Colors.white.withOpacity(0.22),
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          // Barre verte animée (slide depuis la gauche au focus)
          const SizedBox(height: 4),
          AnimatedBuilder(
            animation: _lineAnim,
            builder: (_, __) => FractionallySizedBox(
              widthFactor: _hasError ? 1.0 : _lineAnim.value,
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                decoration: BoxDecoration(
                  color: _hasError ? ISPMColors.error : ISPMColors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Message d'erreur qui apparaît/disparaît avec AnimatedSize
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: _hasError && widget.errorText != null
                ? Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 12,
                    color: ISPMColors.error.withOpacity(0.85),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.errorText!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: ISPMColors.error.withOpacity(0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}