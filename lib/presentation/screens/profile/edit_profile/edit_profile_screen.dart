import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/presentation/screens/service/skd/skd_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sandu_app/presentation/widgets/button_width_text.dart';
import 'package:sandu_app/presentation/widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  // State Pressed
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);

  // ✅ Dummy Profile Data (simulasi data yang sudah tersimpan)
  final Map<String, dynamic> profileData = {
    'foto': 'assets/images/profile.jpg', // path foto profil
    'namaLengkap': 'Dandy Taufiqurrochman',
    'namaPanggilan': 'Dandy_tr2412',
    'nik': '32078765433',
    'tanggalLahir': '24-12-2004',
    'jenisKelamin': 'L', // L atau P
    'nomorHP': '0876543345543',
    'isPhoneVerified': true,
    'email': 'dandy.taufiqurrochman@gmail.com',
    'alamatLengkap': 'Desa Utama Dusun Wetan RT 06 RW 02',
    'dusun': 'Wetan',
    'rt': '06',
    'rw': '02',
    'tipeDomisili': 'Tetap', // Tetap atau Sementara
    'pekerjaan': 'Developper',
    'pendidikanTerakhir': 'Sarjana',
    'bahasa': 'Indonesia / Sunda',
    'namaUsaha': 'Buat Website',
    'notifPush': true,
    'notifSMS': true,
    'notifEmail': true,
    'is2FAEnabled': false,
    'dokumenKTP': null,
    'dokumenKK': null,
  };

  // Controllers
  late TextEditingController _namaLengkapController;
  late TextEditingController _namaPanggilanController;
  late TextEditingController _nikController;
  late TextEditingController _tglLahirController;
  late TextEditingController _nomorHPController;
  late TextEditingController _emailController;
  late TextEditingController _alamatController;
  late TextEditingController _pekerjaanController;
  late TextEditingController _pendidikanController;
  late TextEditingController _namaUsahaController;

  // State
  final ValueNotifier<String?> _selectedJenisKelamin = ValueNotifier(null);
  final ValueNotifier<String?> _selectedDusun = ValueNotifier(null);
  final ValueNotifier<String?> _selectedRT = ValueNotifier(null);
  final ValueNotifier<String?> _selectedRW = ValueNotifier(null);
  final ValueNotifier<String?> _selectedTipeDomisili = ValueNotifier(null);
  final ValueNotifier<String?> _selectedBahasa = ValueNotifier(null);
  final ValueNotifier<bool> _notifPush = ValueNotifier(false);
  final ValueNotifier<bool> _notifSMS = ValueNotifier(false);
  final ValueNotifier<bool> _notifEmail = ValueNotifier(false);
  final ValueNotifier<bool> _is2FAEnabled = ValueNotifier(false);
  final ValueNotifier<String?> _currentLocation = ValueNotifier(null);
  final ValueNotifier<Position?> _currentPosition = ValueNotifier(null);

  final ValueNotifier<File?> _profileImage = ValueNotifier(null);
  final ValueNotifier<File?> _dokumenKTP = ValueNotifier(null);
  final ValueNotifier<File?> _dokumenKK = ValueNotifier(null);

  // Options
  final List<String> _dusunOptions = [
    'Cihideung',
    'Bojong Nangoh',
    'Wetan',
    'Kulon',
  ];
  final List<String> _rtOptions = List.generate(
    15,
    (i) => '${i + 1}'.padLeft(2, '0'),
  );
  final List<String> _rwOptions = List.generate(
    10,
    (i) => '${i + 1}'.padLeft(2, '0'),
  );
  final List<String> _bahasaOptions = [
    'Indonesia / Sunda',
    'Indonesia / Jawa',
    'Indonesia / Betawi',
    'Lainnya',
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // ✅ Load data dari profileData (jika ada)
    _namaLengkapController = TextEditingController(
      text: profileData['namaLengkap'] ?? '',
    );
    _namaPanggilanController = TextEditingController(
      text: profileData['namaPanggilan'] ?? '',
    );
    _nikController = TextEditingController(text: profileData['nik'] ?? '');
    _tglLahirController = TextEditingController(
      text: profileData['tanggalLahir'] ?? '',
    );
    _nomorHPController = TextEditingController(
      text: profileData['nomorHP'] ?? '',
    );
    _emailController = TextEditingController(text: profileData['email'] ?? '');
    _alamatController = TextEditingController(
      text: profileData['alamatLengkap'] ?? '',
    );
    _pekerjaanController = TextEditingController(
      text: profileData['pekerjaan'] ?? '',
    );
    _pendidikanController = TextEditingController(
      text: profileData['pendidikanTerakhir'] ?? '',
    );
    _namaUsahaController = TextEditingController(
      text: profileData['namaUsaha'] ?? '',
    );

    // Load state values
    _selectedJenisKelamin.value = profileData['jenisKelamin'];
    _selectedDusun.value = profileData['dusun'];
    _selectedRT.value = profileData['rt'];
    _selectedRW.value = profileData['rw'];
    _selectedTipeDomisili.value = profileData['tipeDomisili'];
    _selectedBahasa.value = profileData['bahasa'];
    _notifPush.value = profileData['notifPush'] ?? false;
    _notifSMS.value = profileData['notifSMS'] ?? false;
    _notifEmail.value = profileData['notifEmail'] ?? false;
    _is2FAEnabled.value = profileData['is2FAEnabled'] ?? false;
    _dokumenKTP.value = null;
    _dokumenKK.value = null;
  }

  Future<void> _pickProfileImage() async {
    _isPressed.value = false;
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      _profileImage.value = File(image.path);
    }
  }

  Future<void> _pickDocument(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);

      if (type == 'ktp') {
        _dokumenKTP.value = file;
      } else if (type == 'kk') {
        _dokumenKK.value = file;
      }
    }
  }

  void _removeDocument(String type) {
    if (type == 'ktp') {
      _dokumenKTP.value = null;
    } else if (type == 'kk') {
      _dokumenKK.value = null;
    }
  }

  // ✅ Function untuk ambil lokasi
  Future<void> _getCurrentLocation() async {
    // Contoh implementasi dengan geolocator:
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // ✅ Simpan position
        _currentPosition.value = position;

        // Convert ke alamat dengan geocoding
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];

          _currentLocation.value =
              "${place.street}, ${place.subLocality}, ${place.locality}";
        }
      }
    } catch (e) {
      print('Error getting location: $e');
      // Optional: Tampilkan snackbar error
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mendapatkan lokasi: $e')));
      }
    }
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Perubahan berhasil disimpan!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontSizeS,
          ),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _namaPanggilanController.dispose();
    _nikController.dispose();
    _tglLahirController.dispose();
    _nomorHPController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _pekerjaanController.dispose();
    _pendidikanController.dispose();
    _namaUsahaController.dispose();
    _selectedJenisKelamin.dispose();
    _isPressed.dispose();
    _selectedDusun.dispose();
    _selectedRT.dispose();
    _selectedRW.dispose();
    _selectedTipeDomisili.dispose();
    _selectedBahasa.dispose();
    _notifPush.dispose();
    _notifSMS.dispose();
    _notifEmail.dispose();
    _is2FAEnabled.dispose();
    _currentLocation.dispose();
    _currentPosition.dispose();
    _profileImage.dispose();
    _dokumenKTP.dispose();
    _dokumenKK.dispose();
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
          'Edit Profil',
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
          Positioned.fill(
            top: 0,
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.background2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusM),
                  topRight: Radius.circular(AppSizes.radiusM),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.s),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Picture
                          ValueListenableBuilder<File?>(
                            valueListenable: _profileImage,
                            builder: (context, profileImage, child) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,
                                    backgroundImage: profileImage != null
                                        ? FileImage(profileImage)
                                        : (profileData['foto'] != null
                                                  ? AssetImage(
                                                      profileData['foto'],
                                                    )
                                                  : null)
                                              as ImageProvider?,

                                    child:
                                        profileImage == null &&
                                            profileData['foto'] == null
                                        ? Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.grey,
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: -15,
                                    child: ValueListenableBuilder<bool>(
                                      valueListenable: _isPressed,
                                      builder: (context, isPressed, child) {
                                        return GestureDetector(
                                          onTapDown: (_) =>
                                              _isPressed.value = true,
                                          onTapUp: (_) =>
                                              _isPressed.value = false,
                                          onTapCancel: () =>
                                              _isPressed.value = false,
                                          onTap: _pickProfileImage,
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: isPressed
                                                  ? AppColors.cyan1
                                                  : Colors.white,
                                              border: Border.all(
                                                color: isPressed
                                                    ? AppColors.cyan1
                                                    : AppColors.primary,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.camera_alt,
                                                  color: isPressed
                                                      ? Colors.white
                                                      : AppColors.primary,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'Ubah Foto',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        AppSizes.fontSizeXS,
                                                    color: isPressed
                                                        ? Colors.white
                                                        : AppColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: AppSizes.m),
                                Text(
                                  _namaPanggilanController.text.isNotEmpty
                                      ? _namaPanggilanController.text
                                      : 'Nama Pengguna',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textPrimary,
                                    fontSize: AppSizes.fontSizeL,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 8),
                                IntrinsicWidth(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green.shade400,
                                          size: 17,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Terverifikasi',
                                          style: GoogleFonts.poppins(
                                            color: Colors.green.shade400,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Terakhir: 21 Okt 2025',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.l),

                      // warning
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(AppSizes.radiusS),
                          border: Border.all(
                            color: Colors.red.shade100,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  size: 25,
                                  color: Colors.red[800],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Perubahan NIK atau data RT/RW akan memicu proses verifikasi ulang akun anda.',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeXS,
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSizes.s),

                      // identitas
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'IDENTITAS',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.s),

                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: AppSizes.s),

                                  Text(
                                    'Nama Lengkap:',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.xs),

                                  BuildTextField(
                                    hintText: 'Masukkan nama lengkap',
                                    controller: _namaLengkapController,
                                    focusedColor: Colors.grey.shade50,
                                    unfocusedColor: Colors.grey.shade100,
                                    borderColor: Colors.grey.shade400,
                                    unborderColor: Colors.grey.shade200,
                                  ),
                                  const SizedBox(height: AppSizes.s),
                                  Text(
                                    'Nama Panggilan:',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.xs),

                                  BuildTextField(
                                    hintText: 'Masukkan nama panggilan',
                                    controller: _namaPanggilanController,
                                    focusedColor: Colors.grey.shade50,
                                    unfocusedColor: Colors.grey.shade100,
                                    borderColor: Colors.grey.shade400,
                                    unborderColor: Colors.grey.shade200,
                                  ),

                                  const SizedBox(height: AppSizes.s),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'NIK:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeS,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: AppSizes.xs),
                                            BuildTextField(
                                              hintText: 'Masukkan NIK',
                                              controller: _nikController,
                                              focusedColor: Colors.grey.shade50,
                                              unfocusedColor:
                                                  Colors.grey.shade100,
                                              borderColor: Colors.grey.shade400,
                                              unborderColor:
                                                  Colors.grey.shade200,
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
                                            Text(
                                              'Tanggal Lahir:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeS,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: AppSizes.xs),
                                            BuildDateField(
                                              hintText: 'YYYY-MM-DD',
                                              controller: _tglLahirController,
                                              focusedColor: Colors.grey.shade50,
                                              unfocusedColor:
                                                  Colors.grey.shade100,
                                              borderColor: Colors.grey.shade400,
                                              unborderColor:
                                                  Colors.grey.shade200,
                                              suffixIcon: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 4,
                                                ),
                                                child: Icon(
                                                  Icons.calendar_month_rounded,
                                                  size: 20,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: AppSizes.s),

                                  Text(
                                    'Jenis Kelamin:',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.xs),
                                  ValueListenableBuilder<String?>(
                                    valueListenable: _selectedJenisKelamin,
                                    builder: (context, selectedValue, child) {
                                      return Row(
                                        children: [
                                          // Radio untuk Laki-laki
                                          BuildRadioButton(
                                            title: 'Laki-laki',
                                            value: 'L',
                                            groupValueNotifier:
                                                _selectedJenisKelamin,
                                          ),
                                          SizedBox(width: AppSizes.l),
                                          // Radio untuk Perempuan
                                          BuildRadioButton(
                                            title: 'Perempuan',
                                            value: 'P',
                                            groupValueNotifier:
                                                _selectedJenisKelamin,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSizes.s),

                            // kontak
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'KONTAK',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.s),

                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: AppSizes.s),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'No HP:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeS,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: AppSizes.xs),

                                            BuildTextField(
                                              hintText: 'Masukkan no HP',
                                              controller: _nomorHPController,
                                              focusedColor: Colors.grey.shade50,
                                              unfocusedColor:
                                                  Colors.grey.shade100,
                                              borderColor: Colors.grey.shade400,
                                              unborderColor:
                                                  Colors.grey.shade200,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: AppSizes.xs),

                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            // Verifikasi No HP
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.resolveWith<
                                                  Color?
                                                >((states) {
                                                  if (states.contains(
                                                    WidgetState.pressed,
                                                  )) {
                                                    return AppColors
                                                        .primary; // Warna saat ditekan
                                                  }
                                                  if (states.contains(
                                                    WidgetState.hovered,
                                                  )) {
                                                    return AppColors
                                                        .primary; // Warna saat hover (desktop/web)
                                                  }
                                                  return null; // Background transparan di kondisi normal
                                                }),
                                            foregroundColor:
                                                WidgetStateProperty.resolveWith<
                                                  Color?
                                                >((states) {
                                                  if (states.contains(
                                                    WidgetState.pressed,
                                                  )) {
                                                    return Colors
                                                        .white; // Teks jadi putih saat background biru (ditekan)
                                                  }
                                                  if (states.contains(
                                                    WidgetState.hovered,
                                                  )) {
                                                    return Colors
                                                        .white; // Teks berubah warna saat hover
                                                  }
                                                  return AppColors
                                                      .primary; // Warna teks default
                                                }),
                                            side: WidgetStateProperty.all(
                                              const BorderSide(
                                                color: AppColors.primary,
                                                width: 2,
                                              ),
                                            ),
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppSizes.radiusS,
                                                    ),
                                              ),
                                            ),
                                            padding: WidgetStateProperty.all(
                                              EdgeInsets.symmetric(
                                                vertical: AppSizes.s,
                                              ),
                                            ),
                                            minimumSize:
                                                WidgetStateProperty.all(
                                                  Size.zero,
                                                ),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.phonelink_ring_rounded,
                                                size: 17,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                'Verifikasi No HP',
                                                style: GoogleFonts.poppins(
                                                  fontSize: AppSizes.fontSizeS,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSizes.s),
                                  Text(
                                    'Email:',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.xs),

                                  BuildTextField(
                                    hintText: 'Masukkan email',
                                    controller: _emailController,
                                    focusedColor: Colors.grey.shade50,
                                    unfocusedColor: Colors.grey.shade100,
                                    borderColor: Colors.grey.shade400,
                                    unborderColor: Colors.grey.shade200,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSizes.s),

                            // alamat & domisili
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ALAMAT & DOMISILI',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.s),

                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: AppSizes.s),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Alamat Lengkap:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeS,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: AppSizes.xs),
                                            BuildTextField(
                                              hintText:
                                                  'Masukkan alamat lengkap',
                                              controller: _alamatController,
                                              focusedColor: Colors.grey.shade50,
                                              unfocusedColor:
                                                  Colors.grey.shade100,
                                              borderColor: Colors.grey.shade400,
                                              unborderColor:
                                                  Colors.grey.shade200,
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
                                            Text(
                                              'Dusun:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeS,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: AppSizes.xs),
                                            ValueListenableBuilder<String?>(
                                              valueListenable: _selectedDusun,
                                              builder: (context, value, child) {
                                                return BuildDropdown(
                                                  hint: 'Pilih Dusun',
                                                  label: 'Dusun',
                                                  items: _dusunOptions,
                                                  value:
                                                      value, // ← Nilai dari ValueNotifier
                                                  onChanged: (newValue) {
                                                    _selectedDusun.value =
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'RT:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeS,
                                                color: AppColors.textSecondary,
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
                                                  value:
                                                      value, // ← Nilai dari ValueNotifier
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
                                            Text(
                                              'RW:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeS,
                                                color: AppColors.textSecondary,
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

                                  Text(
                                    'Tipe Domisili:',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.xs),
                                  ValueListenableBuilder<String?>(
                                    valueListenable: _selectedTipeDomisili,
                                    builder: (context, selectedValue, child) {
                                      return Row(
                                        children: [
                                          // Radio untuk Laki-laki
                                          BuildRadioButton(
                                            title: 'Tetap',
                                            value: 'Tetap',
                                            groupValueNotifier:
                                                _selectedTipeDomisili,
                                          ),
                                          SizedBox(width: AppSizes.l),
                                          // Radio untuk Perempuan
                                          BuildRadioButton(
                                            title: 'Sementara',
                                            value: 'Sementara',
                                            groupValueNotifier:
                                                _selectedTipeDomisili,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: AppSizes.s),
                                  BuildLocationButton(
                                    currentLocation: _currentLocation,
                                    onGetLocation: _getCurrentLocation,
                                    currentPosition: _currentPosition,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSizes.s),

                            // dokumen
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DOKUMEN',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.s),

                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: AppSizes.s),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: BuildDocumentCard(
                                          title: 'Foto KTP',
                                          documentNotifier: _dokumenKTP,
                                          // onUpload: () => _pickDocument('ktp'),
                                          onRemove: () =>
                                              _removeDocument('ktp'),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: BuildDocumentCard(
                                          title: 'Foto KK',
                                          documentNotifier: _dokumenKK,
                                          // onUpload: () => _pickDocument('kk'),
                                          onRemove: () => _removeDocument('kk'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(
                                                context,
                                              ).viewInsets.bottom,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .white, // ✅ WAJIB ada!
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                      ),
                                                ),
                                                padding: EdgeInsets.all(15),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ButtonWidthText(
                                                      text: 'Upload KTP',
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _pickDocument('ktp');
                                                      },
                                                      fontSize:
                                                          AppSizes.fontSizeM,
                                                      colors: [
                                                        AppColors.primary,
                                                        AppColors.cyan1,
                                                        AppColors.background,
                                                        AppColors.cyan1,
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            AppSizes.radiusS,
                                                          ),
                                                      gradient: true,
                                                      beginGradientAlignment:
                                                          Alignment.centerLeft,
                                                      endGradientAlignment:
                                                          Alignment.centerRight,
                                                      textColor: Colors.white,
                                                      icon: const Icon(
                                                        Icons.photo_library,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                      paddingHorizontal:
                                                          AppSizes.s,
                                                      paddingVertical:
                                                          AppSizes.s,
                                                    ),
                                                    const SizedBox(
                                                      height: AppSizes.s,
                                                    ),
                                                    ButtonWidthText(
                                                      text: 'Upload KK',
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _pickDocument('kk');
                                                      },
                                                      fontSize:
                                                          AppSizes.fontSizeM,
                                                      colors: [
                                                        AppColors.secondary,
                                                        AppColors.orange1,
                                                        AppColors.orange6,
                                                        AppColors.orange1,
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            AppSizes.radiusS,
                                                          ),
                                                      gradient: true,
                                                      beginGradientAlignment:
                                                          Alignment.centerLeft,
                                                      endGradientAlignment:
                                                          Alignment.centerRight,
                                                      textColor: Colors.white,
                                                      icon: const Icon(
                                                        Icons.photo_library,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                      paddingHorizontal:
                                                          AppSizes.s,
                                                      paddingVertical:
                                                          AppSizes.s,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.resolveWith<
                                              Color?
                                            >((states) {
                                              if (states.contains(
                                                WidgetState.pressed,
                                              )) {
                                                return AppColors
                                                    .primary; // Warna saat ditekan
                                              }
                                              if (states.contains(
                                                WidgetState.hovered,
                                              )) {
                                                return AppColors
                                                    .primary; // Warna saat hover (desktop/web)
                                              }
                                              return null; // Background transparan di kondisi normal
                                            }),
                                        foregroundColor:
                                            WidgetStateProperty.resolveWith<
                                              Color?
                                            >((states) {
                                              if (states.contains(
                                                WidgetState.pressed,
                                              )) {
                                                return Colors
                                                    .white; // Teks jadi putih saat background biru (ditekan)
                                              }
                                              if (states.contains(
                                                WidgetState.hovered,
                                              )) {
                                                return Colors
                                                    .white; // Teks berubah warna saat hover
                                              }
                                              return AppColors
                                                  .primary; // Warna teks default
                                            }),
                                        side: WidgetStateProperty.all(
                                          const BorderSide(
                                            color: AppColors.primary,
                                            width: 2,
                                          ),
                                        ),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSizes.radiusS,
                                            ),
                                          ),
                                        ),
                                        padding: WidgetStateProperty.all(
                                          EdgeInsets.symmetric(
                                            vertical: AppSizes.s,
                                          ),
                                        ),
                                        minimumSize: WidgetStateProperty.all(
                                          Size.zero,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Unggah Dokumen Baru',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: AppSizes.fontSizeS,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSizes.s),

                            // informasi tambahan
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'INFORMASI TAMBAHAN',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSizeS,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.s),

                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: AppSizes.s),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pekerjaan:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeXS,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: AppSizes.xs),
                                            BuildTextField(
                                              hintText:
                                                  'Masukkan pekerjaan anda',
                                              controller: _pekerjaanController,
                                              focusedColor: Colors.grey.shade50,
                                              unfocusedColor:
                                                  Colors.grey.shade100,
                                              borderColor: Colors.grey.shade400,
                                              unborderColor:
                                                  Colors.grey.shade200,
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
                                            Text(
                                              'Pendidikan Terakhir:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeXS,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: AppSizes.xs),
                                            BuildTextField(
                                              hintText:
                                                  'Masukkan pendidikan anda',
                                              controller: _pendidikanController,
                                              focusedColor: Colors.grey.shade50,
                                              unfocusedColor:
                                                  Colors.grey.shade100,
                                              borderColor: Colors.grey.shade400,
                                              unborderColor:
                                                  Colors.grey.shade200,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSizes.s),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Bahasa:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeXS,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: AppSizes.xs),
                                            ValueListenableBuilder<String?>(
                                              valueListenable: _selectedBahasa,
                                              builder: (context, value, child) {
                                                return BuildDropdown(
                                                  hint: 'Pilih Bahasa',
                                                  label: 'Bahasa',
                                                  items: _bahasaOptions,
                                                  value:
                                                      value, // ← Nilai dari ValueNotifier
                                                  onChanged: (newValue) {
                                                    _selectedBahasa.value =
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
                                            Text(
                                              'Jia UMKM: Nama Usaha:',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppSizes.fontSizeXS,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: AppSizes.xs),
                                            BuildTextField(
                                              hintText:
                                                  'Masukkan nama usaha anda',
                                              controller: _namaUsahaController,
                                              focusedColor: Colors.grey.shade50,
                                              unfocusedColor:
                                                  Colors.grey.shade100,
                                              borderColor: Colors.grey.shade400,
                                              unborderColor:
                                                  Colors.grey.shade200,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSizes.s),
                            Row(
                              children: [
                                Flexible(
                                  child: ButtonWidthText(
                                    text: 'Kembali',
                                    onPressed: () => Navigator.pop(context),

                                    fontSize: AppSizes.fontSizeM,
                                    colors: [
                                      AppColors.secondary,
                                      AppColors.orange1,
                                      AppColors.orange6,
                                      AppColors.orange1,
                                    ],
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusFull,
                                    ),
                                    gradient: true,
                                    beginGradientAlignment:
                                        Alignment.centerLeft,
                                    endGradientAlignment: Alignment.centerRight,
                                    textColor: Colors.white,
                                    icon: const Icon(
                                      Icons.arrow_back_ios_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    paddingHorizontal: AppSizes.s,
                                    paddingVertical: AppSizes.s,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: ButtonWidthText(
                                    text: 'Kirim',
                                    onPressed: _saveProfile,
                                    fontSize: AppSizes.fontSizeM,
                                    colors: [
                                      AppColors.primary,
                                      AppColors.cyan1,
                                      AppColors.background,
                                      AppColors.cyan1,
                                    ],
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusFull,
                                    ),
                                    gradient: true,
                                    beginGradientAlignment:
                                        Alignment.centerLeft,
                                    endGradientAlignment: Alignment.centerRight,
                                    textColor: Colors.white,

                                    paddingHorizontal: AppSizes.s,
                                    paddingVertical: AppSizes.s,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.m),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildDateField extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final int? minLines;
  final Widget? suffixIcon;
  final int maxLines;
  final Color focusedColor;
  final Color unfocusedColor;
  final Color unborderColor;
  final Color borderColor;

  const BuildDateField({
    super.key,
    required this.hintText,
    this.errorText,
    required this.controller,
    this.onChanged,
    this.validator,
    this.minLines,
    this.suffixIcon,
    this.maxLines = 1,
    this.focusedColor = Colors.white,
    this.unfocusedColor = const Color.fromARGB(255, 252, 255, 255),
    this.unborderColor = AppColors.textSecondary,
    this.borderColor = AppColors.primary,
  });

  @override
  State<BuildDateField> createState() => _BuildDateFieldState();
}

class _BuildDateFieldState extends State<BuildDateField> {
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
            readOnly: true,
            scrollPhysics: AlwaysScrollableScrollPhysics(),
            minLines: widget.minLines,
            textAlign: TextAlign.start,
            controller: widget.controller,
            validator: widget.validator,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
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
              suffixIconConstraints: BoxConstraints(
                minWidth: 24, // Atur lebar minimal sesuai kebutuhan
                minHeight: 24,
              ),
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
            onTap: () async {
              // 2. Tampilkan date picker saat field diklik
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Tanggal awal saat dialog dibuka
                firstDate: DateTime(2000), // Batas minimum tanggal
                lastDate: DateTime(2100), // Batas maksimum tanggal
              );

              if (pickedDate != null) {
                // 3. Format dan masukkan hasil ke controller
                // Gunakan paket 'intl' untuk format yang lebih rapi (misal: yyyy-MM-dd)
                setState(() {
                  widget.controller.text = "${pickedDate.toLocal()}".split(
                    ' ',
                  )[0];
                });
              }
            },
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

class BuildRadioButton extends StatefulWidget {
  final String title;
  final String value;
  final ValueNotifier<String?> groupValueNotifier;

  const BuildRadioButton({
    super.key,
    required this.title,
    required this.value,
    required this.groupValueNotifier,
  });

  @override
  State<BuildRadioButton> createState() => _BuildRadioButtonState();
}

class _BuildRadioButtonState extends State<BuildRadioButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.groupValueNotifier,
      builder: (context, groupValue, child) {
        // Cek apakah opsi ini sedang dipilih
        return InkWell(
          onTap: () {
            // Ketika container diklik, update notifier
            widget.groupValueNotifier.value = widget.value;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IntrinsicWidth(
                child: Radio<String>(
                  value: widget.value,
                  // ignore: deprecated_member_use
                  groupValue: groupValue,
                  // ignore: deprecated_member_use
                  onChanged: (value) {
                    widget.groupValueNotifier.value = value!;
                  },
                  activeColor: AppColors.primary,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: AppSizes.fontSizeS,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BuildLocationButton extends StatelessWidget {
  final ValueNotifier<String?> currentLocation;
  final ValueNotifier<Position?> currentPosition;
  final VoidCallback onGetLocation;
  const BuildLocationButton({
    super.key,
    required this.currentLocation,
    required this.currentPosition,
    required this.onGetLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: currentLocation,
      builder: (context, current, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onGetLocation,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed))
                          return AppColors.cyan1; // Saat ditekan
                        if (states.contains(WidgetState.hovered))
                          return AppColors.cyan1; // Saat hover
                        return AppColors.primary; // Default
                      }),
                      // elevation: 0,
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                      ),
                      minimumSize: WidgetStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusS),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 20),

                        Flexible(
                          child: Text(
                            current ?? 'Ambil Lokasi Sekarang',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeXS,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (current == null) ...[
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background2,
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child:
                        // Address Info
                        Padding(
                          padding: EdgeInsets.all(9),
                          child: Icon(
                            Icons.location_off_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                  ),
                ],

                if (current != null) ...[
                  SizedBox(width: 8),
                  Builder(
                    builder: (BuildContext btnContext) {
                      return IconButton(
                        onPressed: () {
                          // ✅ Gunakan context dari Builder
                          showModalBottomSheet<String>(
                            context: btnContext,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext modalContext) {
                              return AddressEditDialog(
                                initialAddress: current,
                                onSave: (newAddress) {
                                  currentLocation.value = newAddress;
                                  Navigator.pop(modalContext);
                                },
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit, color: Colors.white, size: 20),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            AppColors.secondary,
                          ),
                          // Efek ketika di-hover atau ditekan
                          overlayColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(WidgetState.pressed))
                              return AppColors.orange1;
                            if (states.contains(WidgetState.hovered))
                              return AppColors.orange1;
                            return null;
                          }),
                          // Pengaturan ukuran rapat
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.all(9),
                          ),
                          minimumSize: WidgetStateProperty.all(Size.zero),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusS,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class AddressEditDialog extends StatefulWidget {
  final String initialAddress;
  final Function(String) onSave; // ✅ Callback untuk save

  const AddressEditDialog({
    super.key,
    required this.initialAddress,
    required this.onSave,
  });

  @override
  State<AddressEditDialog> createState() => _AddressEditDialogState();
}

class _AddressEditDialogState extends State<AddressEditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // viewInsets.bottom memberikan jarak setinggi keyboard yang muncul
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        // Agar konten bisa di-scroll jika layar kecil
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white, // ✅ WAJIB ada!
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Lokasi',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.fontSizeS,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.s),

              CustomTextField(
                fontSize: AppSizes.fontSizeXS,
                hintText: 'Edit lokasi',
                controller: _controller,
                borderRadius: AppSizes.radiusS,
                enabledBorder: AppColors.textSecondary,
                focusedBorder: AppColors.primary,
                focusedFillColor: AppColors.background2,
                normalFillColor: const Color.fromARGB(255, 246, 255, 255),
                minLines: 5,
              ),
              const SizedBox(height: AppSizes.m),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      // Mengubah warna teks berdasarkan status
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed))
                          return AppColors.orange1;
                        if (states.contains(WidgetState.hovered))
                          return AppColors.orange1;
                        return AppColors.secondary; // Warna default
                      }),

                      // Pengaturan ukuran rapat
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      minimumSize: WidgetStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Batal',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: AppSizes.fontSizeM,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        widget.onSave(_controller.text.trim()); // ✅ Callback
                      }
                    },
                    style: ButtonStyle(
                      // Mengubah warna teks berdasarkan status
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed))
                          return AppColors.cyan1;
                        if (states.contains(WidgetState.hovered))
                          return AppColors.cyan1;
                        return AppColors.primary; // Warna default
                      }),

                      // Pengaturan ukuran rapat
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      minimumSize: WidgetStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Simpan',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: AppSizes.fontSizeM,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildDocumentCard extends StatefulWidget {
  final ValueNotifier<File?> documentNotifier;
  final String title;
  final VoidCallback onRemove;

  const BuildDocumentCard({
    super.key,
    required this.documentNotifier,
    required this.title,
    required this.onRemove,
  });

  @override
  State<BuildDocumentCard> createState() => _BuildDocumentCardState();
}

class _BuildDocumentCardState extends State<BuildDocumentCard> {
  // Helper function untuk mengecek apakah file adalah gambar
  bool _isImageFile(File? file) {
    if (file == null) return false;
    final path = file.path.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.gif');
  }

  // Helper function untuk format nama file
  String _getFileNameForDisplay(File file) {
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

  Widget _buildDocumentPreview(File file, bool isImage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isImage)
            Container(
              width: 70,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: FileImage(file),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Color(0xFF16A34A), width: 1),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0xFF16A34A).withOpacity(0.1),
                    ),
                  ),
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
            )
          else
            Container(
              width: 70,
              height: 45,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 227, 227),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red[700]!, width: 1),
              ),
              child: Center(
                child: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red[700],
                  size: 25,
                ),
              ),
            ),

          SizedBox(height: 2),
          Text(
            _getFileNameForDisplay(file),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF16A34A),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDocumentPreview() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.upload_file,
            size: 40,
            color: AppColors.primary.withOpacity(0.5),
          ),
          SizedBox(height: 6),
          Text(
            'Upload ${widget.title}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<File?>(
      valueListenable: widget.documentNotifier,
      builder: (context, documentFile, child) {
        final bool hasDocument = documentFile != null;
        final bool isImage = hasDocument && _isImageFile(documentFile);

        return Container(
          padding: EdgeInsets.symmetric(vertical: AppSizes.s),
          decoration: BoxDecoration(
            color: hasDocument ? Color(0xFFDCFCE7) : AppColors.white1,
            borderRadius: BorderRadius.circular(AppSizes.s),
            border: Border.all(
              color: hasDocument
                  ? Color(0xFF16A34A)
                  : AppColors.primary.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // Document Preview
              if (hasDocument)
                _buildDocumentPreview(documentFile, isImage)
              else
                _buildEmptyDocumentPreview(),

              // Remove Button (hanya jika ada dokumen)
              if (hasDocument)
                Positioned(
                  top: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: widget.onRemove,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 18, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
