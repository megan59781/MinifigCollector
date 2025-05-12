import 'package:flutter/material.dart';

class CrossCheckboxListTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Widget title;
  final Widget? subtitle;

  const CrossCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: value ? Colors.red : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: value ? Colors.red : const Color.fromARGB(255, 29, 28, 28),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: value
              ? const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                )
              : null,
        ),
      ),
      title: title,
      subtitle: subtitle,
      onTap: () => onChanged(!value),
    );
  }
}
