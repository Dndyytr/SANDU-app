import 'package:flutter/material.dart';
import 'package:sandu_app/core/utils/navigator.dart';
import 'package:sandu_app/presentation/screens/community/community_screen.dart';
import 'package:sandu_app/presentation/screens/home/home_screen.dart';
import 'package:sandu_app/presentation/screens/profile/profile_screen.dart';
import 'package:sandu_app/presentation/screens/service/service_screen.dart';
import 'package:sandu_app/presentation/widgets/bottom_nav.dart';
import 'package:sandu_app/presentation/widgets/loading.dart';

/// 🏠 Home Wrapper - Container untuk semua screen yang punya Bottom Navigation
/// Screen yang termasuk: Home, Layanan, Komunitas, Profil
class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _currentIndex.value = 0;
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  // ✅ Method untuk set loading state
  void setLoading(bool value) {
    _isLoading.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, child) {
            return Stack(
              children: [
                Scaffold(
                  extendBody: true,
                  body: IndexedStack(
                    index: _currentIndex.value,
                    children: [
                      const HomeScreen(), // Index 0 - Beranda
                      const ServiceScreen(), // Index 1 - Layanan
                      const CommunityScreen(), // Index 2 - Komunitas
                      ProfileScreen(
                        onLoadingChanged: setLoading,
                      ), // Index 3 - Profil
                    ],
                  ),

                  // 🎯 FloatingActionButton di tengah
                  floatingActionButton: CenterFAB(
                    currentIndex: _currentIndex.value,
                    onPressed: () {
                      // Navigasi langsung ke Quick Report screen
                      AppNavigator.goToQuickReport(context);
                    },
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,

                  bottomNavigationBar: BottomNav(
                    currentIndex: _currentIndex.value,
                    onTap: (index) {
                      setState(() {
                        _currentIndex.value = index;
                      });
                    },
                  ),
                ),

                // 🔹 Overlay Loading Sukses (Minimalis)
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.6),
                    child: const Center(child: Loading()),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // 🔹 Placeholder untuk screen yang belum dibuat
  // Widget _buildPlaceholder(String name) {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.construction, size: 64, color: Colors.grey),
  //         const SizedBox(height: 16),
  //         Text(
  //           'Screen $name',
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.grey,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           'Coming Soon...',
  //           style: TextStyle(fontSize: 16, color: Colors.grey),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
