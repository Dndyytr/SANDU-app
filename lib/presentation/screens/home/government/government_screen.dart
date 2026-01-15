import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';

class GovernmentScreen extends StatefulWidget {
  const GovernmentScreen({super.key});

  @override
  State<GovernmentScreen> createState() => _GovernmentScreenState();
}

class _GovernmentScreenState extends State<GovernmentScreen> {
  final ValueNotifier<int> _selectedDateIndex = ValueNotifier(4);

  // 🔹 Data untuk Grid Aksi Cepat
  final List<Map<String, dynamic>> announcementList = [
    {
      'official': true,
      'title': 'Musyawarah Desa',
      'subTitle': 'Lurah mengadakan musyawarah yang dilaksanakan di balai desa',
      'date': '10 Nov 2025, 10:00 WIB',
    },
    {
      'official': false,
      'title': 'Pemutusan Air Dusun Wetan',
      'subTitle': 'Air Dusun Wetan dibuka untuk pelaksanaan pemutusan',
      'date': '10 Nov 2025, 10:00 WIB',
    },
  ];

  // ✅ Data agenda berdasarkan tanggal
  final Map<int, List<Map<String, dynamic>>> agendaByDate = {
    0: [
      // 6 Nov
      {
        'time': '09:00 WIB',
        'title': 'Kerja Bakti Desa',
        'description': 'Gotong royong membersihkan jalan desa',
      },
    ],
    1: [
      // 7 Nov
      {
        'time': '14:00 WIB',
        'title': 'Rapat RT',
        'description': 'Rapat rutin RT 03',
      },
    ],
    2: [
      // 8 Nov
      {
        'time': '10:00 WIB',
        'title': 'Posyandu',
        'description': 'Pelayanan kesehatan ibu dan anak',
      },
    ],
    3: [
      // 9 Nov
      {
        'time': '13:00 WIB',
        'title': 'Pengajian Rutin',
        'description': 'Pengajian rutin mingguan di masjid',
      },
    ],
    4: [
      // 10 Nov (default)
      {
        'time': '10:00 WIB',
        'title': 'Musyawarah RKPDes',
        'description': 'Rencana Kerja Pembangunan Desa 2026',
      },
      {
        'time': '15:00 WIB',
        'title': 'Sosialisasi Program',
        'description': 'Sosialisasi program pemberdayaan masyarakat',
      },
    ],
    5: [
      // 11 Nov
      {
        'time': '08:00 WIB',
        'title': 'Senam Pagi',
        'description': 'Senam pagi bersama di lapangan desa',
      },
    ],
    6: [
      // 12 Nov
      {
        'time': '07:00 WIB',
        'title': 'Kerja Bakti',
        'description': 'Kerja bakti pembersihan saluran air',
      },
    ],
    7: [
      // 13 Nov
      {
        'time': '11:00 WIB',
        'title': 'Kunjungan Camat',
        'description': 'Kunjungan dan monitoring dari camat',
      },
    ],
    8: [], // 14 Nov - kosong
    9: [
      // 15 Nov
      {
        'time': '16:00 WIB',
        'title': 'Rapat Koordinasi',
        'description': 'Rapat koordinasi aparat desa',
      },
    ],
  };

  @override
  void dispose() {
    // ✅ PENTING: Dispose semua ValueNotifier
    _selectedDateIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedAgendas = agendaByDate[_selectedDateIndex.value] ?? [];
    final selectedDay = 6 + _selectedDateIndex.value;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 40,
        centerTitle: false,
        title: Text(
          'Pemerintahan',
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSizeL,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded, size: 40),
          onPressed: () => Navigator.pop(context),
          splashColor: Colors.transparent, // Menghilangkan efek percikan air
          highlightColor:
              Colors.transparent, // Menghilangkan efek warna saat ditekan lama
          hoverColor: Colors.transparent,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) return AppColors.cyan1;
              if (states.contains(WidgetState.hovered)) return AppColors.cyan1;
              return AppColors.textPrimary; // Warna default
            }),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/svg/wave2.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 235.09,
            ),
          ),
          Positioned.fill(
            top: 180,
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
            ),
          ),

          // content
          Positioned.fill(
            top: 0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.cyan1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.s),
                    ),
                    child: Stack(
                      children: [
                        // wave background
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Opacity(
                            opacity: 0.5,
                            child: SvgPicture.string(
                              ''' <svg width="392" height="106" viewBox="0 0 392 106" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M0 22.072C0 13.5633 9.85915 9.08992 16.8838 13.8913C25.7743 19.968 34.6649 23.7854 43.5558 21.7742C58.0742 18.489 72.5925 -0.3386 87.1109 0.540492C101.63 1.41958 116.148 22.0054 130.667 21.7742C145.185 21.5422 159.703 0.493972 174.222 0.540492C188.741 0.587012 203.259 21.7276 217.778 21.7742C232.297 21.82 246.815 0.771724 261.333 0.540492C275.852 0.30926 290.37 20.8951 304.889 21.7742C319.407 22.6526 333.926 3.82495 348.444 0.540492C361.779 -2.47604 375.113 7.61821 388.447 18.7825C390.705 20.6731 392 23.4733 392 26.4184V95.0738C392 100.597 387.523 105.074 382 105.074C370.815 105.074 359.63 105.074 348.444 105.074C333.926 105.074 319.407 105.074 304.889 105.074C290.37 105.074 275.852 105.074 261.333 105.074C246.815 105.074 232.297 105.074 217.778 105.074C203.259 105.074 188.741 105.074 174.222 105.074C159.703 105.074 145.185 105.074 130.667 105.074C116.148 105.074 101.63 105.074 87.1109 105.074C72.5925 105.074 58.0742 105.074 43.5558 105.074C32.3702 105.074 21.1851 105.074 10 105.074C4.47716 105.074 0 100.597 0 95.0738V22.072Z" fill="white" fill-opacity="0.1"/>
                    <path d="M0 46.2582C0 43.1758 1.41742 40.2598 3.85777 38.3768C17.0902 28.1662 30.3227 19.0107 43.5558 21.7742C58.0742 24.8055 72.5925 42.1849 87.1109 41.3735C101.63 40.5628 116.148 21.56 130.667 21.7742C145.185 21.9876 159.703 41.4166 174.222 41.3735C188.741 41.3311 203.259 21.8166 217.778 21.7742C232.297 21.7311 246.815 41.1601 261.333 41.3735C275.852 41.5876 290.37 22.5849 304.889 21.7742C319.407 20.9628 333.926 38.3422 348.444 41.3735C357.458 43.2559 366.473 39.6077 375.486 33.8628C382.508 29.3878 392 33.9203 392 42.2464V95.0738C392 100.597 387.523 105.074 382 105.074C370.815 105.074 359.63 105.074 348.444 105.074C333.926 105.074 319.407 105.074 304.889 105.074C290.37 105.074 275.852 105.074 261.333 105.074C246.815 105.074 232.297 105.074 217.778 105.074C203.259 105.074 188.741 105.074 174.222 105.074C159.703 105.074 145.185 105.074 130.667 105.074C116.148 105.074 101.63 105.074 87.1109 105.074C72.5925 105.074 58.0742 105.074 43.5558 105.074C32.3702 105.074 21.1851 105.074 10 105.074C4.47716 105.074 0 100.597 0 95.0738V46.2582Z" fill="white" fill-opacity="0.08"/>
                    <path d="M0 62.9058C0 54.397 9.85948 49.9235 16.8842 54.7249C25.7746 60.8014 34.6651 64.6184 43.5558 62.6072C58.0742 59.3227 72.5925 40.4951 87.1109 41.3735C101.63 42.2526 116.148 62.8384 130.667 62.6072C145.185 62.3759 159.703 41.3276 174.222 41.3735C188.741 41.42 203.259 62.5606 217.778 62.6072C232.297 62.6537 246.815 41.6054 261.333 41.3735C275.852 41.1422 290.37 61.7281 304.889 62.6072C319.407 63.4862 333.926 44.6586 348.444 41.3735C361.779 38.357 375.113 48.4517 388.447 59.6154C390.705 61.5061 392 64.3063 392 67.2515V95.0738C392 100.597 387.523 105.074 382 105.074C370.815 105.074 359.63 105.074 348.444 105.074C333.926 105.074 319.407 105.074 304.889 105.074C290.37 105.074 275.852 105.074 261.333 105.074C246.815 105.074 232.297 105.074 217.778 105.074C203.259 105.074 188.741 105.074 174.222 105.074C159.703 105.074 145.185 105.074 130.667 105.074C116.148 105.074 101.63 105.074 87.1109 105.074C72.5925 105.074 58.0742 105.074 43.5558 105.074C32.3702 105.074 21.1851 105.074 10 105.074C4.47716 105.074 0 100.597 0 95.0738V62.9058Z" fill="white" fill-opacity="0.1"/>
                    </svg>
                     ''',
                              height: 105.07,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // title
                              Text(
                                'Pemerintahan Desa Utama',
                                style: GoogleFonts.poppins(
                                  fontSize: AppSizes.fontSizeL,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // subtitle
                              Text(
                                'Info resmi, transparansi & partisipasi',
                                style: GoogleFonts.poppins(
                                  fontSize: AppSizes.fontSizeS,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: AppSizes.s),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // proyek aktif
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white1,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.s,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Proyek Aktif:',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '6',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeXS,
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: AppSizes.xs),

                                  // realisasi
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white1,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.s,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Realisasi:',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '78%',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeXS,
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.xs),

                                  // pengumuman
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white1,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.s,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Pengumuman:',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '1',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeXS,
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // lihat pengumuman
                                  Expanded(
                                    flex: 6,
                                    child: TextButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        side: WidgetStateProperty.all(
                                          const BorderSide(
                                            color: Colors
                                                .white, // Sesuaikan warna border
                                            width: 1.0, // Ketebalan border
                                          ),
                                        ),
                                        backgroundColor:
                                            WidgetStateProperty.resolveWith<
                                              Color
                                            >((Set<WidgetState> states) {
                                              if (states.contains(
                                                WidgetState.pressed,
                                              )) {
                                                return AppColors.cyan1;
                                              } else if (states.contains(
                                                WidgetState.hovered,
                                              )) {
                                                return AppColors.cyan1;
                                              }
                                              return AppColors.primary
                                                  .withOpacity(0.7);
                                            }),
                                        padding: WidgetStateProperty.all(
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 6,
                                          ),
                                        ),
                                        minimumSize: WidgetStateProperty.all(
                                          Size.zero,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: WidgetStateProperty.all(
                                          // Gunakan WidgetStateProperty (pengganti MaterialStateProperty di versi terbaru)
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSizes.radiusS,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Lihat Pengumuman',
                                        style: GoogleFonts.poppins(
                                          fontSize: AppSizes.fontSizeS,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        softWrap: false,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: AppSizes.s),

                                  // ajukan usulan
                                  Expanded(
                                    flex: 5,
                                    child: TextButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.resolveWith<
                                              Color
                                            >((Set<WidgetState> states) {
                                              if (states.contains(
                                                WidgetState.pressed,
                                              )) {
                                                return AppColors.cyan1;
                                              } else if (states.contains(
                                                WidgetState.hovered,
                                              )) {
                                                return AppColors.cyan1;
                                              }
                                              return AppColors.secondary;
                                            }),
                                        padding: WidgetStateProperty.all(
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 6,
                                          ),
                                        ),
                                        minimumSize: WidgetStateProperty.all(
                                          Size.zero,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: WidgetStateProperty.all(
                                          // Gunakan WidgetStateProperty (pengganti MaterialStateProperty di versi terbaru)
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSizes.radiusS,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Ajukan Usulan',
                                        style: GoogleFonts.poppins(
                                          fontSize: AppSizes.fontSizeS,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.s),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ClipRect(
                      clipper: VerticalOnlyClipper(),
                      child: SingleChildScrollView(
                        clipBehavior: Clip.none,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pengumuman Resmi',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeS,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith<Color>((
                                          Set<WidgetState> states,
                                        ) {
                                          if (states.contains(
                                            WidgetState.pressed,
                                          )) {
                                            return AppColors.cyan2;
                                          } else if (states.contains(
                                            WidgetState.hovered,
                                          )) {
                                            return AppColors.cyan2;
                                          }
                                          return AppColors.cyan1;
                                        }),

                                    splashFactory: NoSplash.splashFactory,
                                    overlayColor: WidgetStateProperty.all(
                                      Colors.transparent,
                                    ),
                                  ),
                                  child: Text(
                                    'Lihat Semua',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeXS,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              child: Row(
                                children: [
                                  for (
                                    int index = 0;
                                    index < announcementList.length;
                                    index++
                                  ) ...[
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width) /
                                          2,
                                      constraints: BoxConstraints(
                                        maxHeight: 150,
                                      ),
                                      padding: EdgeInsets.all(AppSizes.s),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 3,
                                            spreadRadius: 0,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusS,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Badge
                                          if (announcementList[index]['official'])
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.orange5,
                                                    AppColors.orange2,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppSizes.radiusFull,
                                                    ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: AppSizes.s,
                                                    vertical: 2,
                                                  ),
                                              child: Text(
                                                'OFFICIAL',
                                                style: GoogleFonts.poppins(
                                                  fontSize: AppSizes.fontSizeXS,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          const SizedBox(height: AppSizes.xs),
                                          Text(
                                            announcementList[index]['title'],
                                            style: GoogleFonts.poppins(
                                              fontSize: AppSizes.fontSizeS,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            announcementList[index]['subTitle'],
                                            style: GoogleFonts.poppins(
                                              fontSize: AppSizes.fontSizeXS,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              announcementList[index]['date'],
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.cyan1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index < announcementList.length - 1)
                                      const SizedBox(width: 14),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSizes.s),

                            Text(
                              'Agenda & Musyawarah',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeS,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // date selector
                            ValueListenableBuilder<int>(
                              valueListenable: _selectedDateIndex,
                              builder: (context, selectedIndex, child) {
                                return SizedBox(
                                  height: 45,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    clipBehavior: Clip.none,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      final day = 6 + index;
                                      final isSelected =
                                          selectedIndex ==
                                          index; // ✅ Gunakan selectedIndex dari builder

                                      return GestureDetector(
                                        onTap: () {
                                          _selectedDateIndex.value =
                                              index; // ✅ Update ValueNotifier
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          margin: EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.secondary
                                                : AppColors.orange10,
                                            shape: BoxShape.circle,
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: AppColors.secondary
                                                          .withOpacity(0.5),
                                                      blurRadius: 3,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$day',
                                              style: GoogleFonts.poppins(
                                                color: isSelected
                                                    ? Colors.white
                                                    : AppColors.textSecondary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: AppSizes.fontSizeS,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: AppSizes.s),

                            ValueListenableBuilder<int>(
                              valueListenable: _selectedDateIndex,
                              builder: (context, selectedIndex, child) {
                                final selectedAgendas =
                                    agendaByDate[selectedIndex] ?? [];
                                final selectedDay = 6 + selectedIndex;

                                if (selectedAgendas.isEmpty) {
                                  return Container(
                                    padding: EdgeInsets.all(AppSizes.m),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusS,
                                      ),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(
                                          0.5,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.event_busy,
                                            size: 48,
                                            color: AppColors.textSecondary,
                                          ),
                                          SizedBox(height: AppSizes.s),
                                          Text(
                                            'Tidak ada agenda pada $selectedDay November',
                                            style: GoogleFonts.poppins(
                                              fontSize: AppSizes.fontSizeS,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: selectedAgendas.map((agenda) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                        bottom: AppSizes.s,
                                      ),
                                      padding: EdgeInsets.all(AppSizes.s),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusS,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 3,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            margin: EdgeInsets.only(top: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      size: 14,
                                                      color: AppColors.cyan1,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      agenda['time'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 11,
                                                            color:
                                                                AppColors.cyan1,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  agenda['title'],
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        AppSizes.fontSizeS,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  agenda['description'],
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        AppSizes.fontSizeXS,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            const SizedBox(height: AppSizes.s),

                            // // Action Buttons
                            ValueListenableBuilder<int>(
                              valueListenable: _selectedDateIndex,
                              builder: (context, selectedIndex, child) {
                                final selectedAgendas =
                                    agendaByDate[selectedIndex] ?? [];

                                return Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: selectedAgendas.isEmpty
                                            ? null
                                            : () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Anda mengikuti agenda ${selectedAgendas.first['title']}',
                                                      style:
                                                          GoogleFonts.poppins(),
                                                    ),
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ),
                                                );
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          disabledBackgroundColor:
                                              Colors.grey.shade300,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSizes.radiusS,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Ikut',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeS,
                                            fontWeight: FontWeight.w600,
                                            color: selectedAgendas.isEmpty
                                                ? Colors.grey.shade500
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: selectedAgendas.isEmpty
                                            ? null
                                            : () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Agenda ditambahkan ke kalender',
                                                      style:
                                                          GoogleFonts.poppins(),
                                                    ),
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ),
                                                );
                                              },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: selectedAgendas.isEmpty
                                                ? Colors.grey.shade300
                                                : AppColors.primary,
                                            width: 2,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSizes.radiusS,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Tambah ke Kalender',
                                          style: GoogleFonts.poppins(
                                            color: selectedAgendas.isEmpty
                                                ? Colors.grey.shade400
                                                : AppColors.primary,
                                            fontSize: AppSizes.fontSizeS,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalOnlyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    // Kunci: Atas (Top) diatur ke 0 agar memotong konten yang naik
    // Kiri/Kanan diatur sangat lebar (-2000, 2000) agar tidak memotong samping
    return Rect.fromLTRB(-2000, 0, size.width + 2000, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
