import 'package:equatable/equatable.dart';

/// Represents Patient object
///
/// Provides mapper to create object from network or db response.
/// [isUploaded] will be true if fetched from the network, false otherwise
/// [Equatable] allows us to compare objects easily without overrides.
final class Patient extends Equatable {
  const Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isUploaded
  });

  final String firstName;
  final String lastName;
  final String email;
  final bool isUploaded; // differentiates patients fetched from network vs db
  final int id; // id for patients fetched from db (currently network API does not return id)

  @override
  List<Object> get props => [firstName, lastName, email, isUploaded, id];

  factory Patient.fromMap(Map<String, dynamic> map, bool isUploaded) {
    return Patient(
      id: (map['id'] as int?) ?? -1,
      isUploaded: isUploaded,
      firstName: map['first'] as String,
      lastName: map['last'] as String,
      email: map['email'] as String
    );
  }
}