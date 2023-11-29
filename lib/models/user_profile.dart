/// Model class for user profile
class UserProfile {
  const UserProfile({
    required this.id,
    required this.nickname,
    required this.email,
  });

  final String id;
  final String nickname;
  final String email;

  /// Convert from json to UserProfile
  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      nickname: json['nickname'],
      email: json['email'] as String,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, nickname: $nickname, email: $email)';
  }
}
