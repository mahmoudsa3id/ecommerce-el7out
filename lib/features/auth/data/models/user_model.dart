// features/auth/data/models/user_model.dart
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.photoUrl,
    super.phoneNumber,
    super.emailVerified,
    required super.createdAt,
  });

  factory UserModel.fromFirebaseUser(fb.User user, {String? fullNameOverride}) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      fullName: fullNameOverride ?? user.displayName ?? 'EL7OUT Member',
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'email': email,
    'fullName': fullName,
    'photoUrl': photoUrl,
    'phoneNumber': phoneNumber,
    'emailVerified': emailVerified,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
