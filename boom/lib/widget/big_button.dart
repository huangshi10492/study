import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const BigButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 90.0,
        minWidth: 90.0,
        minHeight: 70,
      ),
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(height: 5),
            FittedBox(
              child: Text(label, maxLines: 1),
            ),
          ],
        ),
      ),
    );
  }
}
