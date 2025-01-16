import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Account Info',
            style: TextStyle(fontSize: 18),
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('100 Days Since First Poling'),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {},
          ),
          const Divider(),
          const Text(
            'App Preferences',
            style: TextStyle(fontSize: 18),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Theme'),
            trailing: DropdownButton<String>(
              value: 'Light',
              items: const [
                DropdownMenuItem(value: 'Light', child: Text('Light')),
                DropdownMenuItem(value: 'Dark', child: Text('Dark')),
              ],
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: 'English',
              items: const [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Korean', child: Text('Korean')),
              ],
              onChanged: (value) {},
            ),
          ),
          const Divider(),
          const Text(
            'Notifications',
            style: TextStyle(fontSize: 18),
          ),
          SwitchListTile(
            value: true,
            onChanged: (value) {},
            title: const Text('Enable Notifications'),
          ),
          const Divider(),
          const Text('About', style: TextStyle(fontSize: 18)),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version: 1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text('Contact Support'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Licenses'),
            onTap: () {
              showLicensePage(context: context);
            },
          ),
        ],
      ),
    );
  }
}
