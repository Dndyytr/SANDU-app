import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/presentation/screens/service/skd/skd_screen.dart';
import 'package:sandu_app/presentation/screens/success/success_screen.dart';
import 'package:sandu_app/presentation/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sandu_app/presentation/widgets/loading.dart';
import 'dart:io';

import 'package:sandu_app/presentation/widgets/submit_button.dart';

class QuickReportScreen extends StatefulWidget {
  const QuickReportScreen({super.key});

  @override
  State<QuickReportScreen> createState() => _QuickReportScreenState();
}

class _QuickReportScreenState extends State<QuickReportScreen> {
  // State
  final ValueNotifier<String?> _selectedCategory = ValueNotifier(null);
  final ValueNotifier<bool> _isAnonymous = ValueNotifier(false);
  final ValueNotifier<bool> _publishToFeed = ValueNotifier(false);
  final ValueNotifier<String> _priority = ValueNotifier('Normal');
  final ValueNotifier<String?> _currentLocation = ValueNotifier(null);
  final ValueNotifier<Position?> _currentPosition = ValueNotifier(null);
  final ValueNotifier<String?> _hoveredCategory = ValueNotifier(null);
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Categories
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.add_road, 'label': 'Jalan Rusak'},
    {'icon': Icons.landslide, 'label': 'Banjir/Longsor'},
    {'icon': Icons.cleaning_services, 'label': 'Kebersihan'},
    {'icon': Icons.electric_bolt, 'label': 'Gangguan/Listrik/Air'},
    {'icon': Icons.security, 'label': 'Keamanan/Darurat'},
    {'icon': Icons.more_horiz, 'label': 'Lainnya'},
  ];

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

  final ValueNotifier<File?> _selectedImage = ValueNotifier(null);
  final ValueNotifier<String?> _selectedFileName = ValueNotifier(null);
  final ValueNotifier<File?> _selectedFile = ValueNotifier(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70, // Kompresi agar hemat memori
    );

    if (pickedFile != null) {
      _selectedImage.value = File(pickedFile.path);

      // ✅ Hapus data file/dokumen jika ada
      _selectedFile.value = null;
      _selectedFileName.value = null;
    }
  }

  Future<void> _pickFile() async {
    try {
      // Membuka picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'png',
          'jpg',
        ], // Tentukan ekstensi
        allowMultiple: false, // Set true jika ingin banyak file sekaligus
      );

      if (result != null) {
        // Mengambil file pertama

        _selectedFile.value = File(result.files.single.path!);
        _selectedFileName.value = result.files.single.name;

        // ✅ Hapus data foto jika ada
        _selectedImage.value = null;

        // Simpan ke state atau kirim ke API
      } else {
        // User membatalkan picker
        print("Batal memilih file");
      }
    } catch (e) {
      print("Error saat memilih file: $e");
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // ✅ Submit form
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(
            title: 'Berhasil',
            titleSize: AppSizes.fontSizeHero,
            subTitle:
                'Laporan Berhasil Terkirim, silahkan tunggu beberapa saat untuk diverifikasi',
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
    }
  }

  @override
  void dispose() {
    _selectedCategory.dispose();
    _currentLocation.dispose();
    _currentPosition.dispose();
    _hoveredCategory.dispose();
    _isAnonymous.dispose();
    _publishToFeed.dispose();
    _priority.dispose();
    _selectedImage.dispose();
    _selectedFileName.dispose();
    _selectedFile.dispose();
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
              'Lapor Cepat',
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontSizeL,
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

              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                margin: EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.s),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kategori
                          Text(
                            'Kategori',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeS,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: AppSizes.s),

                          CategoryGrid(
                            selectedCategory: _selectedCategory,
                            categories: categories,
                            hoveredCategory: _hoveredCategory,
                          ),

                          const SizedBox(height: AppSizes.s),

                          Text(
                            'Judul Singkat',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeS,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: AppSizes.s),

                          BuildTextField(
                            hintText: 'Isi judul singkat',
                            controller: TextEditingController(),
                          ),

                          const SizedBox(height: AppSizes.s),

                          Text(
                            'Deskripsi (opsional)',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeS,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: AppSizes.s),

                          BuildTextField(
                            hintText: 'Tulis deskripsi max 500 karakter',
                            controller: TextEditingController(),
                            minLines: 3,
                            maxLines: 3,
                          ),

                          const SizedBox(height: AppSizes.s),

                          Text(
                            'Lokasi',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeS,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: AppSizes.s),

                          LocationButton(
                            currentLocation: _currentLocation,
                            onGetLocation: _getCurrentLocation,
                            currentPosition: _currentPosition,
                          ),

                          const SizedBox(height: AppSizes.s),

                          Text(
                            'Lampiran',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeS,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: AppSizes.s),

                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AttachmentButton(
                                      icon: Icons.camera_alt_rounded,
                                      label: 'Ambil Foto',
                                      onTap: _pickImageFromCamera,
                                      paddingHorizontal: 8,
                                      paddingVertical: 8,
                                      boxShadow: true,
                                      colors: [
                                        AppColors.primary,
                                        AppColors.cyan1,
                                        AppColors.cyan1,
                                        AppColors.background,
                                      ],
                                      borderRadius: BorderRadius.circular(6),
                                      fontSize: AppSizes.fontSizeS,
                                      textColor: Colors.white,
                                      sizeIcon: 20,
                                      colorIcon: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.s),
                                  Expanded(
                                    child: AttachmentButton(
                                      icon: Icons.folder_open_rounded,
                                      label: 'Upload',
                                      onTap: _pickFile,
                                      paddingHorizontal: 8,
                                      paddingVertical: 8,
                                      boxShadow: true,
                                      colors: [
                                        AppColors.secondary,
                                        AppColors.orange6,
                                        AppColors.orange6,
                                        AppColors.orange9,
                                      ],
                                      borderRadius: BorderRadius.circular(6),
                                      fontSize: AppSizes.fontSizeS,
                                      textColor: Colors.white,
                                      sizeIcon: 20,
                                      colorIcon: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AppSizes.s),

                              Text(
                                '(Max 3 file, 5MB/file, JPG/PNG/PDF/DOCX)',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppColors.cyan1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: AppSizes.s),

                              ValueListenableBuilder<File?>(
                                valueListenable: _selectedImage,
                                builder: (context, imageFile, child) {
                                  if (imageFile != null) {
                                    return Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: FileImage(imageFile),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                  return SizedBox.shrink();
                                },
                              ),

                              ValueListenableBuilder<File?>(
                                valueListenable: _selectedFile,
                                builder: (context, file, child) {
                                  if (file != null) {
                                    return ValueListenableBuilder<String?>(
                                      valueListenable: _selectedFileName,
                                      builder: (context, fileName, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              AppSizes.radiusS,
                                            ),
                                            color: AppColors.white1,
                                            border: Border.all(
                                              color: AppColors.primary
                                                  .withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          child: Text(
                                            fileName ??
                                                file.path.split('/').last,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  return SizedBox.shrink();
                                },
                              ),
                            ],
                          ),

                          Text(
                            'Opsi',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeS,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ToggleButton(
                                    title: 'Laporkan Anonim',
                                    onChanged: _isAnonymous,
                                  ),
                                  ToggleButton(
                                    title: 'Publik ke Komunitas',
                                    onChanged: _publishToFeed,
                                  ),
                                ],
                              ),

                              Text(
                                '(Jika anonim kontak tidak ditampilkan)',
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.cyan1,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            'Prioritas',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSizeS,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: AppSizes.s),

                          PrioritySeelector(priorityNotifier: _priority),

                          const SizedBox(height: AppSizes.s),

                          SubmitButton(
                            text: 'Kirim Laporan',
                            onPressed: _submitForm,
                            fontSize: AppSizes.fontSizeM,
                            paddingVertical: 10,
                          ),

                          const SizedBox(height: AppSizes.s),

                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Laporkan kondisi yg penting. Laporan palsu akan ditindak.',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.cyan1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
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

class CategoryGrid extends StatelessWidget {
  final ValueNotifier<String?> selectedCategory;
  final List<Map<String, dynamic>> categories;
  final ValueNotifier<String?> hoveredCategory;
  const CategoryGrid({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.hoveredCategory,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedCategory,
      builder: (context, selected, child) {
        return ValueListenableBuilder<String?>(
          valueListenable: hoveredCategory,
          builder: (context, hoveredLabel, child) {
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 0.8,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selected == category['label'];
                final isThisItemHovered = hoveredLabel == category['label'];

                return GestureDetector(
                  onTap: () => selectedCategory.value = category['label'],
                  child: MouseRegion(
                    onEnter: (_) => hoveredCategory.value = category['label'],
                    onExit: (_) => hoveredCategory.value = null,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [AppColors.primary, AppColors.cyan1],
                              )
                            : isThisItemHovered
                            ? LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.5),
                                  AppColors.cyan1.withOpacity(0.5),
                                ],
                              )
                            : null,
                        color: (isSelected || isThisItemHovered)
                            ? null
                            : AppColors.background2,
                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                        border: (isSelected || isThisItemHovered)
                            ? Border.all(color: Colors.transparent)
                            : Border.all(color: AppColors.white1),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            category['icon'],
                            size: 20,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                          SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              category['label'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: (isSelected || isThisItemHovered)
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class LocationButton extends StatelessWidget {
  final ValueNotifier<String?> currentLocation;
  final ValueNotifier<Position?> currentPosition;
  final VoidCallback onGetLocation;
  const LocationButton({
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

            // ✅ Tampilkan Map Preview jika ada lokasi
            if (current != null) ...[
              SizedBox(height: 8),

              // Map Preview dengan alamat
              ValueListenableBuilder<Position?>(
                valueListenable: currentPosition,
                builder: (context, position, child) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background2,
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Map Image Preview
                        if (position != null)
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppSizes.radiusS),
                              topRight: Radius.circular(AppSizes.radiusS),
                            ),
                            child: MapPreviewWidget(
                              latitude: position.latitude,
                              longitude: position.longitude,
                            ),
                          ),

                        // Address Info
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  current,
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeXS,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
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
            ],
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

class MapPreviewWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double width;
  final double height;

  const MapPreviewWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.width = double.infinity,
    this.height = 100,
  });

  // ✅ OpenStreetMap Static Image (GRATIS, TANPA API KEY)
  String _getOpenStreetMapUrl() {
    final zoom = 10;
    final markerLat = latitude;
    final markerLon = longitude;

    // Menggunakan staticmap.openstreetmap.de
    return 'https://staticmap.openstreetmap.de/staticmap.php?'
        'center=$latitude,$longitude'
        '&zoom=$zoom'
        '&size=600x300'
        '&maptype=mapnik'
        '&markers=$markerLat,$markerLon,red-pushpin';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Map Image
          Image.network(
            _getOpenStreetMapUrl(),
            width: width,
            height: height,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                  color: AppColors.primary,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildCustomMap();
            },
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.05)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Fallback: Custom Map UI
  Widget _buildCustomMap() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F5E9), Color(0xFFB2DFDB)],
        ),
      ),
      child: Stack(
        children: [
          // Grid pattern
          CustomPaint(size: Size(width, height), painter: MapGridPainter()),

          // Roads
          CustomPaint(size: Size(width, height), painter: RoadPainter()),

          // Buildings
          Positioned(
            top: 40,
            left: 60,
            child: _buildBuilding(30, 40, Colors.blue.shade100),
          ),
          Positioned(
            top: 50,
            right: 80,
            child: _buildBuilding(25, 35, Colors.orange.shade100),
          ),
          Positioned(
            bottom: 60,
            left: 100,
            child: _buildBuilding(20, 30, Colors.purple.shade100),
          ),

          // Pin lokasi di tengah
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pin shadow
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -20),
                  child: Icon(
                    Icons.location_on,
                    size: 48,
                    color: Colors.red.shade600,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Coordinate badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.my_location, size: 12, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
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

  Widget _buildBuilding(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: color.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}

// Grid Pattern
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Vertical lines
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Horizontal lines
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Roads Pattern
class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Main road vertical
    final mainRoadX = size.width * 0.35;
    canvas.drawLine(
      Offset(mainRoadX, 0),
      Offset(mainRoadX, size.height),
      roadPaint,
    );

    // Dashed center line
    _drawDashedLine(
      canvas,
      Offset(mainRoadX, 0),
      Offset(mainRoadX, size.height),
      linePaint,
      10,
      5,
    );

    // Cross road horizontal
    final crossRoadY = size.height * 0.6;
    canvas.drawLine(
      Offset(0, crossRoadY),
      Offset(size.width, crossRoadY),
      roadPaint,
    );

    _drawDashedLine(
      canvas,
      Offset(0, crossRoadY),
      Offset(size.width, crossRoadY),
      linePaint,
      10,
      5,
    );

    // Side road
    final sideRoadY = size.height * 0.3;
    canvas.drawLine(
      Offset(mainRoadX, sideRoadY),
      Offset(size.width, sideRoadY),
      roadPaint..strokeWidth = 8,
    );
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    final path = Path();
    final totalDistance = (end - start).distance;
    final dashCount = (totalDistance / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final t1 = (i * (dashWidth + dashSpace)) / totalDistance;
      final t2 = ((i * (dashWidth + dashSpace)) + dashWidth) / totalDistance;

      final p1 = Offset.lerp(start, end, t1)!;
      final p2 = Offset.lerp(start, end, t2)!;

      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AttachmentButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double sizeIcon;
  final Color colorIcon;
  final double paddingHorizontal;
  final double paddingVertical;
  final bool boxShadow;
  final List<Color> colors;
  final BorderRadius borderRadius;
  final double fontSize;
  final Color textColor;
  final Alignment? beginGradientAlignment;
  final Alignment? endGradientAlignment;

  const AttachmentButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.beginGradientAlignment,
    this.endGradientAlignment,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.boxShadow,
    required this.colors,
    required this.borderRadius,
    required this.fontSize,
    required this.textColor,
    required this.sizeIcon,
    required this.colorIcon,
  });

  @override
  State<AttachmentButton> createState() => _AttachmentButtonState();
}

class _AttachmentButtonState extends State<AttachmentButton> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);

  @override
  void dispose() {
    _isHovered.dispose();
    _isPressed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isHovered,
      builder: (context, isHovered, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isPressed,
          builder: (context, isPressed, child) {
            return GestureDetector(
              onTapDown: (_) => setState(() => _isPressed.value = true),
              onTapUp: (_) => setState(() => _isPressed.value = false),
              onTapCancel: () => setState(() => _isPressed.value = false),
              onTap: () {
                setState(() => _isPressed.value = false);
                widget.onTap();
              },
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered.value = true),
                onExit: (_) => setState(() => _isHovered.value = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getGradientColors(isHovered, isPressed),
                      begin:
                          widget.beginGradientAlignment ?? Alignment.centerLeft,
                      end: widget.endGradientAlignment ?? Alignment.centerRight,
                    ), // Hanya warna solid jika gradient false
                    borderRadius: widget.borderRadius,
                    boxShadow: _isPressed.value
                        ? [] // Tidak ada shadow ketika ditekan
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 1.5,
                              spreadRadius: 0,
                              offset: Offset(0, 2),
                            ),
                          ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.paddingHorizontal,
                    vertical: widget.paddingVertical,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        size: widget.sizeIcon,
                        color: widget.colorIcon,
                      ),
                      const SizedBox(width: AppSizes.xs),

                      Text(
                        widget.label,
                        style: GoogleFonts.poppins(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.w600,
                          color: widget.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ⬅️ FUNGSI UNTUK GRADIENT BERUBAH SAAT HOVER
  List<Color> _getGradientColors(bool isHovered, bool isPressed) {
    if (isHovered) {
      // Warna ketika hover (lebih terang)
      return [widget.colors[2], widget.colors[3]];
    } else if (isPressed) {
      // Warna ketika ditekan (lebih gelap)
      return [widget.colors[2], widget.colors[3]];
    } else {
      // Warna normal
      return [widget.colors[0], widget.colors[1]];
    }
  }
}

class ToggleButton extends StatelessWidget {
  final String title;
  final ValueNotifier<bool> onChanged;

  const ToggleButton({super.key, required this.title, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: onChanged, // Mendengarkan perubahan data
      builder: (context, changed, child) {
        return Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(
              width: 45,
              child: Center(
                child: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: changed,
                    onChanged: (newChanged) => onChanged.value = newChanged,
                    activeColor: AppColors.primary,
                    activeTrackColor: AppColors.cyan2, // Jalur saat aktif
                    inactiveThumbColor:
                        AppColors.textPrimary, // Lingkaran saat mati
                    inactiveTrackColor: AppColors.tertiary, // Jalur saat mati
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PrioritySeelector extends StatelessWidget {
  final ValueNotifier<String> priorityNotifier;

  const PrioritySeelector({super.key, required this.priorityNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSecondary, width: 2),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: ValueListenableBuilder<String>(
        valueListenable: priorityNotifier,
        builder: (context, currentPriority, _) {
          return Row(
            children: [
              Expanded(
                child: _buildPriorityButton('Normal', false, currentPriority),
              ),
              Expanded(
                child: _buildPriorityButton(
                  'Penting/Segera',
                  true,
                  currentPriority,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPriorityButton(
    String label,
    bool isUrgent,
    String currentPriority,
  ) {
    final bool isSelected = isUrgent
        ? currentPriority == 'Urgent'
        : currentPriority == 'Normal';

    return GestureDetector(
      onTap: () => priorityNotifier.value = isUrgent ? 'Urgent' : 'Normal',
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.primary, AppColors.cyan1],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,

          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: AppSizes.fontSizeS,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
