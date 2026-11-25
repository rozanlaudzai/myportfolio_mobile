import 'package:flutter/material.dart';
import 'package:myportfolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (project.projectImageUrl.isNotEmpty)
            Image.network(
              project.projectImageUrl,
              height: 240,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Text('Image unavailable.'),
            ),
          Text(project.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(project.techStack),
          const SizedBox(height: 12),
          Text(project.description),
          if (project.projectUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            SelectableText(project.projectUrl),
          ],
        ],
      ),
    );
  }
}
