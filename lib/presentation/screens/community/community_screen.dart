import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/presentation/screens/community/create_post/create_post_screen.dart';
import 'package:sandu_app/presentation/screens/home/home_screen.dart';
import 'package:sandu_app/presentation/widgets/button_width_icon.dart';
import 'package:sandu_app/presentation/widgets/container_feed.dart';
import 'package:sandu_app/presentation/widgets/filter_button.dart';
import 'package:sandu_app/presentation/widgets/header.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // State variable
  final ValueNotifier<int> _currentCarouselIndex = ValueNotifier(0);

  late final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  final List<String> imageList = [
    'assets/images/community1.jpg',
    'assets/images/community2.jpg',
    'assets/images/community3.jpg',
  ];

  // 🔹 List Aksi
  final List<Map<String, dynamic>> actionList = [
    {
      'icon': Icons.edit_note_rounded,
      'name': 'Buat Postingan',
      'onPressed': (BuildContext context) {
        NavigationHelper.navigateWithSlideTransition(
          context,
          CreatePostScreen(),
        );
      },
    },
    {
      'icon': Icons.edit_calendar_rounded,
      'name': 'Buat Event',
      'onPressed': (BuildContext context) {
        NavigationHelper.navigateWithSlideTransition(
          context,
          CreatePostScreen(),
        );
      },
    },
    {
      'icon': Icons.poll_outlined,
      'name': 'Buat Poll',
      'onPressed': (BuildContext context) {
        NavigationHelper.navigateWithSlideTransition(
          context,
          CreatePostScreen(),
        );
      },
    },
    {
      'icon': Icons.group_add_rounded,
      'name': 'Buat Grup',
      'onPressed': (BuildContext context) {
        NavigationHelper.navigateWithSlideTransition(
          context,
          CreatePostScreen(),
        );
      },
    },
  ];

  // 🔹 List Filter
  final List<String> filterList = [
    'Semua',
    'RW Saya',
    'Grup',
    'Event',
    'Pengumuman',
    'Poll',
  ];

  // 🔹 List Feed Utama
  final List<Map<String, dynamic>> feedList = [
    {
      'color': Colors.white,
      'image': Image.asset(
        'assets/images/profile.jpg',
        height: 30,
        fit: BoxFit.cover,
      ),
      'title': 'Musyawarah Desa Utama',
      'titleColor': AppColors.textPrimary,
      'subTitle':
          'Kegiatan akan dilaksanakan di balai desa pada hari minggu, kepada para kepala dusun harap untuk hadir',
      'subTitleColor': AppColors.textSecondary,
      'createdAt': '1 Jam lalu',
      'colorCreatedAt': AppColors.textPrimary,
      'creator': 'Kades Desa Utama',
      'creatorColor': AppColors.primary,
      'dateCreated': '5 Nov 2025 12:00',
      'likes': '50k',
      'comment': '100',
      'textButtonColors': [AppColors.primary, AppColors.cyan1, Colors.white],
      'textButton': 'Detail',
      'textButtonSize': 12.0,
      'badgeText': 'Pengumuman',
    },
    {
      'color': Colors.white,
      'image': Image.asset(
        'assets/images/profile.jpg',
        height: 30,
        fit: BoxFit.cover,
      ),
      'title': 'Musyawarah Desa Utama',
      'titleColor': AppColors.textPrimary,
      'subTitle':
          'Kami butuh relawan kerja bakti sabtu ini di gang melati RT 03',
      'subTitleColor': AppColors.textSecondary,
      'createdAt': '1 Jam lalu',
      'colorCreatedAt': AppColors.textPrimary,
      'creator': 'Ibu Siti RT 03',
      'creatorColor': AppColors.primary,
      'dateCreated': '5 Nov 2025 12:00',
      'likes': '50k',
      'comment': '100',
      'textButtonColors': [AppColors.primary, AppColors.cyan1, Colors.white],
      'textButton': '+ Ikut',
      'textButtonSize': 12.0,
      'badgeText': 'RW Saya',
    },
    {
      'color': Colors.white,
      'image': Image.asset(
        'assets/images/profile.jpg',
        height: 30,
        fit: BoxFit.cover,
      ),
      'title': 'Musyawarah Desa Utama',
      'titleColor': AppColors.textPrimary,
      'subTitle':
          'Kegiatan akan dilaksanakan di balai desa pada hari minggu, kepada para kepala dusun harap untuk hadir',
      'subTitleColor': AppColors.textSecondary,
      'createdAt': '1 Jam lalu',
      'colorCreatedAt': AppColors.textPrimary,
      'creator': 'Kades Desa Utama',
      'creatorColor': AppColors.primary,
      'dateCreated': '5 Nov 2025 12:00',
      'likes': '50k',
      'comment': '100',
      'textButtonColors': [AppColors.primary, AppColors.cyan1, Colors.white],
      'textButton': 'Detail',
      'textButtonSize': 12.0,
      'badgeText': 'Pengumuman',
    },
    {
      'color': Colors.white,
      'image': Image.asset(
        'assets/images/profile.jpg',
        height: 30,
        fit: BoxFit.cover,
      ),
      'title': 'Musyawarah Desa Utama',
      'titleColor': AppColors.textPrimary,
      'subTitle':
          'Kegiatan akan dilaksanakan di balai desa pada hari minggu, kepada para kepala dusun harap untuk hadir',
      'subTitleColor': AppColors.textSecondary,
      'createdAt': '1 Jam lalu',
      'colorCreatedAt': AppColors.textPrimary,
      'creator': 'Kades Desa Utama',
      'creatorColor': AppColors.primary,
      'dateCreated': '5 Nov 2025 12:00',
      'likes': '50k',
      'comment': '100',
      'textButtonColors': [AppColors.primary, AppColors.cyan1, Colors.white],
      'textButton': 'Detail',
      'textButtonSize': 12.0,
      'badgeText': 'Pengumuman',
    },
  ];

  @override
  void dispose() {
    // ✅ Hanya dispose internal notifier
    _selectedIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/svg/wave2.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 235.09,
            ),
          ),

          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s),
                  child: Header(),
                ),
              ),

              const SizedBox(height: AppSizes.s),

              Expanded(
                child: Container(
                  width: double.infinity,
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.background2.withOpacity(0.2),
                        AppColors.background2,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.09],
                    ),
                  ),

                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(maxHeight: 150),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CarouselSlider.builder(
                                      itemCount: imageList.length,
                                      options: CarouselOptions(
                                        viewportFraction: 1,
                                        enlargeCenterPage: false,
                                        enableInfiniteScroll: true,
                                        autoPlay: imageList.length > 1,
                                        autoPlayInterval: const Duration(
                                          seconds: 5,
                                        ),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 800),
                                        pauseAutoPlayOnTouch: true,
                                        padEnds: false,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _currentCarouselIndex.value = index;
                                          });
                                        },
                                      ),
                                      itemBuilder: (context, index, realIndex) {
                                        return
                                        // Gambar
                                        Image.asset(
                                          imageList[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        );
                                      },
                                    ),

                                    // Text Content
                                    Positioned(
                                      left: 5,
                                      right: 5,
                                      bottom: 5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,

                                        children: [
                                          Text(
                                            'Komunitas',
                                            style: GoogleFonts.poppins(
                                              fontSize: AppSizes.fontSizeL,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Temukan kabar, gabung diskusi, dan inisiasi kegiatan lokal',
                                            style: GoogleFonts.poppins(
                                              fontSize: AppSizes.fontSizeXS,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontStyle: FontStyle.italic,
                                            ),

                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),

                                    IgnorePointer(
                                      // Agar tetap bisa swipe carousel
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            center: Alignment
                                                .center, // Pusat cahaya di tengah
                                            radius:
                                                1, // Seberapa luas bagian terang di tengah
                                            colors: [
                                              Colors
                                                  .transparent, // Tengah 100% bening
                                              Colors.black.withOpacity(
                                                0.3,
                                              ), // Pinggiran mulai menggelap
                                            ],
                                            stops: const [
                                              0.7,
                                              1.0,
                                            ], // 0.4 artinya 40% area tengah dipastikan bersih
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: AppSizes.s),

                            // Dots Indicator
                            ValueListenableBuilder<int>(
                              valueListenable: _currentCarouselIndex,
                              builder: (context, currentIndex, child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    imageList.length,
                                    (index) => Container(
                                      width: currentIndex == index ? 20 : 10,
                                      height: 4,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        // shape: BoxShape.circle,
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusFull,
                                        ),
                                        color: currentIndex == index
                                            ? AppColors.cyan1
                                            : AppColors.white2,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            // 🔹 Aksi
                            Text(
                              'Aksi',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeS,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: AppSizes.s),

                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 0,
                              runSpacing: AppSizes.s,
                              children: List.generate(actionList.length, (
                                index,
                              ) {
                                final action = actionList[index];
                                final screenWidth = MediaQuery.of(
                                  context,
                                ).size.width;
                                final padding =
                                    AppSizes.xs *
                                    2; // Padding kiri-kanan container
                                final gap =
                                    AppSizes.s *
                                    2; // Total gap antar 4 item (3x spacing)
                                final itemWidth =
                                    (screenWidth - padding - gap) / 4;

                                return SizedBox(
                                  width: itemWidth,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ButtonWidthIcon(
                                        onPressed:
                                            actionList[index]['onPressed'],
                                        colors: [
                                          AppColors.white2,
                                          AppColors.cyan2,
                                        ],
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusFull,
                                        ),
                                        gradient: false,
                                        icon: action['icon'],
                                        paddingHorizontal: 10,
                                        paddingVertical: 10,
                                        sizeIcon: 28,
                                        colorIcon: [
                                          AppColors.primary,
                                          AppColors.cyan1,
                                        ],
                                        boxShadow: false,
                                      ),

                                      const SizedBox(height: AppSizes.s),

                                      Text(
                                        action['name'] ?? 'Sektor',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: AppSizes.s),

                            // 🔹 Filter
                            Text(
                              'Filter',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeS,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: AppSizes.s),

                            ValueListenableBuilder<int>(
                              valueListenable: _selectedIndex,
                              builder: (context, selectedIndex, child) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  clipBehavior: Clip.none,
                                  child: Row(
                                    children: [
                                      for (
                                        int index = 0;
                                        index < filterList.length;
                                        index++
                                      ) ...[
                                        FilterButton(
                                          label: filterList[index],
                                          isSelected: selectedIndex == index,
                                          onTap: () {
                                            _selectedIndex.value = index;
                                          },
                                        ),
                                        if (index < filterList.length - 1)
                                          const SizedBox(width: AppSizes.s),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: AppSizes.m),

                            // 🔹 Feed Utama
                            Text(
                              'Feed Utama',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeS,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: AppSizes.xs,
                          ),
                          child: Column(
                            children: [
                              GridView.builder(
                                shrinkWrap:
                                    true, // Gunakan true jika di dalam ScrollView/Column
                                physics:
                                    const NeverScrollableScrollPhysics(), // Gunakan ini jika sudah ada scroll di parent
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          2, // Membagi menjadi 2 kolom
                                      crossAxisSpacing: AppSizes
                                          .s, // Jarak horizontal antar item
                                      mainAxisSpacing: AppSizes
                                          .s, // Jarak vertikal antar item
                                      mainAxisExtent:
                                          190.0, // Mengunci tinggi item sesuai maxHeight Anda sebelumnya
                                    ),
                                itemCount: feedList.length,
                                itemBuilder: (context, index) {
                                  final feed = feedList[index];
                                  return ContainerFeed(
                                    color: feed['color'],
                                    image: feed['image'],
                                    title: feed['title'],
                                    titleColor: feed['titleColor'],
                                    subTitle: feed['subTitle'],
                                    subTitleColor: feed['subTitleColor'],
                                    createdAt: feed['createdAt'],
                                    colorCreatedAt: feed['colorCreatedAt'],
                                    creator: feed['creator'],
                                    creatorColor: feed['creatorColor'],
                                    dateCreated: feed['dateCreated'],
                                    likes: feed['likes'],
                                    comment: feed['comment'],
                                    textButtonColors: List<Color>.from(
                                      feed['textButtonColors'],
                                    ),
                                    textButton: feed['textButton'],
                                    textButtonSize: feed['textButtonSize'],
                                    badgeText: feed['badgeText'],
                                    maxHeight: 190.0,
                                  );
                                },
                              ),
                              // 🔹 BOTTOM PADDING UNTUK SCROLL
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
