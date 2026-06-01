import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import 'detail_kost_screen.dart';
import 'ui_helpers.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favProvider, _) {
        final favorites = favProvider.favorites;
        return Scaffold(
          backgroundColor: kScaffoldBg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Favorit',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22)),
                      Text(
                        favorites.isEmpty
                            ? 'Belum ada kos favorit'
                            : '${favorites.length} kos tersimpan',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: favorites.isEmpty
                      ? _buildEmpty(context)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final kos = favorites[index];
                            return _buildFavoriteCard(
                                context, kos, favProvider);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteCard(
      BuildContext context, FavoriteKost kos, FavoritesProvider favProvider) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailKostScreen(
            nama: kos.nama,
            harga: kos.harga,
            tipe: kos.tipe,
            foto: kos.foto,
            ukuranKamar: kos.ukuranKamar,
            lokasiLengkap: kos.lokasiLengkap,
            fasilitasKamar: kos.fasilitasKamar,
            tempatTerdekat: kos.tempatTerdekat,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: kElevatedCardDecoration(radius: 18),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(18)),
              child: Container(
                width: 100,
                height: 110,
                color: kCardBg,
                child: Image.asset(
                  'assets/images/${kos.foto}',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_outlined,
                      color: Colors.white12, size: 28),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(kos.tipe,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => favProvider.toggle(kos),
                          child: const Icon(Icons.favorite_rounded,
                              color: Colors.redAccent, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(kos.nama,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 11),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(kos.lokasi,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.star, color: kPrimaryColor, size: 12),
                      const SizedBox(width: 3),
                      Text(kos.rating,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11)),
                      const Spacer(),
                      Text(kos.harga,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: kPrimaryLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.2), width: 1.5),
            ),
            child: const Icon(Icons.favorite_border_rounded,
                color: Colors.redAccent, size: 48),
          ),
          const SizedBox(height: 24),
          Text('Belum ada kos favorit',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17)),
          const SizedBox(height: 10),
          Text(
            'Tap ikon ❤️ di halaman detail kos\nuntuk menyimpannya di sini.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
