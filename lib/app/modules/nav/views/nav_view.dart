import 'package:flutter/material.dart';
import 'package:killswitch/app/core/theme/app_colors.dart';
import 'package:killswitch/app/core/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../logs/views/logs_view.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/profile_view.dart';
import '../../tradeConfig/views/trade_config_view.dart';
import '../controllers/nav_controller.dart';

class NavView extends GetView<NavController> {
  const NavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.scaffoldBackground, // Light Slate 100 background
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: SafeArea(child: _buildHeader(context)),
      ),
      body: () {
        switch (controller.currentTab.value) {
          case 0:
            return DashboardView();
          case 1:
            return LogsView();
          case 2:
            return TradeConfigView();
          case 3:
            return ProfileView();
          default:
            return DashboardView();
        }
      }(),
      bottomNavigationBar: Container(
        height: 72.h,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(0, Icons.grid_view_outlined, "Dashboard"),
            _buildBottomNavItem(1, Icons.description_outlined, "Logs"),
            _buildBottomNavItem(2, Icons.tune_outlined, "Trade Config"),
            _buildBottomNavItem(3, Icons.person_outline, "Profile"),
          ],
        ),
      ),
      floatingActionButton: () {
        if (controller.currentTab.value == 0) {
          final dashboardCtrl = Get.find<DashboardController>();
          final hasBroker = dashboardCtrl.activeBroker != null;
          return FloatingActionButton.extended(
            onPressed: () => Get.toNamed(Routes.BROKER_LINK),
            backgroundColor: AppColors.indigo500,
            foregroundColor: AppColors.white,
            icon: Icon(hasBroker ? Icons.edit_note : Icons.add, size: 20.sp),
            label: Text(
              hasBroker ? "Edit Broker" : "Link Broker",
              style: AppTextStyles.poppins(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          );
        }
        return const SizedBox.shrink();
      }(),
    ));
  }

  Widget _buildHeader(BuildContext context) {
    final dashboardCtrl = Get.find<DashboardController>();
    final profileCtrl = Get.find<ProfileController>();

    final session = dashboardCtrl.todaySession.value;
    final profile = profileCtrl.userProfile.value;

    double pnl = session?.netPnL ?? 7738.25;
    String pnlText = pnl >= 0
        ? 'P&L: ${pnl.toStringAsFixed(2)}'
        : 'P&L: -${pnl.abs().toStringAsFixed(2)}';

    return Container(
      color: AppColors.scaffoldBackground,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Partnered with Dhan Border Container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.red600, width: 1.5.w),
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.cardBackground,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red toggle pill
                Container(
                  width: 20.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: AppColors.red600,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 6.w,
                      height: 6.h,
                      margin: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                // Bold label
                Text(
                  'Partnered with Dhan',
                  style: AppTextStyles.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Right metrics & Avatar
          Row(
            children: [
              // P&L indicator badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: pnl >= 0 ? AppColors.green50 : AppColors.red100,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: pnl >= 0 ? AppColors.green200 : AppColors.red200,
                    width: 1.w,
                  ),
                ),
                child: Text(
                  pnlText,
                  style: AppTextStyles.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: pnl >= 0 ? AppColors.green800 : AppColors.red800,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Avatar
              GestureDetector(
                onTap: () {
                  controller.currentTab.value = 3; // Swaps to Profile tab
                },
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: AppColors.divider,
                  child: ClipOval(
                    child:
                        profile != null &&
                            profile.profilePicture != null &&
                            profile.profilePicture!.isNotEmpty
                        ? Image.network(
                            profile.profilePicture!,
                            width: 36.w,
                            height: 36.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 20.sp,
                              color: AppColors.textSecondary,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 20.sp,
                            color: AppColors.textSecondary,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final isSelected = controller.currentTab.value == index;
    return GestureDetector(
      onTap: () => controller.currentTab.value = index,
      behavior: HitTestBehavior.opaque,
      child: isSelected
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.rose100, // Pinkish highlight
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: AppColors.red600, size: 18.sp),
                  SizedBox(width: 6.w),
                  Text(
                    label,
                    style: AppTextStyles.poppins(
                      color: AppColors.red600,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.textSecondary, size: 20.sp),
                  SizedBox(height: 2.h),
                  Text(
                    label,
                    style: AppTextStyles.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
