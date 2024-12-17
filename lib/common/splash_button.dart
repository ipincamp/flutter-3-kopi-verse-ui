import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashButton extends StatefulWidget {
  final String title;
  final Function() onPressed;

  const SplashButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  State<SplashButton> createState() => _SplashButtonState();
}

class _SplashButtonState extends State<SplashButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffC67C4E),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        widget.title,
        style: GoogleFonts.sora(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
