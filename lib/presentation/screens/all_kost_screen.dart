import 'package:flutter/material.dart';
import 'ui_helpers.dart';

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
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: kCardDecoration(radius: 16),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white10,
                  ),
                  child: const Icon(Icons.image, color: Colors.white24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kos['nama'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                      Text(kos['lokasi'],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(kos['harga'],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
