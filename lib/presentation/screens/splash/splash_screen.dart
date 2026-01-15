import 'package:flutter/material.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/presentation/screens/splash/splash_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandu_app/presentation/widgets/bubble_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final SplashController _controller;
  late AnimationController _animController;
  late AnimationController _exitController;

  // 🔹 Animasi pohon kiri & kanan (slide down)
  late Animation<double> _treeY;

  // 🔹 Animasi rumah + bulan (slide down)
  late Animation<double> _houseY;

  // 🔹 Animasi teks "SANDU" (erase reverse)
  late Animation<double> _sanduReveal;

  // 🔹 Animasi fade out untuk exit
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();
    _controller = SplashController(context);

    _animController = AnimationController(
      duration: const Duration(milliseconds: 2300),
      vsync: this,
    );

    // 🔹 Exit Animation Controller (untuk scale logo saat pindah ke login)
    _exitController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // 🔹 Pohon: slide dari -32 ke 0
    _treeY = Tween<double>(begin: -32, end: 0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.1, 0.3, curve: Curves.easeOut),
      ),
    );

    // 🔹 Rumah + bulan: slide dari -20 ke 0
    _houseY = Tween<double>(begin: -20, end: 0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.1, 0.3, curve: Curves.easeOut),
      ),
    );

    // 🔹 Teks "SANDU": reveal dari kiri ke kanan
    _sanduReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeInOut),
      ),
    );

    // 🔹 Fade out animation: dari 1.0 ke 0.0
    _fadeOutAnimation =
        Tween<double>(
          begin: 1.0, // 👈 INI YANG PALING PENTING!
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: _exitController,
            curve: const Cubic(0.4, 0.0, 0.2, 1.0),
          ),
        );

    // 🔹 Uncomment ini untuk trigger navigasi
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        // 🔹 Mulai fade out dari opacity 1.0 → 0.0
        _exitController.forward().then((_) {
          if (mounted) _controller.navigateToLogin();
        });
      }
    });

    // 🔹 Delay 1.5 detik, baru mulai animasi
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Bubbles Background
          const BubbleBackground(),

          // 🔹 Wave Background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/svg/wave.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 203,
            ),
          ),

          // Isi Konten Utama
          Center(
            child: FadeTransition(
              opacity: _fadeOutAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container dengan logo, tree, dan house
                  SizedBox(
                    width: 500,
                    height: 190,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Logo sandu.png
                        Positioned(
                          bottom: 0, // Logo di bagian bawah
                          child: Image.asset(
                            'assets/images/sandu.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Tree di atas logo (seolah menjadi bagian dari logo)
                        Positioned(
                          top: 0,
                          child: AnimatedBuilder(
                            animation: _treeY,
                            builder: (context, _) => Transform.translate(
                              offset: Offset(0, _treeY.value),
                              child: Image.asset(
                                'assets/images/tree.png',
                                width: 200,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        // logo rumah + bulan (House)
                        Positioned(
                          top: 15,
                          child: AnimatedBuilder(
                            animation: _houseY,
                            builder: (context, _) => Transform.translate(
                              offset: Offset(0, _houseY.value),
                              child: Image.asset(
                                'assets/images/house.png',
                                width: 150,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔹 Teks "SANDU" dengan efek reveal
                  AnimatedBuilder(
                    animation: _sanduReveal,
                    builder: (_, __) => ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _sanduReveal.value,
                        child: Text(
                          'SANDU',
                          style: GoogleFonts.ubuntu(
                            fontSize: AppSizes.fontSizeHero,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),

                  // 🔹 Teks "APP"
                  Text(
                    'APP',
                    style: GoogleFonts.syne(
                      fontSize: AppSizes.fontSizeL,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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
