class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final int? age;
  final String? parentName;
  final String? parentPhone;
  final String? category;
  final String? experience;
  final String? location;
  final String? classroomType;
  final List<String>? documents;
  final bool verified;
  final double rating;
  final int totalStudents;
  final double earnings;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.age,
    this.parentName,
    this.parentPhone,
    this.category,
    this.experience,
    this.location,
    this.classroomType,
    this.documents,
    this.verified = false,
    this.rating = 0.0,
    this.totalStudents = 0,
    this.earnings = 0.0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'age': age,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'category': category,
      'experience': experience,
      'location': location,
      'classroomType': classroomType,
      'documents': documents ?? [],
      'verified': verified,
      'rating': rating,
      'totalStudents': totalStudents,
      'earnings': earnings,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'student',
      age: map['age'],
      parentName: map['parentName'],
      parentPhone: map['parentPhone'],
      category: map['category'],
      experience: map['experience'],
      location: map['location'],
      classroomType: map['classroomType'],
      documents: List<String>.from(map['documents'] ?? []),
      verified: map['verified'] ?? false,
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalStudents: map['totalStudents'] ?? 0,
      earnings: (map['earnings'] ?? 0.0).toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
