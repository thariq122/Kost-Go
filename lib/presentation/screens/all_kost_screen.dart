import 'package:flutter/material.dart';
import 'ui_helpers.dart';
import 'detail_kost_screen.dart';

class AllKostScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dataKos;
  const AllKostScreen({super.key, required this.dataKos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: buildAppBar(context, 'Semua Kosan'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dataKos.length,
        itemBuilder: (context, index) {
          final kos = dataKos[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailKostScreen(
                    kostId: kos['id'] is int
                        ? kos['id']
                        : int.tryParse(kos['id']?.toString() ?? '0') ?? 0,
                    nama: kos['nama'],
                    harga: kos['harga'],
                    tipe: kos['tipe'],
                    foto: kos['foto'],
                    ukuranKamar: kos['ukuranKamar'],
                    lokasiLengkap: kos['lokasiLengkap'],
                    fasilitasKamar: List<String>.from(kos['fasilitasKamar']),
                    tempatTerdekat:
                        List<Map<String, String>>.from(kos['tempatTerdekat']),
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: kElevatedCardDecoration(radius: 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: const Color(0xff2d2d2d),
                      child: Image.asset(
                        'assets/images/${kos['foto']}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                              child: Icon(Icons.image_outlined,
                                  color: Colors.white24, size: 30));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            kos['tipe'],
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(kos['nama'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(kos['lokasi'],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Text(kos['harga'],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: kPrimaryLight,
                                    fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
