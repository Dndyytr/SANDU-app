import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/presentation/screens/home/home_screen.dart';
import 'package:sandu_app/presentation/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:sandu_app/presentation/screens/success/success_screen.dart';
import 'package:sandu_app/presentation/widgets/button_width_text.dart';
import 'package:sandu_app/presentation/widgets/loading.dart';
import 'package:sandu_app/presentation/widgets/submit_button.dart';

class SkdScreen extends StatefulWidget {
  const SkdScreen({super.key});

  @override
  State<SkdScreen> createState() => _SkdScreenState();
}

class _SkdScreenState extends State<SkdScreen> {
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;
  // ✅ Dummy User Profile Data (simulasi data dari profil)
  final Map<String, dynamic> userProfile = {
    'isProfileComplete': true, // Set false jika profil belum lengkap
    'namaLengkap': 'Dandy Taufiqurrochman',
    'nik': '32146543467654',
    'nomorHP': '0813876556765',
    'email': 'dandy.taufiqurrochman@gmail.com',
    'alamatLengkap': 'Dusun Wetan, RT 06/RW 02',
    'rt': '06',
    'rw': '02',
  };

  // Controllers
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  // State
  final ValueNotifier<String> _selectedStatus = ValueNotifier('Warga Lokal');
  final ValueNotifier<String?> _selectedRT = ValueNotifier(null);
  final ValueNotifier<String?> _selectedRW = ValueNotifier(null);

  // Tambahkan waktu upload untuk setiap file
  final ValueNotifier<DateTime?> _fotoKTPUploadTime = ValueNotifier(null);
  final ValueNotifier<DateTime?> _fotoKKUploadTime = ValueNotifier(null);
  final ValueNotifier<DateTime?> _suratRTUploadTime = ValueNotifier(null);
  final ValueNotifier<DateTime?> _fotoRumahUploadTime = ValueNotifier(null);

  // File uploads
  final ValueNotifier<File?> _fotoKTP = ValueNotifier(null);
  final ValueNotifier<File?> _fotoKK = ValueNotifier(null);
  final ValueNotifier<File?> _suratRT = ValueNotifier(null);
  final ValueNotifier<File?> _fotoRumah = ValueNotifier(null);

  final ValueNotifier<bool> _agreeTerms = ValueNotifier(false);
  final ValueNotifier<bool> _showConfirmation = ValueNotifier(false);

  OverlayEntry? _loadingOverlay;

  void _showLoadingOverlay() {
    if (_loadingOverlay != null) return;

    _loadingOverlay = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withOpacity(0.6),
        child: const Center(child: Loading()),
      ),
    );

    Overlay.of(context).insert(_loadingOverlay!);
  }

  void _hideLoadingOverlay() {
    _loadingOverlay?.remove();
    _loadingOverlay = null;
  }

  // Tambahkan helper function untuk mapping
  String _getStatusDisplayText(String value) {
    switch (value) {
      case 'Warga Lokal':
        return 'Warga Asli Desa Utama';
      case 'Pendatang Dengan Surat Pindah':
        return 'Pendatang (Dengan Surat Pindah)';
      case 'Pendatang Tanpa Surat Pindah':
        return 'Pendatang (Tanpa Surat Pindah)';
      default:
        return value;
    }
  }

  // Tambahkan di _SkdScreenState class

  String _getFileSizeForDisplay(File? file) {
    if (file == null) return '0 KB';

    try {
      final bytes = file.lengthSync();
      if (bytes < 1024) {
        return '$bytes B';
      } else if (bytes < 1024 * 1024) {
        return '${(bytes / 1024).toStringAsFixed(1)} KB';
      } else {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
    } catch (e) {
      return '0 KB';
    }
  }

  String _getFileNameForDisplay(File? file) {
    if (file == null) return 'Belum diunggah';

    final path = file.path;
    final fileName = path.split('/').last;

    // Format nama file agar lebih rapi
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex != -1) {
      final name = fileName.substring(0, dotIndex);
      final extension = fileName.substring(dotIndex + 1).toUpperCase();

      // Replace underscore dengan spasi dan kapitalisasi setiap kata
      final formattedName = name
          .replaceAll('_', ' ')
          .split(' ')
          .map(
            (word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1)}'
                : '',
          )
          .join(' ');

      return '$formattedName.$extension';
    }

    return fileName;
  }

  String _getTimeAgoForDisplay(DateTime? uploadTime) {
    if (uploadTime == null) return 'baru saja';

    final now = DateTime.now();
    final difference = now.difference(uploadTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'baru saja';
    }
  }

  bool _isImageFile(File? file) {
    if (file == null) return false;

    final path = file.path.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.gif');
  }

  // Update _handleFileSelection
  void _handleFileSelection(String type, File file) {
    final now = DateTime.now();

    setState(() {
      switch (type) {
        case 'ktp':
          _fotoKTP.value = file;
          _fotoKTPUploadTime.value = now;
          break;
        case 'kk':
          _fotoKK.value = file;
          _fotoKKUploadTime.value = now;
          break;
        case 'rt':
          _suratRT.value = file;
          _suratRTUploadTime.value = now;
          break;
        case 'rumah':
          _fotoRumah.value = file;
          _fotoRumahUploadTime.value = now;
          break;
      }
    });
  }

  // Dropdown options
  final List<String> _rtOptions = List.generate(
    15,
    (index) => '${index + 1}'.padLeft(2, '0'),
  );
  final List<String> _rwOptions = List.generate(
    10,
    (index) => '${index + 1}'.padLeft(2, '0'),
  );

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // ✅ Load data dari profil (jika ada)
  void _loadProfileData() {
    if (userProfile['isProfileComplete'] == true) {
      _namaController.text = userProfile['namaLengkap'] ?? '';
      _nikController.text = userProfile['nik'] ?? '[Prefill]';
      _hpController.text = userProfile['nomorHP'] ?? '[Prefill]';
      _emailController.text = userProfile['email'] ?? '';
      _alamatController.text = userProfile['alamatLengkap'] ?? '';
      _selectedRT.value = userProfile['rt'];
      _selectedRW.value = userProfile['rw'];
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    // Anda bisa pilih antara gallery atau camera
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery, // atau ImageSource.camera
      maxWidth: 1920, // Optional: resize
      maxHeight: 1080, // Optional: resize
      imageQuality: 85, // Optional: kualitas 0-100
    );

    if (image != null) {
      _fotoRumah.value = File(image.path);

      // Optional: Tampilkan snackbar konfirmasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Foto rumah berhasil dipilih'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Opsional: Method untuk mengambil foto langsung dari kamera
  Future<void> _takePhotoWithCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear, // atau CameraDevice.front
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 90,
    );

    if (photo != null) {
      _fotoRumah.value = File(photo.path);
    }
  }

  Future<void> _pickFile(String type) async {
    List<String> allowedExtensions;

    // Tentukan allowedExtensions berdasarkan tipe
    switch (type) {
      case 'ktp':
      case 'kk':
        // Hanya gambar untuk KTP dan KK
        allowedExtensions = ['jpg', 'jpeg', 'png'];
        break;
      case 'rt':
        // Gambar dan dokumen untuk Surat RT
        allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf', 'docx'];
        break;
      case 'rumah':
        // Gunakan Image Picker untuk foto rumah
        await _pickImageFromGallery();
        return; // Keluar dari function karena sudah handle di method lain
      default:
        allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf'];
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      // Opsional: tambahkan dialog title
      dialogTitle: 'Pilih File ${type.toUpperCase()}',
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      _handleFileSelection(type, file);
    }
  }

  void _submitForm() async {
    if (_agreeTerms.value && _formKey.currentState!.validate()) {
      _showConfirmation.value = true;

      // Tampilkan loading overlay
      _showLoadingOverlay();

      try {
        // Simulasi proses
        await Future.delayed(const Duration(seconds: 2));

        // Sembunyikan loading
        _hideLoadingOverlay();

        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              title: 'Berhasil',
              titleSize: AppSizes.fontSizeHero,
              subTitle:
                  'Pengajuan Berhasil Terkirim, menunggu pengajuan disetujui, silahkan lihat status di halaman Layanan.',
              subTitleSize: AppSizes.fontSizeM,
              onPressed: () {
                // Biasanya di sini kita kembali ke Home dan menghapus stack sebelumnya
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home-screen',
                  (route) => false, // Hapus semua route sebelumnya
                );
              },
              buttonText: 'Kembali ke Home',
              buttonTextSize: AppSizes.fontSizeS,
              buttonColors: [
                AppColors.primary,
                AppColors.cyan1,
                AppColors.cyan1,
                AppColors.background,
                Colors.white,
              ],
              paddingHorizontalButton: AppSizes.m,
              paddingVerticalButton: AppSizes.s,
            ),
          ),
        );
      } catch (e) {
        _hideLoadingOverlay();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap centang persetujuan data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _hpController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _fotoKTP.dispose();
    _fotoKK.dispose();
    _suratRT.dispose();
    _fotoRumah.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            toolbarHeight: 40,
            centerTitle: false,
            title: Text(
              'Surat Keterangan Domisili (SKD)',
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontSizeM,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_left_rounded, size: 40),
              onPressed: () => Navigator.pop(context),
              splashColor:
                  Colors.transparent, // Menghilangkan efek percikan air
              highlightColor: Colors
                  .transparent, // Menghilangkan efek warna saat ditekan lama
              hoverColor: Colors.transparent,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.pressed))
                    return AppColors.cyan1;
                  if (states.contains(WidgetState.hovered))
                    return AppColors.cyan1;
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
                            colors: [AppColors.red1, AppColors.red3],
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
                                opacity: 0.8,
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
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.notifications_active_rounded,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        'Peringatan Data Profil',
                                        style: GoogleFonts.poppins(
                                          fontSize: AppSizes.fontSizeS,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.warning_rounded,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Beberapa data profil anda belum lengkap:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeXS,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '- Nomor HP belum terverifikasi',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeXS,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '- NIK belum tersedia',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeXS,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'Lengkapi dulu di halaman Profil untuk mempercepat proses. Data kosong tidak akan tersimpan otomatis di profil.',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeXS,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: AppSizes.s),
                                  // button
                                  TextButton(
                                    onPressed: () {
                                      NavigationHelper.navigateWithSlideTransition(
                                        context,
                                        EditProfileScreen(),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.resolveWith<
                                            Color
                                          >((Set<WidgetState> states) {
                                            if (states.contains(
                                              WidgetState.pressed,
                                            )) {
                                              return AppColors.red2;
                                            } else if (states.contains(
                                              WidgetState.hovered,
                                            )) {
                                              return AppColors.red2;
                                            }
                                            return Colors.white;
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
                                      'Lengkapi Profil Sekarang',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontSizeS,
                                        color: AppColors.red1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSizes.s),

                      // title form
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Form Surat Keterangan Domisili',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeM,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.s),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // title data pemohon
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Data Pemohon',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontSizeM,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSizes.s),

                                // nama lengkap
                                Text(
                                  'Nama Lengkap:',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeS,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.xs),
                                BuildTextField(
                                  hintText: 'Masukkan nama lengkap',
                                  controller: _namaController,
                                ),
                                const SizedBox(height: AppSizes.s),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // nik
                                          Text(
                                            'NIK:',
                                            style: GoogleFonts.poppins(
                                              fontSize: AppSizes.fontSizeS,
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: AppSizes.xs),
                                          BuildTextField(
                                            hintText: 'Masukkan NIK',
                                            controller: _nikController,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: AppSizes.xs),

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // no hp
                                          Text(
                                            'No HP:',
                                            style: GoogleFonts.poppins(
                                              fontSize: AppSizes.fontSizeS,
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: AppSizes.xs),
                                          BuildTextField(
                                            hintText: 'Masukkan No HP',
                                            controller: _hpController,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppSizes.s),
                                // email
                                Text(
                                  'Email:',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeS,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.xs),
                                BuildTextField(
                                  hintText: 'Masukkan Email',
                                  controller: _emailController,
                                ),

                                const SizedBox(height: AppSizes.s),

                                // title data alamat
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Data Alamat',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontSizeM,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppSizes.s),

                                // alamat lengkap
                                Text(
                                  'Alamat Lengkap:',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeS,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.xs),
                                BuildTextField(
                                  hintText: 'Masukkan Alamat Lengkap',
                                  controller: _alamatController,
                                ),

                                const SizedBox(height: AppSizes.s),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // rt
                                          Text(
                                            'RT:',
                                            style: GoogleFonts.poppins(
                                              fontSize: AppSizes.fontSizeS,
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: AppSizes.xs),
                                          ValueListenableBuilder<String?>(
                                            valueListenable: _selectedRT,
                                            builder: (context, value, child) {
                                              return BuildDropdown(
                                                hint: 'Pilih RT',
                                                label: 'RT',
                                                items: _rtOptions,
                                                value: value,
                                                onChanged: (newValue) {
                                                  _selectedRT.value =
                                                      newValue; // ← Update ValueNotifier
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: AppSizes.xs),

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // rw
                                          Text(
                                            'RW:',
                                            style: GoogleFonts.poppins(
                                              fontSize: AppSizes.fontSizeS,
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: AppSizes.xs),
                                          ValueListenableBuilder<String?>(
                                            valueListenable: _selectedRW,
                                            builder: (context, value, child) {
                                              return BuildDropdown(
                                                hint: 'Pilih RW',
                                                label: 'RW',
                                                items: _rwOptions,
                                                value:
                                                    value, // ← Nilai dari ValueNotifier
                                                onChanged: (newValue) {
                                                  _selectedRW.value =
                                                      newValue; // ← Update ValueNotifier
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppSizes.s),

                                // title status domisili
                                Row(
                                  children: [
                                    Icon(
                                      Icons.home,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Status Domisili',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontSizeM,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppSizes.s),

                                BuildRadioOption(
                                  title: 'Warga Lokal',
                                  subTitle: 'KTP Sesuai domisili saat ini',
                                  groupValueNotifier: _selectedStatus,
                                ),
                                const SizedBox(height: AppSizes.xs),
                                BuildRadioOption(
                                  title: 'Pendatang Dengan Surat Pindah',
                                  subTitle: 'Belum buat KTP baru',
                                  groupValueNotifier: _selectedStatus,
                                ),
                                const SizedBox(height: AppSizes.xs),
                                BuildRadioOption(
                                  title: 'Pendatang Tanpa Surat Pindah',
                                  subTitle: 'KTP Luar derah',
                                  groupValueNotifier: _selectedStatus,
                                ),

                                const SizedBox(height: AppSizes.s),

                                // title dokumen pendukung
                                Row(
                                  children: [
                                    Icon(
                                      Icons.file_copy_rounded,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Dokumen Pendukung',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontSizeM,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppSizes.s),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ValueListenableBuilder<File?>(
                                        valueListenable: _fotoKTP,
                                        builder: (context, file, child) {
                                          return BuildUploadButton(
                                            title: 'Foto KTP',
                                            file:
                                                file, // ← File dari ValueNotifier
                                            onTap: () => _pickFile('ktp'),
                                            subtitle:
                                                'Format JPG, PNG max 2 MB',
                                            showPreview: true,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: ValueListenableBuilder<File?>(
                                        valueListenable: _fotoKK,
                                        builder: (context, file, child) {
                                          return BuildUploadButton(
                                            title: 'Upload Foto KK',
                                            file: file,
                                            onTap: () => _pickFile('kk'),
                                            subtitle:
                                                'Format JPG, PNG max 5 MB',
                                            showPreview: true,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSizes.xs),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ValueListenableBuilder<File?>(
                                        valueListenable: _suratRT,
                                        builder: (context, file, child) {
                                          return BuildUploadButton(
                                            title: 'Surat RT',
                                            file:
                                                file, // ← File dari ValueNotifier
                                            onTap: () => _pickFile('rt'),
                                            subtitle: '(wajib bila pendatang)',
                                            showPreview: true,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: BuildImagePicker(
                                        title: 'Foto Rumah',
                                        imageNotifier: _fotoRumah,
                                        subtitle: 'Ambil dari kamera',
                                        showPreview: true,
                                        onTap: () => _takePhotoWithCamera(),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppSizes.s),

                                ValueListenableBuilder<bool>(
                                  valueListenable: _agreeTerms,
                                  builder: (context, isChecked, child) {
                                    return InkWell(
                                      onTap: () {
                                        // Membalikkan nilai boolean
                                        _agreeTerms.value = !_agreeTerms.value;
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isChecked,
                                            onChanged: (value) {
                                              () => _agreeTerms.value =
                                                  value ?? false;
                                            },
                                            visualDensity:
                                                VisualDensity.compact,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            activeColor: AppColors.primary,
                                          ),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            child: Text(
                                              'Saya menyatakan data yang diisi benar.',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeXS,
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: AppSizes.s),
                                Builder(
                                  builder: (BuildContext btnContext) {
                                    return SubmitButton(
                                      text: 'Kirim Pengajuan',
                                      onPressed: () {
                                        showModalBottomSheet<String>(
                                          context: btnContext,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (BuildContext modalContext) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(
                                                  context,
                                                ).viewInsets.bottom,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .background2, // ✅ WAJIB ada!
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                20,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                  child: Column(
                                                    children: [
                                                      // title confirmation form
                                                      Text(
                                                        'Konfirmasi Pengajuan',
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: AppSizes
                                                                  .fontSizeS,
                                                              color: AppColors
                                                                  .textPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),

                                                      const SizedBox(
                                                        height: AppSizes.s,
                                                      ),

                                                      // container info
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets.all(
                                                          10,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colors.blue[50],
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                AppSizes
                                                                    .radiusS,
                                                              ),
                                                          border: Border.all(
                                                            color:
                                                                const Color.fromARGB(
                                                                  68,
                                                                  0,
                                                                  81,
                                                                  255,
                                                                ),
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(
                                                                  Icons.info,
                                                                  size: 25,
                                                                  color: Colors
                                                                      .blue[800],
                                                                ),
                                                                const SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'Periksa Kembali Data Anda',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              AppSizes.fontSizeXS,
                                                                          color:
                                                                              Colors.blue[900],
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'Pastikan seluruh data yang anda masukkan sudah benar sebelum mengirim pengajuan. Data tidak dapat diubah setelah dikirim.',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.blue[700],
                                                                          fontWeight:
                                                                              FontWeight.w600,
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

                                                      const SizedBox(
                                                        height: AppSizes.s,
                                                      ),

                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.person,
                                                            size: 20,
                                                            color: AppColors
                                                                .primary,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(
                                                            'Data Pemohon',
                                                            style: GoogleFonts.poppins(
                                                              fontSize: AppSizes
                                                                  .fontSizeS,
                                                              color: AppColors
                                                                  .textPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                        height: AppSizes.s,
                                                      ),

                                                      // data pemohon
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets.all(
                                                          10,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                AppSizes
                                                                    .radiusM,
                                                              ),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Nama Lengkap',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: AppSizes
                                                                    .fontSizeXS,
                                                                color: AppColors
                                                                    .textSecondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            Text(
                                                              _namaController
                                                                      .text
                                                                      .isNotEmpty
                                                                  ? _namaController
                                                                        .text
                                                                  : '-',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: AppSizes
                                                                    .fontSizeS,
                                                                color: AppColors
                                                                    .textPrimary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  AppSizes.s,
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 1,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  AppSizes.s,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'NIK',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              AppSizes.fontSizeXS,
                                                                          color:
                                                                              AppColors.textSecondary,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        _nikController.text.isNotEmpty
                                                                            ? _nikController.text
                                                                            : '-',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              AppSizes.fontSizeS,
                                                                          color:
                                                                              AppColors.textPrimary,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'No HP',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              AppSizes.fontSizeXS,
                                                                          color:
                                                                              AppColors.textSecondary,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        _hpController.text.isNotEmpty
                                                                            ? _hpController.text
                                                                            : '-',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              AppSizes.fontSizeS,
                                                                          color:
                                                                              AppColors.textPrimary,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  AppSizes.s,
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 1,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  AppSizes.s,
                                                            ),
                                                            Text(
                                                              'Email',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: AppSizes
                                                                    .fontSizeXS,
                                                                color: AppColors
                                                                    .textSecondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            Text(
                                                              _emailController
                                                                      .text
                                                                      .isNotEmpty
                                                                  ? _emailController
                                                                        .text
                                                                  : '-',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: AppSizes
                                                                    .fontSizeS,
                                                                color: AppColors
                                                                    .textPrimary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: AppSizes.s,
                                                      ),

                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .location_on_rounded,
                                                            size: 20,
                                                            color: AppColors
                                                                .primary,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(
                                                            'Data Alamat',
                                                            style: GoogleFonts.poppins(
                                                              fontSize: AppSizes
                                                                  .fontSizeM,
                                                              color: AppColors
                                                                  .textPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                        height: AppSizes.s,
                                                      ),

                                                      // data alamat
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets.all(
                                                          10,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                AppSizes
                                                                    .radiusM,
                                                              ),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Alamat Lengkap',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: AppSizes
                                                                    .fontSizeXS,
                                                                color: AppColors
                                                                    .textSecondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            Text(
                                                              _alamatController
                                                                      .text
                                                                      .isNotEmpty
                                                                  ? _alamatController
                                                                        .text
                                                                  : '-',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: AppSizes
                                                                    .fontSizeS,
                                                                color: AppColors
                                                                    .textPrimary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  AppSizes.s,
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 1,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  AppSizes.s,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'RT',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              AppSizes.fontSizeXS,
                                                                          color:
                                                                              AppColors.textSecondary,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        _selectedRT.value?.isNotEmpty ==
                                                                                true
                                                                            ? _selectedRT.value!
                                                                            : '-',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              AppSizes.fontSizeS,
                                                                          color:
                                                                              AppColors.textPrimary,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'RW',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              AppSizes.fontSizeXS,
                                                                          color:
                                                                              AppColors.textSecondary,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        _selectedRW.value?.isNotEmpty ==
                                                                                true
                                                                            ? _selectedRW.value!
                                                                            : '-',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              AppSizes.fontSizeS,
                                                                          color:
                                                                              AppColors.textPrimary,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  AppSizes.s,
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 1,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  AppSizes.s,
                                                            ),
                                                            Text(
                                                              'Status Domisili',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: AppSizes
                                                                    .fontSizeXS,
                                                                color: AppColors
                                                                    .textSecondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            ValueListenableBuilder<
                                                              String
                                                            >(
                                                              valueListenable:
                                                                  _selectedStatus,
                                                              builder:
                                                                  (
                                                                    context,
                                                                    value,
                                                                    child,
                                                                  ) {
                                                                    return Text(
                                                                      value.isNotEmpty
                                                                          ? _getStatusDisplayText(
                                                                              value,
                                                                            )
                                                                          : '-',
                                                                      style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            AppSizes.fontSizeS,
                                                                        color: AppColors
                                                                            .textPrimary,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    );
                                                                  },
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: AppSizes.s,
                                                      ),

                                                      if (_fotoKTP.value !=
                                                              null ||
                                                          _fotoKK.value !=
                                                              null ||
                                                          _suratRT.value !=
                                                              null ||
                                                          _fotoRumah.value !=
                                                              null)
                                                        // Dokumen Pendukung
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .file_copy_rounded,
                                                              size: 20,
                                                              color: AppColors
                                                                  .primary,
                                                            ),
                                                            const SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              'Dokumen Pendukung',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: AppSizes
                                                                    .fontSizeM,
                                                                color: AppColors
                                                                    .textPrimary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                      if (_fotoKTP.value !=
                                                              null ||
                                                          _fotoKK.value !=
                                                              null ||
                                                          _suratRT.value !=
                                                              null ||
                                                          _fotoRumah.value !=
                                                              null)
                                                        const SizedBox(
                                                          height: AppSizes.s,
                                                        ),

                                                      if (_fotoKTP.value !=
                                                              null ||
                                                          _fotoKK.value !=
                                                              null ||
                                                          _suratRT.value !=
                                                              null ||
                                                          _fotoRumah.value !=
                                                              null)
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              EdgeInsets.all(
                                                                10,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  AppSizes
                                                                      .radiusM,
                                                                ),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              if (_fotoKTP
                                                                      .value !=
                                                                  null)
                                                                ValueListenableBuilder<
                                                                  File?
                                                                >(
                                                                  valueListenable:
                                                                      _fotoKTP,
                                                                  builder:
                                                                      (
                                                                        context,
                                                                        file,
                                                                        child,
                                                                      ) {
                                                                        return ValueListenableBuilder<
                                                                          DateTime?
                                                                        >(
                                                                          valueListenable:
                                                                              _fotoKTPUploadTime,
                                                                          builder:
                                                                              (
                                                                                context,
                                                                                uploadTime,
                                                                                child,
                                                                              ) {
                                                                                return ConfirmationFileItem(
                                                                                  fileName: _getFileNameForDisplay(
                                                                                    file,
                                                                                  ),
                                                                                  fileSize: _getFileSizeForDisplay(
                                                                                    file,
                                                                                  ),
                                                                                  timeAgo: _getTimeAgoForDisplay(
                                                                                    uploadTime,
                                                                                  ),
                                                                                  isImage: _isImageFile(
                                                                                    file,
                                                                                  ),
                                                                                );
                                                                              },
                                                                        );
                                                                      },
                                                                ),
                                                              if (_fotoKK
                                                                      .value !=
                                                                  null)
                                                                const SizedBox(
                                                                  height:
                                                                      AppSizes
                                                                          .s,
                                                                ),
                                                              if (_fotoKK
                                                                      .value !=
                                                                  null)
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 1,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              if (_fotoKK
                                                                      .value !=
                                                                  null)
                                                                const SizedBox(
                                                                  height:
                                                                      AppSizes
                                                                          .s,
                                                                ),

                                                              if (_fotoKK
                                                                      .value !=
                                                                  null)
                                                                ValueListenableBuilder<
                                                                  File?
                                                                >(
                                                                  valueListenable:
                                                                      _fotoKK,
                                                                  builder:
                                                                      (
                                                                        context,
                                                                        file,
                                                                        child,
                                                                      ) {
                                                                        return ValueListenableBuilder<
                                                                          DateTime?
                                                                        >(
                                                                          valueListenable:
                                                                              _fotoKKUploadTime,
                                                                          builder:
                                                                              (
                                                                                context,
                                                                                uploadTime,
                                                                                child,
                                                                              ) {
                                                                                return ConfirmationFileItem(
                                                                                  fileName: _getFileNameForDisplay(
                                                                                    file,
                                                                                  ),
                                                                                  fileSize: _getFileSizeForDisplay(
                                                                                    file,
                                                                                  ),
                                                                                  timeAgo: _getTimeAgoForDisplay(
                                                                                    uploadTime,
                                                                                  ),
                                                                                  isImage: _isImageFile(
                                                                                    file,
                                                                                  ),
                                                                                );
                                                                              },
                                                                        );
                                                                      },
                                                                ),
                                                              if (_suratRT
                                                                      .value !=
                                                                  null)
                                                                const SizedBox(
                                                                  height:
                                                                      AppSizes
                                                                          .s,
                                                                ),
                                                              if (_suratRT
                                                                      .value !=
                                                                  null)
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 1,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              if (_suratRT
                                                                      .value !=
                                                                  null)
                                                                const SizedBox(
                                                                  height:
                                                                      AppSizes
                                                                          .s,
                                                                ),

                                                              if (_suratRT
                                                                      .value !=
                                                                  null)
                                                                ValueListenableBuilder<
                                                                  File?
                                                                >(
                                                                  valueListenable:
                                                                      _suratRT,
                                                                  builder:
                                                                      (
                                                                        context,
                                                                        file,
                                                                        child,
                                                                      ) {
                                                                        return ValueListenableBuilder<
                                                                          DateTime?
                                                                        >(
                                                                          valueListenable:
                                                                              _suratRTUploadTime,
                                                                          builder:
                                                                              (
                                                                                context,
                                                                                uploadTime,
                                                                                child,
                                                                              ) {
                                                                                return ConfirmationFileItem(
                                                                                  fileName: _getFileNameForDisplay(
                                                                                    file,
                                                                                  ),
                                                                                  fileSize: _getFileSizeForDisplay(
                                                                                    file,
                                                                                  ),
                                                                                  timeAgo: _getTimeAgoForDisplay(
                                                                                    uploadTime,
                                                                                  ),
                                                                                  isImage: _isImageFile(
                                                                                    file,
                                                                                  ),
                                                                                );
                                                                              },
                                                                        );
                                                                      },
                                                                ),

                                                              if (_fotoRumah
                                                                      .value !=
                                                                  null)
                                                                const SizedBox(
                                                                  height:
                                                                      AppSizes
                                                                          .s,
                                                                ),
                                                              if (_fotoRumah
                                                                      .value !=
                                                                  null)
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 1,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              if (_fotoRumah
                                                                      .value !=
                                                                  null)
                                                                const SizedBox(
                                                                  height:
                                                                      AppSizes
                                                                          .s,
                                                                ),

                                                              if (_fotoRumah
                                                                      .value !=
                                                                  null)
                                                                ValueListenableBuilder<
                                                                  File?
                                                                >(
                                                                  valueListenable:
                                                                      _fotoRumah,
                                                                  builder:
                                                                      (
                                                                        context,
                                                                        file,
                                                                        child,
                                                                      ) {
                                                                        return ValueListenableBuilder<
                                                                          DateTime?
                                                                        >(
                                                                          valueListenable:
                                                                              _fotoRumahUploadTime,
                                                                          builder:
                                                                              (
                                                                                context,
                                                                                uploadTime,
                                                                                child,
                                                                              ) {
                                                                                return ConfirmationFileItem(
                                                                                  fileName: _getFileNameForDisplay(
                                                                                    file,
                                                                                  ),
                                                                                  fileSize: _getFileSizeForDisplay(
                                                                                    file,
                                                                                  ),
                                                                                  timeAgo: _getTimeAgoForDisplay(
                                                                                    uploadTime,
                                                                                  ),
                                                                                  isImage: _isImageFile(
                                                                                    file,
                                                                                  ),
                                                                                );
                                                                              },
                                                                        );
                                                                      },
                                                                ),
                                                            ],
                                                          ),
                                                        ),

                                                      const SizedBox(
                                                        height: AppSizes.s,
                                                      ),

                                                      ValueListenableBuilder<
                                                        bool
                                                      >(
                                                        valueListenable:
                                                            _showConfirmation,
                                                        builder: (context, isChecked, child) {
                                                          return InkWell(
                                                            onTap: () {
                                                              // Membalikkan nilai boolean
                                                              _showConfirmation
                                                                      .value =
                                                                  !_showConfirmation
                                                                      .value;
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Checkbox(
                                                                  value:
                                                                      isChecked,
                                                                  onChanged: (value) {
                                                                    () => _showConfirmation.value =
                                                                        value ??
                                                                        false;
                                                                  },
                                                                  visualDensity:
                                                                      VisualDensity
                                                                          .compact,
                                                                  materialTapTargetSize:
                                                                      MaterialTapTargetSize
                                                                          .shrinkWrap,
                                                                  activeColor:
                                                                      AppColors
                                                                          .primary,
                                                                ),
                                                                const SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    'Saya sudah memeriksa kebenaran data diatas.',
                                                                    style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          AppSizes
                                                                              .fontSizeXS,
                                                                      color: AppColors
                                                                          .textPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        height: AppSizes.s,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: ButtonWidthText(
                                                              text: 'Kembali',
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),

                                                              fontSize: AppSizes
                                                                  .fontSizeM,
                                                              colors: [
                                                                AppColors
                                                                    .secondary,
                                                                AppColors
                                                                    .orange1,
                                                                AppColors
                                                                    .orange6,
                                                                AppColors
                                                                    .orange1,
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    AppSizes
                                                                        .radiusFull,
                                                                  ),
                                                              gradient: true,
                                                              beginGradientAlignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                              endGradientAlignment:
                                                                  Alignment
                                                                      .centerRight,
                                                              textColor:
                                                                  Colors.white,
                                                              icon: const Icon(
                                                                Icons
                                                                    .arrow_back_ios_rounded,
                                                                size: 20,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              paddingHorizontal:
                                                                  AppSizes.s,
                                                              paddingVertical:
                                                                  AppSizes.s,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Flexible(
                                                            child: ButtonWidthText(
                                                              text: 'Kirim',
                                                              onPressed:
                                                                  _submitForm,
                                                              fontSize: AppSizes
                                                                  .fontSizeM,
                                                              colors: [
                                                                AppColors
                                                                    .primary,
                                                                AppColors.cyan1,
                                                                AppColors
                                                                    .background,
                                                                AppColors.cyan1,
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    AppSizes
                                                                        .radiusFull,
                                                                  ),
                                                              gradient: true,
                                                              beginGradientAlignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                              endGradientAlignment:
                                                                  Alignment
                                                                      .centerRight,
                                                              textColor:
                                                                  Colors.white,

                                                              paddingHorizontal:
                                                                  AppSizes.s,
                                                              paddingVertical:
                                                                  AppSizes.s,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      fontSize: AppSizes.fontSizeM,
                                      paddingVertical: 10,
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
        ),
        // 🔹 Overlay Loading Sukses (Minimalis)
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.6),
            child: const Center(child: Loading()),
          ),
      ],
    );
  }
}

class BuildTextField extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final int? minLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final Color focusedColor;
  final Color unfocusedColor;
  final Color unborderColor;
  final Color borderColor;

  const BuildTextField({
    super.key,
    required this.hintText,
    this.errorText,
    required this.controller,
    this.onChanged,
    this.validator,
    this.minLines,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.focusedColor = Colors.white,
    this.unfocusedColor = const Color.fromARGB(255, 252, 255, 255),
    this.unborderColor = AppColors.textSecondary,
    this.borderColor = AppColors.primary,
  });

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  Color get _fillColor {
    if (_isFocused.value) {
      return widget.focusedColor;
    }
    return widget.unfocusedColor;
  }

  @override
  void dispose() {
    _isFocused.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isFocused,
      builder: (context, isFocused, child) {
        return Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused.value = hasFocus;
            });
          },
          child: TextFormField(
            maxLines: widget.maxLines,
            scrollPhysics: AlwaysScrollableScrollPhysics(),
            minLines: widget.minLines,
            textAlign: TextAlign.start,
            controller: widget.controller,
            validator: widget.validator,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              hintStyle: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontSize: AppSizes.fontSizeS,
                fontWeight: FontWeight.w500,
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),

              filled: true,
              fillColor: _fillColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4,
                vertical: AppSizes.s,
              ),
              isDense: true,
              border: _buildBorder(),
              enabledBorder: _buildBorder(
                color: widget.unborderColor,
                width: 2,
              ),
              focusedBorder: _buildBorder(color: widget.borderColor, width: 2),
              errorBorder: _buildBorder(color: AppColors.error, width: 2),
              errorText: widget.errorText,
              errorStyle: GoogleFonts.poppins(
                fontSize: AppSizes.fontSizeXS,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: AppSizes.fontSizeS,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  OutlineInputBorder _buildBorder({Color? color, double width = 2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      borderSide: BorderSide(color: color ?? Colors.transparent, width: width),
    );
  }
}

class BuildDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final String? errorText;
  final String hint;
  final Color? hintColor;
  final Color? selectedItemColor;
  final Color? buttonColor;
  final Color? borderColor;
  final List<Color>? backgroundColor;
  final Color? borderButton;

  const BuildDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    required this.onChanged,
    this.errorText,
    required this.hint,
    this.hintColor = Colors.white,
    this.selectedItemColor = Colors.white,
    this.buttonColor = AppColors.primary,
    this.borderColor = AppColors.primary,
    this.borderButton = AppColors.primary,
    this.backgroundColor = const [
      AppColors.cyan1,
      AppColors.orange4,
      AppColors.orange4,
    ],
  });

  @override
  State<BuildDropdown> createState() => _BuildDropdownState();
}

class _BuildDropdownState extends State<BuildDropdown> {
  late String? selectedValue;
  String? hoveredItem;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant BuildDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      selectedValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true, // ⬅️ Ini yang penting!
        hint: Text(
          widget.hint,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSizeS,
            color: widget.hintColor,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        selectedItemBuilder: (context) {
          return widget.items.map((item) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item,
                style: GoogleFonts.poppins(
                  fontSize: AppSizes.fontSizeS,
                  color: widget.hintColor, // ⬅️ Warna berbeda untuk selected
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList();
        },
        items: widget.items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: _DropdownItem(
              item: item,
              borderColor: widget.borderColor,
              backgroundColor: widget.backgroundColor,
              textColor: widget.selectedItemColor,
              isSelected: selectedValue == item,
            ),
          );
        }).toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          widget.onChanged.call(value);
        },
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.only(
            right: AppSizes.xs,
            left: 10,
            bottom: 0,
            top: 0,
          ),
          height: 37,
          elevation: 0,
          decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
            border: widget.errorText != null
                ? Border.all(color: AppColors.error, width: 2)
                : Border.all(color: widget.borderButton!, width: 2),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          iconSize: 30,
          iconEnabledColor: widget.hintColor,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          // width: widget.width,
          padding: EdgeInsets.zero,
          elevation: 0,
          decoration: BoxDecoration(color: Colors.transparent),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.zero,
          height: 40,
        ),
      ),
    );
  }
}

// Widget terpisah untuk setiap item dengan state sendiri
class _DropdownItem extends StatefulWidget {
  final String item;
  final bool isSelected;
  final Color? borderColor;
  final Color? textColor;
  final List<Color>? backgroundColor;

  const _DropdownItem({
    required this.item,
    required this.isSelected,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isHovered,
      builder: (context, isHovered, child) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered.value = true),
          onExit: (_) => setState(() => _isHovered.value = false),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              color: _getItemBackgroundColor(isHovered),
              border: Border.all(color: widget.borderColor!, width: 2.0),
            ),
            child: Text(
              widget.item,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontSizeS,
                color: widget.textColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  Color? _getItemBackgroundColor(bool isHovered) {
    if (widget.isSelected) {
      return widget.backgroundColor?[2];
    }
    if (isHovered) {
      return widget.backgroundColor?[1];
    }
    return widget.backgroundColor?[0];
  }
}

class BuildRadioOption extends StatefulWidget {
  final String title;
  final String subTitle;
  final ValueNotifier<String> groupValueNotifier;
  const BuildRadioOption({
    super.key,
    required this.title,
    required this.subTitle,
    required this.groupValueNotifier,
  });

  @override
  State<BuildRadioOption> createState() => _BuildRadioOptionState();
}

class _BuildRadioOptionState extends State<BuildRadioOption> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.groupValueNotifier,
      builder: (context, groupValue, child) {
        // Cek apakah opsi ini sedang dipilih
        final bool isSelected = groupValue == widget.title;
        return InkWell(
          onTap: () {
            // Ketika container diklik, update notifier
            widget.groupValueNotifier.value = widget.title;
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusXS),
              child: Stack(
                children: [
                  if (isSelected)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(width: 5, color: AppColors.primary),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicWidth(
                        child: RadioListTile<String>(
                          value: widget.title,
                          groupValue: groupValue,
                          onChanged: (value) {
                            widget.groupValueNotifier.value = value!;
                          },
                          activeColor: AppColors.primary,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeS,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.subTitle,
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeXS,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BuildUploadButton extends StatefulWidget {
  final String title;
  final File? file;
  final ValueNotifier<File?>? fileNotifier;
  final VoidCallback onTap;
  final String? subtitle;
  final bool showPreview;

  const BuildUploadButton({
    super.key,
    required this.title,
    this.file,
    this.fileNotifier,
    required this.onTap,
    this.subtitle,
    this.showPreview = false,
  });

  @override
  State<BuildUploadButton> createState() => _BuildUploadButtonState();
}

class _BuildUploadButtonState extends State<BuildUploadButton> {
  // Fungsi untuk mengecek apakah file adalah gambar
  bool _isImageFile(File? file) {
    if (file == null) return false;
    final path = file.path.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.gif');
  }

  @override
  Widget build(BuildContext context) {
    // Jika ada fileNotifier, gunakan ValueListenableBuilder
    if (widget.fileNotifier != null) {
      return ValueListenableBuilder<File?>(
        valueListenable: widget.fileNotifier!,
        builder: (context, file, child) {
          return _buildButton(file);
        },
      );
    }

    // Jika tidak ada fileNotifier, gunakan file biasa
    return _buildButton(widget.file);
  }

  Widget _buildButton(File? file) {
    final hasFile = file != null;
    final isImage = hasFile && widget.showPreview && _isImageFile(file);

    final subtitleText = hasFile
        ? _getFileName(file)
        : (widget.subtitle ?? 'Tap untuk upload');

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: hasFile ? Color(0xFFDCFCE7) : Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasFile
                ? Color(0xFF16A34A)
                : AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasFile && isImage && widget.showPreview)
              _buildImagePreview(file)
            else if (hasFile && !isImage && widget.showPreview)
              _buildDocumentPreview()
            else
              _buildIcon(hasFile, isImage),

            if (!hasFile) SizedBox(height: 6),

            if (!hasFile)
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: hasFile ? Color(0xFF16A34A) : Color(0xFF0F766E),
                ),
                textAlign: TextAlign.center,
              ),
            Text(
              subtitleText,
              style: GoogleFonts.poppins(
                fontSize: 10,
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

  Widget _buildIcon(bool hasFile, bool isImage) {
    return Icon(
      hasFile ? Icons.check_circle : Icons.description,
      color: hasFile ? Color(0xFF16A34A) : Color(0xFF0F766E),
      size: 24,
    );
  }

  Widget _buildImagePreview(File imageFile) {
    return Container(
      width: 70,
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover),
        border: Border.all(color: Color(0xFF16A34A), width: 1),
      ),
      child: Stack(
        children: [
          // Overlay hijau transparan untuk menunjukkan sudah terpilih
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(0xFF16A34A).withOpacity(0.1),
            ),
          ),
          // Centang di pojok
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Color(0xFF16A34A),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 8, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentPreview() {
    return Container(
      width: 70,
      height: 47,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 227, 227),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red[700]!, width: 1),
      ),
      child: Center(
        child: Icon(Icons.picture_as_pdf, color: Colors.red[700], size: 24),
      ),
    );
  }

  // Method untuk mendapatkan nama file
  String _getFileName(File file) {
    final path = file.path;
    final fileName = path.split('/').last;

    if (fileName.length > 20) {
      final extension = fileName.split('.').last;
      final nameWithoutExt = fileName.substring(0, fileName.lastIndexOf('.'));
      final shortenedName = '${nameWithoutExt.substring(0, 15)}...';
      return '$shortenedName.$extension';
    }

    return fileName;
  }
}

class BuildImagePicker extends StatefulWidget {
  final String title;
  final File? imageFile;
  final ValueNotifier<File?>? imageNotifier;
  final VoidCallback onTap;
  final String? subtitle;
  final bool showPreview;

  const BuildImagePicker({
    super.key,
    required this.title,
    this.imageFile,
    this.imageNotifier,
    required this.onTap,
    this.subtitle,
    this.showPreview = true,
  });

  @override
  State<BuildImagePicker> createState() => _BuildImagePickerState();
}

class _BuildImagePickerState extends State<BuildImagePicker> {
  @override
  Widget build(BuildContext context) {
    // Jika ada imageNotifier, gunakan ValueListenableBuilder
    if (widget.imageNotifier != null) {
      return ValueListenableBuilder<File?>(
        valueListenable: widget.imageNotifier!,
        builder: (context, imageFile, child) {
          return _buildButton(imageFile);
        },
      );
    }

    // Jika tidak ada imageNotifier, gunakan imageFile biasa
    return _buildButton(widget.imageFile);
  }

  Widget _buildButton(File? imageFile) {
    final hasImage = imageFile != null;
    final subtitleText = hasImage
        ? _getFileName(imageFile)
        : (widget.subtitle ?? 'Tap untuk ambil foto');

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: hasImage ? Color(0xFFDCFCE7) : Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasImage
                ? Color(0xFF16A34A)
                : AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasImage && widget.showPreview)
              _buildImagePreview(imageFile)
            else
              _buildIcon(hasImage),
            if (!hasImage) SizedBox(height: 6),
            if (!hasImage)
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: hasImage ? Color(0xFF16A34A) : Color(0xFF0F766E),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              subtitleText,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: hasImage ? Color(0xFF15803D) : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(bool hasImage) {
    return Icon(
      hasImage ? Icons.photo_camera : Icons.camera_alt_rounded,
      color: hasImage ? Color(0xFF16A34A) : Color(0xFF0F766E),
      size: 24,
    );
  }

  Widget _buildImagePreview(File imageFile) {
    return Container(
      width: 70,
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover),
        border: Border.all(color: Color(0xFF16A34A), width: 1),
      ),
      child: Stack(
        children: [
          // Overlay hijau transparan untuk menunjukkan sudah terpilih
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(0xFF16A34A).withOpacity(0.1),
            ),
          ),
          // Centang di pojok
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Color(0xFF16A34A),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 8, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _getFileName(File file) {
    final path = file.path;
    final fileName = path.split('/').last;

    // Potong nama file jika terlalu panjang
    if (fileName.length > 18) {
      final extension = fileName.split('.').last;
      final nameWithoutExt = fileName.substring(0, fileName.lastIndexOf('.'));
      final shortenedName = '${nameWithoutExt.substring(0, 12)}...';
      return '$shortenedName.$extension';
    }

    return fileName;
  }
}

class ConfirmationFileItem extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final String timeAgo;
  final bool isImage;
  const ConfirmationFileItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.timeAgo,
    this.isImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon berdasarkan tipe file
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isImage
                ? Color.fromARGB(255, 228, 255, 238)
                : const Color.fromARGB(255, 255, 227, 227),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            isImage ? Icons.image : Icons.picture_as_pdf,
            color: isImage ? Color(0xFF16A34A) : Colors.red[700],
            size: 24,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: GoogleFonts.poppins(
                  fontSize: AppSizes.fontSizeS,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '$fileSize · Diunggah $timeAgo',
                style: GoogleFonts.poppins(
                  fontSize: AppSizes.fontSizeXS,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
