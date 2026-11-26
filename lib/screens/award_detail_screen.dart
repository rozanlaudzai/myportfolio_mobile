import 'package:flutter/material.dart';
import 'package:myportfolio_mobile/models/award.dart';

class AwardDetailScreen extends StatelessWidget {
  const AwardDetailScreen({required this.award, super.key});

  final Award award;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(award.title)),
      body: ListView(
        children: [
          ListTile(title: const Text('Title'), subtitle: Text(award.title)),
          ListTile(title: const Text('Issuer'), subtitle: Text(award.issuer)),
          ListTile(
            title: const Text('Award date'),
            subtitle: Text(award.awardedAt),
          ),
          ListTile(
            title: const Text('Description'),
            subtitle: Text(award.description),
          ),
          ListTile(
            leading: Icon(award.isStarred ? Icons.star : Icons.star_outline),
            title: Text('Stars (${award.starCount})'),
            subtitle: Text(
              award.starredByNames.isEmpty ? 'None' : award.starredByNames,
            ),
          ),
          if (award.id case final id?)
            ListTile(
              title: const Text('Award ID'),
              subtitle: SelectableText(id),
            ),
        ],
      ),
    );
  }
}
