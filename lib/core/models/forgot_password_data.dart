class ForgotPasswordData {
  final String emailOrPhone;
  final String? otp; // opsional, bisa di-set di step 2

  ForgotPasswordData({required this.emailOrPhone, this.otp});

  // Copy with update
  ForgotPasswordData copyWith({String? emailOrPhone, String? otp}) {
    return ForgotPasswordData(
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      otp: otp ?? this.otp,
    );
  }
}
