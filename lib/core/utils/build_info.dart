import 'package:package_info_plus/package_info_plus.dart';

class BuildInfo {
  static const String _commit = String.fromEnvironment('BUILD_COMMIT');

  static String get commit => _commit;

  static String? get commitCurto {
    if (_commit.isEmpty) return null;
    return _commit.length > 7 ? _commit.substring(0, 7) : _commit;
  }

  static Future<String> versaoInstalada() async {
    final info = await PackageInfo.fromPlatform();
    final versao = '${info.version} (${info.buildNumber})';
    final hash = commitCurto;
    if (hash == null) return versao;
    return 'Latest build ($hash) — $versao';
  }
}
