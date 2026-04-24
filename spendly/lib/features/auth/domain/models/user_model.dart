import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Freezed user model for immutability and serialization
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    /// Firebase user UID
    required String uid,

    /// User email address
    required String email,

    /// User display name
    String? displayName,

    /// User profile photo URL
    String? photoUrl,

    /// Currency preference (default: TRY)
    @Default('TRY')
    String currency,

    /// Timestamp when the user was created
    required DateTime createdAt,
  }) = _UserModel;

  const UserModel._();

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Create from Firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({
      ...data,
      'uid': doc.id,
    });
  }

  /// Convert to Firestore document format
  Map<String, dynamic> toDocument() => toJson()..remove('uid');
}
