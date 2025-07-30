import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  const UserEntity({
    required this.id,
    this.email,
    this.displayName,
    this.photoURL,
    required this.emailVerified,
    this.creationTime,
    this.lastSignInTime,
  });

  factory UserEntity.fromFirebaseUser(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      creationTime: user.metadata.creationTime,
      lastSignInTime: user.metadata.lastSignInTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'creationTime': creationTime?.toIso8601String(),
      'lastSignInTime': lastSignInTime?.toIso8601String(),
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      emailVerified: json['emailVerified'] ?? false,
      creationTime: json['creationTime'] != null 
          ? DateTime.parse(json['creationTime']) 
          : null,
      lastSignInTime: json['lastSignInTime'] != null 
          ? DateTime.parse(json['lastSignInTime']) 
          : null,
    );
  }

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    DateTime? creationTime,
    DateTime? lastSignInTime,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, displayName: $displayName)';
  }
}