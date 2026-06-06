class UserModel {
  final int id;
  final String nama;
  final String email;
  final String noHp;
  final String role; // 'pencari' | 'pemilik'
  final String? fotoProfil;

  const UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.role,
    this.fotoProfil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
        nama: json['nama'] ?? '',
        email: json['email'] ?? '',
        noHp: json['no_hp'] ?? '',
        role: json['role'] ?? 'pencari',
        fotoProfil: json['foto_profil'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'email': email,
        'no_hp': noHp,
        'role': role,
        'foto_profil': fotoProfil,
      };
}
