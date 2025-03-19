import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // TODO: 이후 업데이트에 지원
          // const Text(
          //   '계정 정보',
          //   style: TextStyle(fontSize: 18),
          // ),
          // ListTile(
          //   leading: const Icon(Icons.not_started_outlined),
          //   title: const Text('폴 시작한지 100일'),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.lock),
          //   title: const Text('비밀번호 변경'),
          //   onTap: () {},
          // ),
          // const Divider(),
          // const Text(
          //   '환경 설정',
          //   style: TextStyle(fontSize: 18),
          // ),
          // ListTile(
          //   leading: const Icon(Icons.language),
          //   title: const Text('언어'),
          //   trailing: DropdownButton<String>(
          //     value: 'Korean',
          //     items: const [
          //       DropdownMenuItem(value: 'English', child: Text('English')),
          //       DropdownMenuItem(value: 'Korean', child: Text('한국어')),
          //     ],
          //     onChanged: (value) {},
          //   ),
          // ),
          // const Divider(),
          // const Text(
          //   '알림',
          //   style: TextStyle(fontSize: 18),
          // ),
          // SwitchListTile(
          //   value: true,
          //   onChanged: (value) {},
          //   title: const Text('알림 켜기'),
          // ),
          // const Divider(),
          const Text('About', style: TextStyle(fontSize: 18)),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('앱 버전: ...'),
                );
              }
              return ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text('앱 버전: ${snapshot.data?.version}'),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text('의견 보내기'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('라이센스'),
            onTap: () {
              showLicensePage(context: context);
            },
          ),
        ],
      ),
    );
  }
}
