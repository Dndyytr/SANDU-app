import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandu_app/core/constants/app_colors.dart';
import 'package:sandu_app/core/constants/app_sizes.dart';
import 'package:sandu_app/presentation/screens/service/skd/skd_screen.dart';
import 'package:sandu_app/presentation/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:sandu_app/presentation/screens/success/success_screen.dart';
import 'package:sandu_app/presentation/widgets/button_width_text.dart';
import 'package:sandu_app/presentation/widgets/loading.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _datePostController = TextEditingController();
  final TextEditingController _timePostController = TextEditingController();
  final ValueNotifier<String?> _selectedType = ValueNotifier(null);
  final ValueNotifier<String?> _selectedAudience = ValueNotifier(null);
  final ValueNotifier<String?> _selectedSector = ValueNotifier(null);
  final ValueNotifier<bool> _isAnonymous = ValueNotifier(false);
  final ValueNotifier<bool> _isScheduled = ValueNotifier(false);
  final ValueNotifier<bool> _isCrossPostToGroup = ValueNotifier(false);

  // audience
  final List<String> _audienceOptions = [
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

  // sector
  final List<String> _sectorOptions = [
    'Pemerintahan',
    'Pertanian',
    'Sosial',
    'Lingkungan',
    'UMKM',
    'Pendidikan',
    'Kesehatan',
    'Kebencanaan',
  ];

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

  void _submitForm() async {
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
                'Postingan Berhasil Dibuat, silahkan lihat di section Feed Utama di halaman Komunitas',
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
  }

  @override
  void initState() {
    super.initState();
    // Initialize with placeholder text
    _postController.text =
        'Apa kabar Desa Utama? Bagikan info, tanya, atau minta...';
  }

  @override
  void dispose() {
    _postController.dispose();
    _datePostController.dispose();
    _timePostController.dispose();
    _selectedAudience.dispose();
    _selectedSector.dispose();
    _selectedType.dispose();
    _isAnonymous.dispose();
    _isScheduled.dispose();
    _isCrossPostToGroup.dispose();
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
          'Buat Postingan',
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
                color: Colors.white,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSizes.s),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AUDIENCE & META',
                                style: GoogleFonts.poppins(
                                  fontSize: AppSizes.fontSizeS,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
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
                                        Text(
                                          'Audience:',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeS,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: AppSizes.xs),
                                        ValueListenableBuilder<String?>(
                                          valueListenable: _selectedAudience,
                                          builder: (context, value, child) {
                                            return BuildDropdown(
                                              hint: 'Pilih Audience',
                                              label: 'Audience',
                                              items: _audienceOptions,
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
                                                _selectedAudience.value =
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
                                          'Sektor:',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppSizes.fontSizeS,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: AppSizes.xs),
                                        ValueListenableBuilder<String?>(
                                          valueListenable: _selectedSector,
                                          builder: (context, value, child) {
                                            return BuildDropdown(
                                              hint: 'Pilih Sektor',
                                              label: 'Sektor',
                                              items: _sectorOptions,
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
                                                _selectedSector.value =
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
                                'Tipe Postingan:',
                                style: GoogleFonts.poppins(
                                  fontSize: AppSizes.fontSizeS,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSizes.xs),
                              ValueListenableBuilder<String?>(
                                valueListenable: _selectedType,
                                builder: (context, selectedValue, child) {
                                  return Row(
                                    children: [
                                      // Radio untuk Laki-laki
                                      BuildRadioButton(
                                        title: 'Pengumunan',
                                        value: 'Pengumuman',
                                        groupValueNotifier: _selectedType,
                                      ),
                                      SizedBox(width: AppSizes.l),
                                      // Radio untuk Perempuan
                                      BuildRadioButton(
                                        title: 'Berita',
                                        value: 'Berita',
                                        groupValueNotifier: _selectedType,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.m),
                        BuildTextField(
                          hintText: 'Masukkan isi berita, (max 200 Karakter)',
                          controller: _postController,
                          focusedColor: Colors.grey.shade50,
                          unfocusedColor: Colors.grey.shade100,
                          borderColor: Colors.grey.shade300,
                          unborderColor: Colors.grey.shade200,
                          maxLines: 7,
                        ),
                        const SizedBox(height: AppSizes.m),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: AppSizes.s),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.visibility_off_rounded,
                                  size: 25,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: AppSizes.s),
                                Text(
                                  'Anonim',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeS,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: AppSizes.s),
                            BuildToogleButton(onChanged: _isAnonymous),
                          ],
                        ),
                        const SizedBox(height: AppSizes.s),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: AppSizes.s),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.edit_calendar_rounded,
                                  size: 25,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: AppSizes.s),
                                Text(
                                  'Jadwalkan Postingan',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeS,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: AppSizes.s),
                            BuildToogleButton(onChanged: _isScheduled),
                          ],
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Row(
                          children: [
                            Expanded(
                              child: BuildDateField(
                                hintText: 'YYYY-MM-DD',
                                controller: _datePostController,
                                focusedColor: Colors.grey.shade50,
                                unfocusedColor: Colors.grey.shade100,
                                borderColor: AppColors.primary.withOpacity(0.5),
                                unborderColor: AppColors.primary.withOpacity(
                                  0.3,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.calendar_month_rounded,
                                    size: 20,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.s),
                            Expanded(
                              child: BuildTimeField(
                                hintText: 'HH:MM',
                                controller: _timePostController,
                                focusedColor: Colors.grey.shade50,
                                unfocusedColor: Colors.grey.shade100,
                                borderColor: AppColors.primary.withOpacity(0.5),
                                unborderColor: AppColors.primary.withOpacity(
                                  0.3,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.access_time_rounded,
                                    size: 20,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.s),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: AppSizes.s),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.share_rounded,
                                  size: 25,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: AppSizes.s),
                                Text(
                                  'Cross-post ke Grup saya',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.fontSizeS,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: AppSizes.s),
                            BuildToogleButton(onChanged: _isCrossPostToGroup),
                          ],
                        ),
                        const SizedBox(height: AppSizes.s),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: AppSizes.m),
                        Row(
                          children: [
                            ButtonWidthText(
                              text: 'Simpan Draf',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Postingan Draf Berhasil Tersimpan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: AppSizes.fontSizeS,
                                      ),
                                    ),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              },
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
                              beginGradientAlignment: Alignment.centerLeft,
                              endGradientAlignment: Alignment.centerRight,
                              textColor: Colors.white,
                              icon: const Icon(
                                Icons.save,
                                size: 20,
                                color: Colors.white,
                              ),
                              paddingHorizontal: AppSizes.m,
                              paddingVertical: AppSizes.s,
                            ),

                            const SizedBox(width: AppSizes.s),
                            Flexible(
                              child: ButtonWidthText(
                                text: 'Kirim',
                                onPressed: _submitForm,
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
                                beginGradientAlignment: Alignment.centerLeft,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildToogleButton extends StatelessWidget {
  final ValueNotifier<bool> onChanged;
  const BuildToogleButton({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: onChanged, // Mendengarkan perubahan data
      builder: (context, changed, child) {
        return Transform.scale(
          scale: 0.8,
          child: Switch(
            value: changed,
            onChanged: (newChanged) => onChanged.value = newChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.cyan2, // Jalur saat aktif
            inactiveThumbColor: AppColors.textPrimary, // Lingkaran saat mati
            inactiveTrackColor: AppColors.tertiary, // Jalur saat mati
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      },
    );
  }
}

class BuildTimeField extends StatefulWidget {
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

  const BuildTimeField({
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
  State<BuildTimeField> createState() => _BuildTimeFieldState();
}

class _BuildTimeFieldState extends State<BuildTimeField> {
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
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.dial,
                builder: (context, child) {
                  // Menyesuaikan tema picker dengan warna aplikasi Anda
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: widget.borderColor, // warna header & jarum
                        onPrimary: Colors.white, // warna teks di atas primary
                        onSurface: AppColors.textPrimary, // warna angka jam
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                // Format 24 jam (contoh: 14:30)
                final String formattedTime =
                    '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

                // Update controller agar teks muncul di UI
                widget.controller.text = formattedTime;

                // Panggil onChanged jika ada
                if (widget.onChanged != null) {
                  widget.onChanged!(formattedTime);
                }
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
