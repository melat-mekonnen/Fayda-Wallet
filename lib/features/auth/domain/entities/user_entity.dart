import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? faydaId;
  final String? citizenId;
  final String? phoneNumber;
  final String? address;
  final String? birthDate;
  final String? gender;
  final bool isVerified;
  final DateTime? lastAuthenticated;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.faydaId,
    this.citizenId,
    this.phoneNumber,
    this.address,
    this.birthDate,
    this.gender,
    this.isVerified = false,
    this.lastAuthenticated,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? faydaId,
    String? citizenId,
    String? phoneNumber,
    String? address,
    String? birthDate,
    String? gender,
    bool? isVerified,
    DateTime? lastAuthenticated,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      faydaId: faydaId ?? this.faydaId,
      citizenId: citizenId ?? this.citizenId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      isVerified: isVerified ?? this.isVerified,
      lastAuthenticated: lastAuthenticated ?? this.lastAuthenticated,
    );
  }

  /// Check if the user has a valid Fayda ID
  bool get hasFaydaId => faydaId != null && faydaId!.isNotEmpty;

  /// Get formatted Fayda ID for display
  String get displayFaydaId {
    if (faydaId == null || faydaId!.isEmpty) return 'Not Available';
    
    // Format as FID-XXX-XXX-XXX
    if (faydaId!.length >= 12) {
      return '${faydaId!.substring(0, 3)}-${faydaId!.substring(3, 6)}-${faydaId!.substring(6, 9)}-${faydaId!.substring(9)}';
    }
    return faydaId!;
  }

  /// Get masked Fayda ID for privacy
  String get maskedFaydaId {
    if (faydaId == null || faydaId!.isEmpty) return 'Not Available';
    
    if (faydaId!.length >= 12) {
      return '${faydaId!.substring(0, 3)}-***-***-${faydaId!.substring(9)}';
    }
    return '***-***-${faydaId!.substring(faydaId!.length - 3)}';
  }

  /// Get verification status text
  String get verificationStatus {
    return isVerified ? 'Verified' : 'Pending Verification';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'fayda_id': faydaId,
      'citizen_id': citizenId,
      'phone_number': phoneNumber,
      'address': address,
      'birth_date': birthDate,
      'gender': gender,
      'is_verified': isVerified,
      'last_authenticated': lastAuthenticated?.toIso8601String(),
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      faydaId: json['fayda_id'],
      citizenId: json['citizen_id'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      birthDate: json['birth_date'],
      gender: json['gender'],
      isVerified: json['is_verified'] ?? false,
      lastAuthenticated: json['last_authenticated'] != null 
          ? DateTime.parse(json['last_authenticated'])
          : null,
    );
  }
}