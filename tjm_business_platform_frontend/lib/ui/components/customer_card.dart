import 'package:flutter/material.dart';
import 'package:tjm_business_platform_logic/core/model/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const CustomerCard({super.key, required this.customer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icono circular
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
              child: const Icon(
                Icons.person,
                color: Colors.blueAccent,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Información del cliente
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    customer.phoneNumber,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (customer.email != null && customer.email!.isNotEmpty)
                    Text(
                      customer.email!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
            // Botón de acción
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
