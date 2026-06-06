import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/kost_provider.dart';
import '../../data/model/kost_model.dart';
import 'detail_kost_screen.dart';
import 'all_kost_screen.dart';
import 'ui_helpers.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  List<KostModel> get _allKost => context.read<KostProvider>().allKost;

  List<KostModel> _filteredResult = [];

  @override
  void initState() {
    super.initState();
    // Pakai data yang sudah ada di provider, kalau kosong fetch dulu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<KostProvider>();
      if (provider.allKost.isEmpty) {
        provider.fetchAllKost().then((_) {
          setState(() => _filteredResult = _allKost);
        });
      } else {
        setState(() => _filteredResult = _allKost);
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredResult = _allKost;
      } else {
        _filteredResult = _allKost
            .where((kost) =>
                kost.nama.toLowerCase().contains(query.toLowerCase()) ||
                kost.lokasi.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showAllKost() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => AllKostScreen(dataKos: _toMapList(_allKost))),
    );
  }

  List<Map<String, dynamic>> _toMapList(List<KostModel> list) => list
      .map((k) => {
            'id': k.id,
            'nama': k.nama,
            'lokasi': k.lokasi,
            'harga': k.hargaFormatted,
            'hargaCoret': k.hargaCoretFormatted ?? '',
            'tipe': k.tipe,
            'sisa': k.sisaKamarText,
            'rating': k.rating.toString(),
            'diskon': k.diskon ?? '',
            'fasilitas': k.fasilitas ?? '',
            'foto': k.foto ?? '',
            'ukuranKamar': k.ukuranKamar ?? '',
            'lokasiLengkap': k.lokasiLengkap,
            'fasilitasKamar': k.fasilitasKamar,
            'tempatTerdekat': k.tempatTerdekat,
            'latitude': k.latitude,
            'longitude': k.longitude,
          })
      .toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kPrimaryGradient),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: buildGlassContainer(
          radius: 12,
          height: 45,
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white, fontSize: 14),
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Cari nama atau lokasi kost...',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white60, fontSize: 13),
              prefixIcon:
                  const Icon(Icons.search, color: kPrimaryLight, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear,
                          color: Colors.white70, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: _isSearching ? _buildSearchResults() : _buildInitialView(),
    );
  }

  Widget _buildInitialView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lokasi sekitar
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.my_location,
                        color: kPrimaryLight, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Lokasi sekitar saya sekarang',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white10),
            const SizedBox(height: 20),

            // Kampus Berdasarkan Kota
            Text(
              'Kampus Berdasarkan Kota',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Container(
                decoration: kCardDecoration(radius: 12),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  iconColor: kPrimaryLight,
                  collapsedIconColor: Colors.grey,
                  title: Text(
                    'Kab. Bandung',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      leading: const Icon(Icons.school_rounded,
                          color: kPrimaryLight, size: 18),
                      title: Text(
                        'Universitas Pendidikan Indonesia Kampus Cibiru',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white70, fontSize: 13),
                      ),
                      trailing: const Icon(Icons.chevron_right,
                          color: Colors.grey, size: 16),
                      onTap: _showAllKost,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredResult.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 60, color: Colors.white.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              'Kos tidak ditemukan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Coba cari dengan kata kunci lain.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _filteredResult.length,
      itemBuilder: (context, index) {
        final kost = _filteredResult[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailKostScreen(
                kostId: kost.id,
                nama: kost.nama,
                harga: kost.hargaFormatted,
                tipe: kost.tipe,
                foto: kost.foto ?? '',
                ukuranKamar: kost.ukuranKamar ?? '',
                lokasiLengkap: kost.lokasiLengkap,
                fasilitasKamar: kost.fasilitasKamar,
                tempatTerdekat: kost.tempatTerdekat,
                rating: kost.rating.toString(),
                fasilitas: kost.fasilitas ?? '',
                latitude: kost.latitude,
                longitude: kost.longitude,
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: kElevatedCardDecoration(radius: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(16)),
                  child: Container(
                    width: 90,
                    height: 100,
                    color: const Color(0xff2d2d2d),
                    child: Image.asset(
                      'assets/images/${kost.foto ?? ''}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_outlined,
                          color: Colors.white24,
                          size: 24),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
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
                            kost.tipe,
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
                        Text(
                          kost.nama,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(children: [
                          const Icon(Icons.location_on,
                              color: Colors.grey, size: 11),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              kost.lokasi,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${kost.hargaFormatted}/bln',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: kPrimaryLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                            ),
                            Row(children: [
                              const Icon(Icons.star,
                                  color: kPrimaryColor, size: 12),
                              const SizedBox(width: 3),
                              Text(
                                kost.rating.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
