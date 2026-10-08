import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../utils/bat_trach_calculator.dart';

/// Dữ liệu gia chủ lưu trữ (Hồ sơ người dùng)
class UserProfile {
  final int birthYear;
  final int birthMonth;
  final int birthDay;
  final Gender gender;

  const UserProfile({
    required this.birthYear,
    this.birthMonth = 1,
    this.birthDay = 1,
    required this.gender,
  });

  UserProfile copyWith({
    int? birthYear,
    int? birthMonth,
    int? birthDay,
    Gender? gender,
  }) {
    return UserProfile(
      birthYear: birthYear ?? this.birthYear,
      birthMonth: birthMonth ?? this.birthMonth,
      birthDay: birthDay ?? this.birthDay,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toJson() => {
        'birthYear': birthYear,
        'birthMonth': birthMonth,
        'birthDay': birthDay,
        'gender': gender == Gender.female ? 'female' : 'male',
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      birthYear: json['birthYear'] as int? ?? 1990,
      birthMonth: json['birthMonth'] as int? ?? 1,
      birthDay: json['birthDay'] as int? ?? 1,
      gender: json['gender'] == 'female' ? Gender.female : Gender.male,
    );
  }
}

/// Dịch vụ lưu trữ cục bộ nhẹ, không cần phụ thuộc plugin cồng kềnh
/// Tự động hoạt động trên Mobile/Desktop qua JSON file trong app directory
class LocalStorageService {
  static const String _fileName = 'user_profile_prefs.json';
  static UserProfile? _cachedProfile;
  static bool _initialized = false;

  /// Khởi tạo và đọc dữ liệu đã lưu
  static Future<UserProfile?> loadUserProfile() async {
    if (_initialized && _cachedProfile != null) {
      return _cachedProfile;
    }

    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final data = jsonDecode(content) as Map<String, dynamic>;
          _cachedProfile = UserProfile.fromJson(data);
          _initialized = true;
          return _cachedProfile;
        }
      }
    } catch (e) {
      debugPrint('Error reading user profile from local storage: $e');
    }

    _initialized = true;
    return null;
  }

  /// Lưu thông tin gia chủ vào file cục bộ
  static Future<void> saveUserProfile(UserProfile profile) async {
    _cachedProfile = profile;
    try {
      final file = await _getFile();
      await file.writeAsString(jsonEncode(profile.toJson()), flush: true);
    } catch (e) {
      debugPrint('Error saving user profile to local storage: $e');
    }
  }

  static Future<File> _getFile() async {
    // Lưu vào thư mục dữ liệu cục bộ an toàn của app
    Directory directory;
    try {
      if (Platform.isAndroid) {
        final androidDataDir = Directory('/data/user/0/com.phongthuy.app/files');
        if (await androidDataDir.exists()) {
          directory = androidDataDir;
        } else {
          final fallbackDir = Directory('/data/data/com.phongthuy.app/files');
          if (await fallbackDir.exists()) {
            directory = fallbackDir;
          } else {
            directory = Directory.systemTemp;
          }
        }
      } else {
        directory = Directory.systemTemp;
      }
    } catch (_) {
      directory = Directory.systemTemp;
    }
    return File('${directory.path}/$_fileName');
  }
}
