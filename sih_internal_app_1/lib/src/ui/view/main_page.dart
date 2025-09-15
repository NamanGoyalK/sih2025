import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SIH Internal App'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to the App',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'This app features beautiful themes inspired by Indian flag colors.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Primary Action'),
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text Button'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined Button'),
                ),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.star),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'This is a card showcasing the theme.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Chip(
                  label: Text('Sample Chip'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Switch: '),
                    Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Checkbox: '),
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Text('Radio: '),
                    Radio<int>(
                      value: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Slider:'),
                Slider(
                  value: 0.5,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                const Text('Progress Indicators:'),
                const SizedBox(height: 10),
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                const LinearProgressIndicator(),
                const SizedBox(height: 20),
                const ListTile(
                  leading: Icon(Icons.list),
                  title: Text('List Tile'),
                  subtitle: Text('Subtitle for list tile'),
                ),
                ExpansionTile(
                  title: const Text('Expansion Tile'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Expanded content here.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                Text(
                  'Display Large',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  'Display Medium',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  'Display Small',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  'Headline Large',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'Headline Medium',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Headline Small',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Title Large',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Title Medium',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Title Small',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'Body Large',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Body Medium',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Body Small',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Label Large',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  'Label Medium',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  'Label Small',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
