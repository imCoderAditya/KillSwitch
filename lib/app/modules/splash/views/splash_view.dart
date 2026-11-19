import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:killswitch/app/core/theme/app_colors.dart';
import 'package:killswitch/app/core/theme/app_text_styles.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    Get.find<SplashController>();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.slate900,
              Color(0xFF0F172A), // Slate 900
              Color(0xFF020617), // Deepest Navy / Blackish Slate
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Decorative background glowing element
            Positioned(
              top: -80.h,
              right: -40.w,
              child: Container(
                width: 220.w,
                height: 220.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.rose600.withValues(alpha: 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.rose600.withValues(alpha: 0.04),
                      blurRadius: 100,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
            
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Shield Icon Container with premium border & glow
                    Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.rose600.withValues(alpha: 0.08),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.slate800,
                          border: Border.all(
                            color: AppColors.rose600.withValues(alpha: 0.3),
                            width: 2.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.rose600.withValues(alpha: 0.25),
                              blurRadius: 32,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.security, // Shield icon representing protection
                          color: AppColors.rose600,
                          size: 52.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    
                    // Brand Logo Title
                    Text(
                      'KillSwitch',
                      style: AppTextStyles.poppins(
                        fontSize: 38.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    
                    // Core Value Proposition Subtitle
                    Text(
                      'AUTOMATED RISK PROTECTION',
                      style: AppTextStyles.openSans(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.rose200,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom load indicator
            Positioned(
              bottom: 60.h,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.rose600),
                    backgroundColor: Color(0xFF1E293B), // Slate 800
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
