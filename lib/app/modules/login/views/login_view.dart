import 'package:flutter/material.dart';
import 'package:killswitch/app/core/theme/app_colors.dart';
import 'package:killswitch/app/core/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.scaffoldBackground, // Light Slate 100
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.rose100, // Soft pink/red
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.rose200,
                          width: 2.w,
                        ),
                      ),
                      child: Icon(
                        Icons.security,
                        color: AppColors.rose600, // Deep Rose / Red
                        size: 36.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: Text(
                      'KillSwitch',
                      style: AppTextStyles.poppins(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary, // Dark Slate
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Center(
                    child: Text(
                      'Sign in to secure and manage your trading risk.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.openSans(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary, // Slate 500
                      ),
                    ),
                  ),
                  SizedBox(height: 36.h),

                  // Form Card
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: AppColors.divider, width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Address',
                          style: AppTextStyles.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: AppTextStyles.poppins(
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: AppTextStyles.poppins(
                              color: AppColors.textSecondary,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColors.divider,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColors.divider,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(
                                color: AppColors.indigo500,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        Text(
                          'Password',
                          style: AppTextStyles.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: controller.passwordController,
                          obscureText: true,
                          style: AppTextStyles.poppins(
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: AppTextStyles.poppins(
                              color: AppColors.textSecondary,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColors.divider,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColors.divider,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(
                                color: AppColors.indigo500,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        Obx(() {
                          if (controller.errorMessage.value.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Text(
                              controller.errorMessage.value,
                              style: AppTextStyles.poppins(
                                color: AppColors.red600,
                                fontSize: 13.sp,
                              ),
                            ),
                          );
                        }),

                        Obx(
                          () => Container(
                            width: double.infinity,
                            height: 52.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.indigo500,
                                  AppColors.indigo600,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.indigo500.withValues(
                                    alpha: 0.25,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: AppColors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.r),
                                onTap: controller.isLoading.value
                                    ? null
                                    : controller.login,
                                child: Center(
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Sign In',
                                          style: AppTextStyles.poppins(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // OR divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: AppColors.divider, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          "OR",
                          style: AppTextStyles.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: AppColors.divider, thickness: 1),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Google Login Button
                  Obx(
                    () => Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.divider,
                          width: 1.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: AppColors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: controller.isLoading.value
                              ? null
                              : controller.loginWithGoogle,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Custom Painted/Drawn Google Icon for Visuals
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "G",
                                      style: AppTextStyles.roboto(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.googleBlue,
                                      ),
                                    ),
                                    Text(
                                      "o",
                                      style: AppTextStyles.roboto(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.googleRed,
                                      ),
                                    ),
                                    Text(
                                      "o",
                                      style: AppTextStyles.roboto(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.googleYellow,
                                      ),
                                    ),
                                    Text(
                                      "g",
                                      style: AppTextStyles.roboto(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.googleBlue,
                                      ),
                                    ),
                                    Text(
                                      "l",
                                      style: AppTextStyles.roboto(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.googleGreen,
                                      ),
                                    ),
                                    Text(
                                      "e",
                                      style: AppTextStyles.roboto(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.googleRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Continue with Google',
                                style: AppTextStyles.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  Center(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(Routes.SIGNUP),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: AppTextStyles.openSans(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: AppTextStyles.poppins(
                                color: AppColors.indigo500,
                                fontWeight: FontWeight.bold,
                              ),
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
        ),
      ),
    );
  }
}
