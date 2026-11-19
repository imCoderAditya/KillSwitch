import 'package:flutter/material.dart';
import 'package:killswitch/app/core/theme/app_colors.dart';
import 'package:killswitch/app/core/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/trade_config_controller.dart';

class TradeConfigView extends GetView<TradeConfigController> {
  const TradeConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final limit = controller.activeLimit;
      final isEditing = controller.isEditing.value;
      final isLoading = controller.isLoading.value;
      final hasBroker =
          Get.isRegistered<DashboardController>() &&
          Get.find<DashboardController>().activeBroker != null;

      double maxLoss = limit?.dailyLossLimit.abs() ?? 0.0;
      double maxProfit = limit?.profitTarget ?? 0.0;
      int maxTrades = limit?.maxTrades ?? 0;
      bool strictMode = limit?.flattenOnBreach ?? false;

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            // Status Banner / Warning Alert
            if (limit == null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.red50,
                  border: Border.all(color: AppColors.red200, width: 1.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.red600,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        "No active daily risk controls set. Your trading account is currently unprotected.",
                        style: AppTextStyles.poppins(
                          fontSize: 12.sp,
                          color: AppColors.red800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.green50,
                  border: Border.all(color: AppColors.green200, width: 1.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.green600,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        "Auto-Risk Protection is Online. Active daily boundaries are set and monitoring.",
                        style: AppTextStyles.poppins(
                          fontSize: 12.sp,
                          color: AppColors.green700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 12.h),

            if (isEditing)
              // EDIT MODE FORM
              _buildConfigCard(
                title: "CONFIGURE RISK LIMITS",
                children: [
                  Text(
                    'Daily Loss Limit (₹)',
                    style: AppTextStyles.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.lossLimitController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: AppTextStyles.poppins(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'e.g. 5000',
                      hintStyle: AppTextStyles.poppins(
                        color: AppColors.textSecondary,
                      ),
                      prefixText: '₹ ',
                      prefixStyle: AppTextStyles.poppins(
                        color: AppColors.textPrimary,
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
                        borderSide: BorderSide(
                          color: AppColors.indigo500,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Text(
                    'Daily Profit Target (₹)',
                    style: AppTextStyles.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.profitTargetController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: AppTextStyles.poppins(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'e.g. 10000',
                      hintStyle: AppTextStyles.poppins(
                        color: AppColors.textSecondary,
                      ),
                      prefixText: '₹ ',
                      prefixStyle: AppTextStyles.poppins(
                        color: AppColors.textPrimary,
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
                        borderSide: BorderSide(
                          color: AppColors.indigo500,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Text(
                    'Maximum Trades Per Day',
                    style: AppTextStyles.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.maxTradesController,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.poppins(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'e.g. 15',
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
                        borderSide: BorderSide(
                          color: AppColors.indigo500,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Square Off All Positions',
                            style: AppTextStyles.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Flatten open trades automatically on breach',
                            style: AppTextStyles.openSans(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: controller.flattenOnBreach.value,
                        activeThumbColor: AppColors.indigo500,
                        onChanged: (val) {
                          controller.flattenOnBreach.value = val;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  if (controller.errorMessage.value.isNotEmpty) ...[
                    Text(
                      controller.errorMessage.value,
                      style: AppTextStyles.poppins(
                        fontSize: 12.sp,
                        color: AppColors.red600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () => controller.toggleEditMode(false),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            side: BorderSide(color: AppColors.divider),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: AppTextStyles.poppins(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : controller.saveLimits,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigo500,
                            foregroundColor: AppColors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 18.w,
                                  width: 18.w,
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Save Limits",
                                  style: AppTextStyles.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                    color: AppColors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else ...[
              // VIEW MODE CARD 1: RISK LIMITS
              _buildConfigCard(
                title: "RISK LIMITS",
                children: [
                  _buildConfigRow(
                    "Max Daily Loss",
                    limit == null
                        ? "Not Set"
                        : "₹${maxLoss.toStringAsFixed(0)}",
                  ),
                  _buildConfigRow(
                    "Max Daily Profit",
                    limit == null
                        ? "Not Set"
                        : "₹${maxProfit.toStringAsFixed(0)}",
                  ),
                  _buildConfigRow(
                    "Max Trades Per Day",
                    limit == null ? "Not Set" : "$maxTrades",
                    isLast: true,
                  ),
                  if (limit != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      "1 trade = 2 orders (approx max orders: ${maxTrades * 2})",
                      style: AppTextStyles.openSans(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12.h),

              // VIEW MODE CARD 2: MODE CONTROLS
              _buildConfigCard(
                title: "MODE CONTROLS",
                children: [
                  _buildConfigRow(
                    "Strict Mode (Market Hours)",
                    limit == null
                        ? "Not Set"
                        : (strictMode ? "Enabled" : "Disabled"),
                  ),
                  _buildConfigRow(
                    "Monthly Strict Mode",
                    "Disabled",
                    isLast: true,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Monthly strict mode is disabled.",
                    style: AppTextStyles.openSans(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // CARD 3: AUTOMATIC PROFIT LOCKS
              _buildConfigCard(
                title: "AUTOMATIC PROFIT LOCKS",
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildProfitLockBox(
                          "P&L reaches",
                          limit == null
                              ? "N/A"
                              : "₹${(maxProfit * 0.75).toStringAsFixed(0)}",
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildProfitLockBox(
                          "Lock profit at",
                          limit == null
                              ? "N/A"
                              : "₹${(maxProfit * 0.25).toStringAsFixed(0)}",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Once locked, profits are protected even if P&L drops.",
                    style: AppTextStyles.openSans(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Edit / Deactivate buttons
              if (hasBroker) ...[
                Row(
                  children: [
                    if (limit != null) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : controller.deactivateLimit,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.red600,
                            side: BorderSide(color: AppColors.red200),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            "Deactivate Limit",
                            style: AppTextStyles.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: AppColors.red600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.toggleEditMode(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.indigo500,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          limit == null ? "Configure Limits" : "Edit Limits",
                          style: AppTextStyles.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ],

            // EMERGENCY ACTIONS CARD (Available if broker connected)
            if (hasBroker) ...[
              _buildConfigCard(
                title: "EMERGENCY ACTIONS",
                children: [
                  Text(
                    "Triggering the emergency kill switch will immediately flatten all open positions and block further orders for the rest of today.",
                    style: AppTextStyles.openSans(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red600,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : controller.triggerEmergencyKill,
                      icon: isLoading
                          ? SizedBox(
                              height: 18.w,
                              width: 18.w,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(Icons.flash_on, size: 20.sp),
                      label: Text(
                        "Trigger Emergency Kill Switch",
                        style: AppTextStyles.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildConfigCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildConfigRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.openSans(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.poppins(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) ...[
          SizedBox(height: 4.h),
          Divider(color: AppColors.divider),
          SizedBox(height: 4.h),
        ],
      ],
    );
  }

  Widget _buildProfitLockBox(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.openSans(
              fontSize: 10.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyles.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
