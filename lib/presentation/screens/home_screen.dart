import 'dart:async';
import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'detail_kost_screen.dart';
import 'all_kost_screen.dart';
import 'notification_screen.dart';
import 'ui_helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController(initialPage: 0);
  final ScrollController _scrollController = ScrollController();

  int _currentBannerIndex = 0;
  late Timer _bannerTimer;
  bool _showBackToTopButton = false;

  // ==================== MASTER DATA KOSAN DINAMIS ====================
  final List<Map<String, dynamic>> _listKost = [
    {
      'nama': 'Kost Wisma Serasi Tipe A',
      'lokasi': 'Serpong, Tangerang',
      'harga': 'Rp 1.431.500',
      'hargaCoret': 'Rp 1.475.000',
      'tipe': 'Campur',
      'sisa': 'Sisa 3 Kamar',
      'rating': '4.6',
      'diskon': 'Diskon 44rb',
      'fasilitas': 'K. Mandi Dalam • WiFi • AC • Kasur',
      'foto': 'Kos1.png',
      'ukuranKamar': '3x4 meter',
      'lokasiLengkap': 'Jl. Serpong Raya No.12, Serpong, Tangerang, Banten',
      'fasilitasKamar': [
        'WiFi Gratis',
        'Kasur Springbed',
        'Lemari Pakaian',
        'AC 1/2 PK'
      ],
      'tempatTerdekat': [
        {'nama': 'Stasiun Serpong', 'jarak': '10m'},
        {'nama': 'Pasar Modern Serpong', 'jarak': '400m'}
      ],
    },
    {
      'nama': 'Pondok Gusgas 2',
      'lokasi': 'Cibiru, Kab. Bandung',
      'harga': 'Rp 850.000',
      'hargaCoret': 'Rp 1.000.000',
      'tipe': 'Putra',
      'sisa': 'Sisa 2 Kamar',
      'rating': '4.8',
      'diskon': 'Diskon 150rb',
      'fasilitas': 'WiFi • Kasur • Lemari • Parkir',
      'foto': 'Kos2.png',
      'ukuranKamar': '3x3 meter',
      'lokasiLengkap':
          'Jl. Cibiru Indah No.45, Cibiru, Kab. Bandung, Jawa Barat',
      'fasilitasKamar': [
        'WiFi Koridor',
        'Kasur Busa',
        'Lemari Kayu',
        'Meja Belajar'
      ],
      'tempatTerdekat': [
        {'nama': 'Kampus UIN Bandung', 'jarak': '500m'},
        {'nama': 'Borma Cibiru', 'jarak': '800m'}
      ],
    },
    {
      'nama': 'Pondok Priangan 1',
      'lokasi': 'Cibiru, Kab. Bandung',
      'harga': 'Rp 900.000',
      'hargaCoret': 'Rp 950.000',
      'tipe': 'Putri',
      'sisa': 'Sisa 5 Kamar',
      'rating': '4.5',
      'diskon': 'Diskon 50rb',
      'fasilitas': 'K. Mandi Dalam • WiFi • Kasur',
      'foto': 'Kos3.png',
      'ukuranKamar': '3.5x3.5 meter',
      'lokasiLengkap':
          'Cileunyi-Cibiru Blok C No.3, Cibiru, Kab. Bandung, Jawa Barat',
      'fasilitasKamar': [
        'Kamar Mandi Dalam',
        'WiFi Fast',
        'Kasur Kapuk',
        'Gantungan Baju'
      ],
      'tempatTerdekat': [
        {'nama': 'Bundaran Cibiru', 'jarak': '300m'},
        {'nama': 'Polda Jabar', 'jarak': '1.2km'}
      ],
    },
    {
      'nama': 'Pondok Priangan 2',
      'lokasi': 'Cibiru, Kab. Bandung',
      'harga': 'Rp 950.000',
      'hargaCoret': 'Rp 1.100.000',
      'tipe': 'Campur',
      'sisa': 'Sisa 1 Kamar',
      'rating': '4.7',
      'diskon': 'Diskon 150rb',
      'fasilitas': 'K. Mandi Dalam • WiFi • AC',
      'foto': 'kos4.png',
      'ukuranKamar': '4x4 meter',
      'lokasiLengkap':
          'Samping Gang Priangan No.88, Cibiru, Kab. Bandung, Jawa Barat',
      'fasilitasKamar': [
        'AC Dingin',
        'Kamar Mandi Shower',
        'Kasur King Size',
        'WiFi 5G'
      ],
      'tempatTerdekat': [
        {'nama': 'Stasiun Cimekar', 'jarak': '2.5km'},
        {'nama': 'Warteg Priangan', 'jarak': '50m'}
      ],
    },
  ];

  final List<Map<String, dynamic>> _promoBanners = [
    {
      'title': 'Promo Ngebut Q3!',
      'subtitle': 'Diskon sewa hingga Rp 500rb',
      'btnText': 'Cek Sekarang',
      'icon': Icons.bolt,
      'colors': [const Color(0xff14b8a6), const Color(0xff0d9488)],
    },
    {
      'title': 'Kos Premium Verified ✨',
      'subtitle': 'Bebas penipuan, survei via online',
      'btnText': 'Lihat Koleksi',
      'icon': Icons.verified_user,
      'colors': [const Color(0xff2563eb), const Color(0xff1d4ed8)],
    },
    {
      'title': 'Spesial Anak Rantau 🎒',
      'subtitle': 'Cashback hingga 10% member baru',
      'btnText': 'Klaim Voucher',
      'icon': Icons.card_giftcard,
      'colors': [const Color(0xffdb2777), const Color(0xff9333ea)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentBannerIndex < _promoBanners.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }
      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.offset > 400) {
        if (!_showBackToTopButton) {
          setState(() => _showBackToTopButton = true);
        }
      } else {
        if (_showBackToTopButton) {
          setState(() => _showBackToTopButton = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _bannerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn);
  }

  void _showInteractionFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xff14b8a6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      floatingActionButton: (_showBackToTopButton && widget.isLoggedIn)
          ? Padding(
              padding: const EdgeInsets.only(bottom: 75),
              child: FloatingActionButton.extended(
                onPressed: _scrollToTop,
                backgroundColor: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                icon: const Icon(Icons.arrow_upward_rounded,
                    color: Colors.black, size: 18),
                label: Text(
                  'Kembali ke atas',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 1. BRANDING HEADER (Scrolls out of view)
            SliverToBoxAdapter(
              child: _buildBrandingHeader(),
            ),

            // 2. STICKY SEARCH BAR (Stays pinned at the top)
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: kScaffoldBg.withValues(
                  alpha: 0.95), // Slight transparency for modern feel
              elevation: 4, // Adds a soft shadow when scrolled
              shadowColor: Colors.black,
              toolbarHeight:
                  75, // Height to accommodate the custom search container
              titleSpacing: 0,
              title: _buildSearchBar(),
            ),

            // 3. MAIN CONTENT
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  if (!widget.isLoggedIn) ...[
                    _buildGuestBanner(),
                  ],
                  if (widget.isLoggedIn) ...[
                    _buildPromoCarousel(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Super Rare Kost', onSeeAll: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllKostScreen(dataKos: _listKost)));
                    }),
                    const SizedBox(height: 16),
                    _buildSuperRareList(context),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Pilihan Kos Baru Buatmu', onSeeAll: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllKostScreen(dataKos: _listKost)));
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Yuk cek kos yang baru join KostGo.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 13)),
                    ),
                    const SizedBox(height: 16),
                    _buildNewKostGrid(context),
                  ],
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/LogoKostGo.png',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.maps_home_work,
                    color: Color(0xff14b8a6),
                    size: 36),
              ),
              const SizedBox(width: 12),
              Text(
                'KostGo',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Colors.white70, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
        borderRadius: BorderRadius.circular(20),
        child: buildGlassContainer(
          radius: 20,
          height: 55,
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(Icons.search, color: kPrimaryLight, size: 22),
              const SizedBox(width: 12),
              Text('Cari area atau nama kost...',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey, fontSize: 14)),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune_rounded,
                    color: Colors.white, size: 18),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: buildGlassContainer(
        radius: 24,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_circle_outlined,
                  color: kPrimaryLight, size: 48),
            ),
            const SizedBox(height: 16),
            Text('#EnaknyaNgekos di KostGo',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Masuk sebagai pencari kos untuk melihat rekomendasi area terdekat, kelola booking, dan promo khusus anak rantau!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _promoBanners.length,
            onPageChanged: (index) {
              setState(() => _currentBannerIndex = index);
            },
            itemBuilder: (context, index) {
              final banner = _promoBanners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: banner['colors'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: banner['colors'][0]
                          .withValues(alpha: 0.3), // Glow effect per banner
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(banner['icon'],
                          size: 130,
                          color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(banner['title'],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                          Text(banner['subtitle'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => _showInteractionFeedback(context,
                                'Membuka detail promo: ${banner['title']}'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(banner['btnText'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promoBanners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentBannerIndex == index ? 18 : 6,
              decoration: BoxDecoration(
                color: _currentBannerIndex == index
                    ? const Color(0xff14b8a6)
                    : Colors.white24,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {required VoidCallback onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: Text('Lihat Semua',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: kPrimaryLight, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuperRareList(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
            left: 20, bottom: 20), // Added bottom padding for shadow
        itemCount: _listKost.length,
        itemBuilder: (context, index) {
          final kos = _listKost[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailKostScreen(
                    nama: kos['nama'],
                    harga: kos['harga'],
                    tipe: kos['tipe'],
                    foto: kos['foto'],
                    ukuranKamar: kos['ukuranKamar'],
                    lokasiLengkap: kos['lokasiLengkap'],
                    fasilitasKamar: List<String>.from(kos['fasilitasKamar']),
                    tempatTerdekat:
                        List<Map<String, String>>.from(kos['tempatTerdekat']),
                    rating: kos['rating'] ?? '4.8',
                    fasilitas: kos['fasilitas'] ?? '',
                  ),
                ),
              );
            },
            child: Container(
              width: 260,
              margin: const EdgeInsets.only(right: 20),
              decoration: kElevatedCardDecoration(radius: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: Container(
                          height: 160,
                          width: double.infinity,
                          color: const Color(0xff2d2d2d),
                          child: Image.asset(
                            'assets/images/${kos['foto']}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                  child: Icon(Icons.image_outlined,
                                      color: Colors.white12, size: 40));
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xff9333ea),
                                Color(0xffdb2777)
                              ]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xffdb2777)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3)),
                              ],
                              border: Border.all(
                                  color: const Color(0xff1e1e1e), width: 2),
                            ),
                            child: Text('⭐ SUPER RARE KOST',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white24),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(kos['tipe'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: Colors.white70,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                            ),
                            Text(kos['sisa'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.redAccent,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(kos['nama'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.grey, size: 12),
                            const SizedBox(width: 4),
                            Expanded(
                                child: Text(kos['lokasi'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Colors.grey, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(kos['fasilitas'],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color(0xff14b8a6), size: 14),
                            const SizedBox(width: 4),
                            Text(kos['rating'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: kPrimaryColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.bolt,
                                color: Colors.redAccent, size: 14),
                            const SizedBox(width: 4),
                            Text(kos['diskon'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Text(kos['hargaCoret'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.grey,
                                        fontSize: 11,
                                        decoration:
                                            TextDecoration.lineThrough)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(kos['harga'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                            Text(' /bln',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.5),
                                        fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================== KODINGAN TERPOTONG SUDAH DILENGKAPI ====================
  Widget _buildNewKostGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65, // Disesuaikan agar card proporsional
      ),
      itemCount: _listKost.length,
      itemBuilder: (context, index) {
        final kos = _listKost[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailKostScreen(
                  nama: kos['nama'],
                  harga: kos['harga'],
                  tipe: kos['tipe'],
                  foto: kos['foto'],
                  ukuranKamar: kos['ukuranKamar'],
                  lokasiLengkap: kos['lokasiLengkap'],
                  fasilitasKamar: List<String>.from(kos['fasilitasKamar']),
                  tempatTerdekat:
                      List<Map<String, String>>.from(kos['tempatTerdekat']),
                  rating: kos['rating'] ?? '4.8',
                  fasilitas: kos['fasilitas'] ?? '',
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: kElevatedCardDecoration(radius: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: const Color(0xff2d2d2d),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/${kos['foto']}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Icon(Icons.image_outlined,
                                    color: Colors.white12, size: 30));
                          },
                        ),
                        // Label Promo / Baru
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  6)), // BAGIAN YANG SEBELUMNYA TERPOTONG
                            ),
                            child: Text('PROMO',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Detail Teks Kos Baru
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kos['tipe'],
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.white54, fontSize: 10)),
                      const SizedBox(height: 4),
                      Text(kos['nama'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(kos['lokasi'],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Text(kos['harga'],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: kPrimaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                    ],
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
