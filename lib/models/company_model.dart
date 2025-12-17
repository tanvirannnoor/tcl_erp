import 'project_model.dart';

class Company {
  final String companyId;
  final String name;
  final String currency;
  final HeadOffice headOffice;
  final List<Project> projects;

  Company({
    required this.companyId,
    required this.name,
    required this.currency,
    required this.headOffice,
    required this.projects,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['companyId'] ?? '',
      name: json['name'] ?? '',
      currency: json['currency'] ?? '',
      headOffice: HeadOffice.fromJson(json['headOffice'] ?? {}),
      projects: (json['projects'] as List?)
              ?.map((p) => Project.fromJson(p))
              .toList() ??
          [],
    );
  }
}

class HeadOffice {
  final String address;
  final Contact contact;

  HeadOffice({
    required this.address,
    required this.contact,
  });

  factory HeadOffice.fromJson(Map<String, dynamic> json) {
    return HeadOffice(
      address: json['address'] ?? '',
      contact: Contact.fromJson(json['contact'] ?? {}),
    );
  }
}

class Contact {
  final String phone;
  final String email;

  Contact({
    required this.phone,
    required this.email,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}