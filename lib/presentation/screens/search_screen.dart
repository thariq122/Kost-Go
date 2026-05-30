import 'package:flutter/material.dart';
import 'detail_kost_screen.dart';
import 'ui_helpers.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _isSearching = false;

  // Data Mock kos khusus area Bandung
  final List<Map<String, dynamic>> _kostBandungData = [
    {
      'nama': 'Kost Dipatiukur Regensi Tipe A',
      'harga': 'Rp 1.500.000',
      'tipe': 'Campur',
      'lokasi': 'Coblong, Bandung (Dekat UNPAD/ITB)',
      'fasilitas': 'K. Mandi Dalam • WiFi • AC • Kasur',
      'rating': '4.8'
    },
    {
      'nama': 'Kost Jatinangor Heritage',
      'harga': 'Rp 1.200.000',
      'tipe': 'Putri',
      'lokasi': 'Sumedang, Bandung Core (Dekat UNPAD)',
      'fasilitas': 'WiFi • Kamar Mandi Dalam • Kasur',
      'rating': '4.5'
    },
    {
      'nama': 'Kost Exclusive Dago Ganesha',
      'harga': 'Rp 2.500.000',
      'tipe': 'Putra',
      'lokasi': 'Dago, Bandung (Dekat ITB)',
      'fasilitas': 'K. Mandi Dalam • Water Heater • WiFi • AC',
      'rating': '5.0'
    },
  ];

  List<Map<String, dynamic>> _filteredResult = [];

  final List<String> _popularCampuses = [
    'ITB',
    'UNPAD Jatinangor',
    'UPI Bandung',
    'Telkom University',
    'UNPAS',
    'UNISBA'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredResult = _kostBandungData;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredResult = _kostBandungData;
      } else {
        _filteredResult = _kostBandungData
            .where((kost) =>
                kost['nama'].toLowerCase().contains(query.toLowerCase()) ||
                kost['lokasi'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _searchWithKeyword(String keyword) {
    _searchController.text = keyword;
    _onSearchChanged(keyword);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: kAppBarBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: kScaffoldBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white, fontSize: 14),
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Contoh: ITB atau Dipatiukur',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, fontSize: 13),
              prefixIcon:
                  const Icon(Icons.search, color: Color(0xff14b8a6), size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon:
                          const Icon(Icons.clear, color: Colors.grey, size: 18),
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
      body: _isSearching
          ? _buildSearchResults()
          : _buildInitialRecommendationVisual(),
    );
  }

  Widget _buildInitialRecommendationVisual() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.my_location,
                      color: Color(0xff14b8a6), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Lokasi sekitar saya sekarang',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Container(
            color: const Color(0xff1e1e1e),
            child: TabBar(
              controller: _tabController,
              indicatorColor: kPrimaryColor,
              labelColor: kPrimaryColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: 'Kampus'),
                Tab(text: 'Area'),
                Tab(text: 'Stasiun & Halte'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pencarian populer',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _popularCampuses.map((campus) {
                    return InkWell(
                      onTap: () => _searchWithKeyword(campus),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xff1e1e1e),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: Text(
                          campus,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Text(
                  'Kampus Berdasarkan Kota',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: Container(
                    decoration: kCardDecoration(radius: 12),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      iconColor: const Color(0xff14b8a6),
                      collapsedIconColor: Colors.grey,
                      title: Text(
                        'Kota Bandung',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                      ),
                      children: [
                        _buildSubCampusItem('Institut Teknologi Bandung (ITB)'),
                        _buildSubCampusItem('Universitas Padjadjaran (UNPAD)'),
                        _buildSubCampusItem(
                            'Universitas Pendidikan Indonesia (UPI)'),
                        _buildSubCampusItem('Telkom University (TelU)'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubCampusItem(String namaKampus) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(namaKampus,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white70, fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
      onTap: () => _searchWithKeyword(namaKampus.split(' (')[0]),
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
              'Kos tidak ditemukan di Bandung',
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
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: kCardDecoration(radius: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xff2d2d2d),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image_outlined,
                  color: Colors.white24, size: 22),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    kost['tipe'],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  kost['nama'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(kost['lokasi'],
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  '${kost['harga']}/bln',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Color(0xff14b8a6), size: 14),
                const SizedBox(width: 4),
                Text(kost['rating'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailKostScreen(
                    nama: kost['nama'],
                    harga: kost['harga'],
                    tipe: kost['tipe'],
                    foto: kost['foto'],
                    ukuranKamar: kost['ukuranKamar'],
                    lokasiLengkap: kost['lokasiLengkap'],
                    fasilitasKamar: List<String>.from(kost['fasilitasKamar']),
                    tempatTerdekat:
                        List<Map<String, String>>.from(kost['tempatTerdekat']),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
