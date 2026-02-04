import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/presentation/screens/service/skd/skd_screen.dart';

class PosyanduScreen extends StatefulWidget {
  const PosyanduScreen({super.key});

  @override
  State<PosyanduScreen> createState() => _PosyanduScreenState();
}

class _PosyanduScreenState extends State<PosyanduScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String?> _selectedFilter = ValueNotifier(null);
  final ScrollController _dateScrollController = ScrollController();
  final ValueNotifier<int> _selectedDateIndex = ValueNotifier(4);
  int _announcementIndex = 0;

  // audience
  final List<String> _filterOptions = [
    'RW Saya',
    'RW 1',
    'RW 2',
    'RW 3',
    'RW 4',
    'RW 5',
    'RW 6',
    'RW 7',
    'RW 8',
    'RW 9',
    'RW 10',
    'RW 11',
    'RW 12',
  ];

  // ✅ Data agenda berdasarkan tanggal
  final Map<int, List<Map<String, dynamic>>> agendaByDate = {
    0: [
      // 6 Nov
      {
        'time': '08:00 WIB',
        'title': 'Pembukaan & Registrasi',
        'description': 'Pendaftaran peserta posyandu melati',
      },
      {
        'time': '09:30 WIB',
        'title': 'Penimbangan Bayi',
        'description': 'Penimbangan dan pengukuran tinggi badan',
      },
    ],
    1: [
      // 7 Nov
      {
        'time': '09:00 WIB',
        'title': 'Pemeriksaan Kesehatan',
        'description': 'Pemeriksaan kesehatan umum oleh petugas',
      },
      {
        'time': '10:30 WIB',
        'title': 'Konsultasi Gizi',
        'description': 'Konsultasi nutrisi untuk ibu dan anak',
      },
    ],
    2: [
      // 8 Nov
      {
        'time': '08:30 WIB',
        'title': 'Imunisasi Lengkap',
        'description': 'Program imunisasi anak sesuai jadwal',
      },
    ],
    3: [
      // 9 Nov
      {
        'time': '10:00 WIB',
        'title': 'Penyuluhan Kesehatan Ibu',
        'description': 'Edukasi kesehatan reproduksi dan pemeriksaan kehamilan',
      },
    ],
    4: [
      // 10 Nov (default)
      {
        'time': '09:00 WIB',
        'title': 'Kegiatan Inti Posyandu',
        'description': 'Pelayanan kesehatan ibu dan anak terpadu',
      },
      {
        'time': '12:00 WIB',
        'title': 'Pemberian Makanan Tambahan',
        'description': 'Distribusi PMT dan vitamin untuk balita',
      },
    ],
    5: [
      // 11 Nov
      {
        'time': '10:30 WIB',
        'title': 'Deteksi Dini Tumbuh Kembang',
        'description': 'Screening perkembangan anak dengan KPSP',
      },
    ],
    6: [
      // 12 Nov
      {
        'time': '14:00 WIB',
        'title': 'Kelas Ibu Hamil',
        'description': 'Penyuluhan kesehatan untuk ibu hamil dan menyusui',
      },
    ],
    7: [
      // 13 Nov
      {
        'time': '09:00 WIB',
        'title': 'Pelayanan Kesehatan Lansia',
        'description': 'Pengecekan tekanan darah dan kesehatan lansia',
      },
      {
        'time': '11:00 WIB',
        'title': 'Evaluasi Program Posyandu',
        'description': 'Rapat evaluasi dan perencanaan bulan depan',
      },
    ],
    8: [], // 14 Nov - kosong
    9: [
      // 15 Nov
      {
        'time': '10:00 WIB',
        'title': 'Hari Kesehatan Keluarga',
        'description': 'Kegiatan terpadu kesehatan seluruh keluarga',
      },
      {
        'time': '13:00 WIB',
        'title': 'Senam Bersama',
        'description': 'Senam kesehatan untuk ibu dan lansia',
      },
    ],
  };

  final List<Map<String, dynamic>> _children = [
    {'name': 'Budi', 'age': '2y', 'emoji': '👶'},
    {'name': 'Siti', 'age': '8bln', 'emoji': '👶'},
  ];

  final List<Map<String, String>> _announcements = [
    {
      'title': 'Bawa KMS & kain lap...',
      'content':
          'Pastikan membawa buku KMS dan kain lap sendiri untuk alas timbangan.',
    },
    {
      'title': 'Jadwal Imunisasi',
      'content': 'Imunisasi campak pada tanggal 15 November 2024.',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _selectedFilter.dispose();
    _dateScrollController.dispose();
    _selectedDateIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 40,
        centerTitle: false,
        title: Text(
          'Posyandu',
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSizeM,
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
                                'Posyandu Melati - RT 06',
                                style: GoogleFonts.poppins(
                                  fontSize: AppSizes.fontSizeL,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // subtitle
                              Text(
                                'Next: 28 Oktober - 08:00',
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
                                  // daftar hadir
                                  Expanded(
                                    flex: 5,
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
                                        'Daftar Hadir',
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
                                    flex: 7,
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
                                        'Simpan ke Kalender',
                                        style: GoogleFonts.poppins(
                                          fontSize: AppSizes.fontSizeS,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AppSizes.s),

                              TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>((
                                        Set<WidgetState> states,
                                      ) {
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
                                    const Size(double.infinity, 0),
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
                                  'Ikut/Rsvp',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeS,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.s),
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
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: BuildTextField(
                                    hintText: 'Cari nama anak/RT',
                                    controller: _searchController,
                                    focusedColor: Colors.grey.shade50,
                                    unfocusedColor: Colors.grey.shade100,
                                    borderColor: Colors.grey.shade400,
                                    unborderColor: Colors.grey.shade200,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Icon(
                                        Icons.search_rounded,
                                        size: 20,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSizes.xs),
                                Expanded(
                                  flex: 5,
                                  child: ValueListenableBuilder<String?>(
                                    valueListenable: _selectedFilter,
                                    builder: (context, value, child) {
                                      return BuildDropdown(
                                        hint: 'Pilih filter',
                                        label: 'Filter',
                                        items: _filterOptions,
                                        borderButton: AppColors.primary
                                            .withOpacity(0.3),
                                        buttonColor: Colors.grey[50],
                                        hintColor: AppColors.textPrimary,
                                        selectedItemColor: Colors.white,
                                        borderColor: AppColors.primary
                                            .withOpacity(0.5),
                                        backgroundColor: [
                                          Colors.grey.shade400,
                                          Colors.grey.shade300,
                                          Colors.grey.shade300,
                                        ],
                                        value:
                                            value, // ← Nilai dari ValueNotifier
                                        onChanged: (newValue) {
                                          _selectedFilter.value =
                                              newValue; // ← Update ValueNotifier
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.s),
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

                            // Action Buttons
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
                                                          GoogleFonts.poppins(
                                                            fontSize: AppSizes
                                                                .fontSizeXS,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
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
                                                          GoogleFonts.poppins(
                                                            fontSize: AppSizes
                                                                .fontSizeXS,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
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

                            const SizedBox(height: AppSizes.s),
                            Text(
                              'Data Anak',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeS,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSizes.s),
                            _buildMyChildrenSection(),
                            const SizedBox(height: AppSizes.s),
                            Text(
                              'Aksi Cepat',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeS,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSizes.s),
                            _buildQuickActionsSection(),
                            const SizedBox(height: AppSizes.s),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Snapshot KPI',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeS,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Posyandu Terdekat',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeS,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.s),
                            _buildKPIandMapSection(),
                            const SizedBox(height: AppSizes.s),
                            Text(
                              'Pengumuman/Tips',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.fontSizeS,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSizes.s),
                            _buildAnnouncementSection(),
                            const SizedBox(height: AppSizes.s),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
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
                                    child: Column(
                                      children: [
                                        Text(
                                          'Kontak Bidan',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeS,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '(Call)',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeS,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
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
                                    child: Column(
                                      children: [
                                        Text(
                                          'Hubungi Kades',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeS,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '(Chat)',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeS,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
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

  Widget _buildMyChildrenSection() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          ..._children
              .map(
                (child) => _buildChildCard(
                  emoji: child['emoji']!,
                  name: child['name']!,
                  age: child['age']!,
                ),
              )
              .toList(),
          _buildAddChildCard(),
        ],
      ),
    );
  }

  Widget _buildChildCard({
    required String emoji,
    required String name,
    required String age,
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE082),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '[$emoji $name, $age]',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddChildCard() {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[400]!,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle add child
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 40, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                'Tambah Anak',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: [
        _buildQuickActionCard(
          icon: Icons.vaccines_outlined,
          label: 'Daftar\nImunisasi',
          color: const Color(0xFF00897B),
        ),
        _buildQuickActionCard(
          icon: Icons.assignment_outlined,
          label: 'Pendaftaran\nAnak',
          color: const Color(0xFFFF8A65),
        ),
        _buildQuickActionCard(
          icon: Icons.description_outlined,
          label: 'Lihat Riwayat\nKMS',
          color: const Color(0xFF8D6E63),
        ),
        _buildQuickActionCard(
          icon: Icons.medical_services_outlined,
          label: 'Konsultasi\nBidan',
          color: const Color(0xFF64B5F6),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Handle quick action
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKPIandMapSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personal Alert',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '1 anak belum imunisasi bulan ini',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.error_outline_rounded,
                            color: Colors.orange,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personal Intens',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '2 kunjungan terakhir — 12 Okt, 05 Sep ',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: _buildMapCard()),
      ],
    );
  }

  Widget _buildMapCard() {
    return Container(
      height: 125,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Placeholder for Google Maps
            Container(
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.map, size: 40, color: Colors.grey[500]),
              ),
            ),
            // Location Pin
            const Center(
              child: Icon(Icons.location_on, size: 40, color: Colors.red),
            ),
            // Google Logo
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Google',
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementSection() {
    return SizedBox(
      height: 120,
      child: PageView.builder(
        clipBehavior: Clip.none,
        padEnds: false,
        controller: PageController(
          viewportFraction: 0.85,
          initialPage: _announcementIndex,
        ),
        onPageChanged: (index) {
          setState(() {
            _announcementIndex = index;
          });
        },
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          bool isLastItem = index == _announcements.length - 2;
          return Container(
            margin: isLastItem
                ? const EdgeInsets.only(right: AppSizes.s)
                : null,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: index == 0 ? AppColors.primary : AppColors.secondary,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _announcements[index]['title']!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  _announcements[index]['content']!,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
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
