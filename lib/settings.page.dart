import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('설정'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            '계정 정보',
            style: TextStyle(fontSize: 18),
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('폴 시작한지 100일'),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('비밀번호 변경'),
            onTap: () {},
          ),
          const Divider(),
          const Text(
            '환경 설정',
            style: TextStyle(fontSize: 18),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('테마'),
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
            title: const Text('언어'),
            trailing: DropdownButton<String>(
              value: 'Korean',
              items: const [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Korean', child: Text('한국어')),
              ],
              onChanged: (value) {},
            ),
          ),
          const Divider(),
          const Text(
            '알림',
            style: TextStyle(fontSize: 18),
          ),
          SwitchListTile(
            value: true,
            onChanged: (value) {},
            title: const Text('알림 켜기'),
          ),
          const Divider(),
          const Text('About', style: TextStyle(fontSize: 18)),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('앱 버전: 1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text('개발자 연락하기'),
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
