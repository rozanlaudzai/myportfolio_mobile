import 'package:flutter/material.dart';
import 'package:myportfolio_mobile/models/award.dart';
import 'package:myportfolio_mobile/screens/award_detail_screen.dart';
import 'package:myportfolio_mobile/screens/award_form.dart';
import 'package:myportfolio_mobile/services/api_client.dart';
import 'package:myportfolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class AwardListScreen extends StatefulWidget {
  const AwardListScreen({super.key});

  @override
  State<AwardListScreen> createState() => _AwardListScreenState();
}

class _AwardListScreenState extends State<AwardListScreen> {
  late Future<List<Award>> _awards;

  @override
  void initState() {
    super.initState();
    _awards = context.read<ApiClient>().getAwards();
  }

  Future<void> _reload() async {
    final request = context.read<ApiClient>().getAwards();
    setState(() {
      _awards = request;
    });
    try {
      await request;
    } catch (_) {
      // FutureBuilder presents the error and retry action.
    }
  }

  Future<void> _addAward() async {
    if (await openAwardForm(context) && mounted) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Awards')),
      drawer: LeftDrawer(onAwardCreated: _reload),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAward,
        tooltip: 'Add award',
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Award>>(
        future: _awards,
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Could not load awards.'),
                  TextButton(onPressed: _reload, child: const Text('Retry')),
                ],
              ),
            );
          }
          final awards = snapshot.data ?? const <Award>[];
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: awards.isEmpty ? 1 : awards.length,
              itemBuilder: (context, index) {
                if (awards.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No awards found.')),
                  );
                }
                final award = awards[index];
                return Card(
                  child: ListTile(
                    title: Text(award.title),
                    subtitle: Text('${award.issuer} • ${award.awardedAt}'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => AwardDetailScreen(award: award),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
