import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:flutter/material.dart';

class EditPhoneNumberDialog extends StatelessWidget {
  const EditPhoneNumberDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: RegisterPhoneWidget(
                credentialVerificationType: CredentialVerificationType.EDIT,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.newPhoneNumber,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          ),
        ],
      ),
    );
  }
}

/// Show the edit phone number dialog
Future<void> showEditPhoneNumberDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => const EditPhoneNumberDialog(),
  );
}
