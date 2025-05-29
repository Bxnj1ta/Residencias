import 'package:flutter/material.dart';

class ReintentarContainer extends StatelessWidget {
  final String? textError;
  final String? error;
  final VoidCallback? onRetry;

  const ReintentarContainer({
    super.key,
    this.textError,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$textError: ${error ?? "Desconocido"}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}