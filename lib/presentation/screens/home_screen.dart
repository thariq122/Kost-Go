import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/kost_provider.dart';
import '../../data/model/kost_model.dart';
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

  // ==================== DATA KOSAN DIHAPUS — sekarang dari KostProvider ====================

  final List<Map<String, dynamic>> _promoBanners = [
    {
      'title': 'Cari Kos Jadi Mudah',
      'subtitle': 'Temukan kos terbaik di sekitar kampus & kantormu',
      'icon': Icons.search_rounded,
      'colors': [const Color(0xff14b8a6), const Color(0xff0d9488)],
      'bgIcon': Icons.home_work_rounded,
    },
    {
      'title': 'Booking Tanpa Ribet',
      'subtitle': 'Ajukan sewa, upload bukti, tinggal tunggu konfirmasi',
      'icon': Icons.assignment_turned_in_rounded,
      'colors': [const Color(0xff2563eb), const Color(0xff1d4ed8)],
      'bgIcon': Icons.phone_android_rounded,
    },
    {
      'title': 'Kos Terpercaya & Aman',
      'subtitle': 'Semua pemilik kos terverifikasi di KostGo',
      'icon': Icons.verified_user_rounded,
      'colors': [const Color(0xff7c3aed), const Color(0xff6d28d9)],
      'bgIcon': Icons.shield_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Load kost dari API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KostProvider>().fetchAllKost();
    });

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
                    Consumer<KostProvider>(
                      builder: (context, kostProvider, _) {
                        final list = kostProvider.allKost;
                        if (kostProvider.isLoading) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.all(40),
                            child:
                                CircularProgressIndicator(color: kPrimaryColor),
                          ));
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Super Rare Kost', onSeeAll: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllKostScreen(
                                          dataKos: _toMapList(list))));
                            }),
                            const SizedBox(height: 16),
                            _buildSuperRareList(context, list),
                            const SizedBox(height: 32),
                            _buildSectionTitle('Pilihan Kos Baru Buatmu',
                                onSeeAll: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllKostScreen(
                                          dataKos: _toMapList(list))));
                            }),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text('Yuk cek kos yang baru join KostGo.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Colors.grey, fontSize: 13)),
                            ),
                            const SizedBox(height: 16),
                            _buildNewKostGrid(context, list),
                          ],
                        );
                      },
                    ),
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
                      color: (banner['colors'][0] as Color)
                          .withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background icon besar — dekorasi
                    Positioned(
                      right: -12,
                      bottom: -12,
                      child: Icon(
                        banner['bgIcon'] as IconData,
                        size: 140,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    // Foreground icon kecil kiri
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          banner['icon'] as IconData,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    // Teks kanan ikon
                    Positioned(
                      left: 76,
                      top: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner['title'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner['subtitle'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    height: 1.4),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Dot indicator posisi bawah kanan
                    Positioned(
                      bottom: 14,
                      right: 16,
                      child: Row(
                        children: List.generate(
                          _promoBanners.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(left: 4),
                            height: 5,
                            width: _currentBannerIndex == i ? 16 : 5,
                            decoration: BoxDecoration(
                              color: _currentBannerIndex == i
                                  ? Colors.white
                                  : Colors.white38,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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

  /// Konversi KostModel ke Map untuk AllKostScreen (yang masih pakai Map)
  List<Map<String, dynamic>> _toMapList(List<KostModel> list) => list
      .map((k) => {
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
          })
      .toList();

  void _navigateToDetail(BuildContext context, KostModel kos) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailKostScreen(
            kostId: kos.id,
            nama: kos.nama,
            harga: kos.hargaFormatted,
            tipe: kos.tipe,
            foto: kos.foto ?? '',
            ukuranKamar: kos.ukuranKamar ?? '',
            lokasiLengkap: kos.lokasiLengkap,
            fasilitasKamar: kos.fasilitasKamar,
            tempatTerdekat: kos.tempatTerdekat,
            rating: kos.rating.toString(),
            fasilitas: kos.fasilitas ?? '',
          ),
        ));
  }

  Widget _buildSuperRareList(BuildContext context, List<KostModel> listKost) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, bottom: 20),
        itemCount: listKost.length,
        itemBuilder: (context, index) {
          final kos = listKost[index];
          return GestureDetector(
            onTap: () => _navigateToDetail(context, kos),
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
                            'assets/images/${kos.foto ?? ''}',
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
                              child: Text(kos.tipe,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: Colors.white70,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                            ),
                            Text(kos.sisaKamarText,
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
                        Text(kos.nama,
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
                                child: Text(kos.lokasi,
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
                        Text(kos.fasilitas ?? '',
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
                            Text(kos.rating.toString(),
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
                            Text(kos.diskon ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Text(kos.hargaCoretFormatted ?? '',
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
                            Text(kos.hargaFormatted,
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

  // ==================== GRID KOST BARU ====================
  Widget _buildNewKostGrid(BuildContext context, List<KostModel> listKost) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: listKost.length,
      itemBuilder: (context, index) {
        final kos = listKost[index];
        return InkWell(
          onTap: () => _navigateToDetail(context, kos),
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
                          'assets/images/${kos.foto ?? ''}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image_outlined,
                                  color: Colors.white12, size: 30)),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
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
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kos.tipe,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.white54, fontSize: 10)),
                      const SizedBox(height: 4),
                      Text(kos.nama,
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
                      Text(kos.lokasi,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Text(kos.hargaFormatted,
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
