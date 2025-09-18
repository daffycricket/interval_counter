import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// NOTE: replace with your actual HomeScreen import when generated.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Démarrage rapide')));
}

void main() {
  testWidgets('renders key labels from design', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.text('Démarrage rapide'), findsOneWidget);
  });
}
