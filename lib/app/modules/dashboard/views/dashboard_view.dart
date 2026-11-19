import 'package:flutter/material.dart';
import 'package:killswitch/app/core/theme/app_colors.dart';
import 'package:killswitch/app/core/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final session = controller.todaySession.value;
      final isSessionActive = session?.status.toUpperCase() == 'ACTIVE';
      final broker = controller.activeBroker;
      final hasBroker = broker != null;

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              // Stronger Together Partnered Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.red600, // Red
                      AppColors.textPrimary, // Slate 900
                      AppColors.dhanColor, // Teal 700
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "STRONGER TOGETHER | PROUD PARTNERS",
                      style: AppTextStyles.openSans(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white.withValues(alpha: 0.9),
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "KillSwitch",
                                style: AppTextStyles.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Container(
                                width: 14.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: AppColors.red600,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 4.w,
                                    height: 4.h,
                                    margin: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.cardBackground,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "+",
                          style: AppTextStyles.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.cardBackground,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 16.w,
                          height: 16.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.dhanColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "ध",
                            style: AppTextStyles.poppins(
                              fontSize: 9.sp,
                              color: AppColors.cardBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Dhan",
                          style: AppTextStyles.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.cardBackground,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: AppColors.cardBackground.withValues(
                            alpha: 0.8,
                          ),
                          size: 10.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Smart Risk Controls",
                          style: AppTextStyles.openSans(
                            color: AppColors.cardBackground.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: 8.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "|",
                          style: AppTextStyles.openSans(
                            color: AppColors.cardBackground,
                            fontSize: 8.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.flash_on,
                          color: AppColors.cardBackground.withValues(
                            alpha: 0.8,
                          ),
                          size: 10.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Real-time Trading",
                          style: AppTextStyles.openSans(
                            color: AppColors.cardBackground.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: 8.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "|",
                          style: AppTextStyles.openSans(
                            color: AppColors.cardBackground,
                            fontSize: 8.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.bar_chart_outlined,
                          color: AppColors.cardBackground.withValues(
                            alpha: 0.8,
                          ),
                          size: 10.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Seamless Integration",
                          style: AppTextStyles.openSans(
                            color: AppColors.cardBackground.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: 8.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Manage your full account banner
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.blue50,
                  border: Border.all(color: AppColors.blue200, width: 1.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.language, color: AppColors.blue600, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      "Manage your full account",
                      style: AppTextStyles.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue700,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.blue600,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Dynamic Broker Card (Connected vs Setup Required)
              if (hasBroker)
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.divider, width: 1.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _getBrokerColor(broker.broker),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _getBrokerLetter(broker.broker),
                              style: AppTextStyles.poppins(
                                fontSize: 18.sp,
                                color: AppColors.cardBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${broker.broker.toUpperCase()} Broker",
                                  style: AppTextStyles.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  isSessionActive
                                      ? "Logged in - monitoring is active"
                                      : "Halted - killswitch triggered",
                                  style: AppTextStyles.openSans(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSessionActive
                                  ? AppColors.green100
                                  : AppColors.red100,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              isSessionActive ? "Logged in" : "Halted",
                              style: AppTextStyles.poppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: isSessionActive
                                    ? AppColors.green800
                                    : AppColors.red800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Divider(
                        color: AppColors.scaffoldBackground,
                        thickness: 1,
                      ),
                      SizedBox(height: 12.h),

                      // Setup Progress
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Setup Progress",
                            style: AppTextStyles.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            "100%",
                            style: AppTextStyles.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: 1.0,
                          minHeight: 6.h,
                          backgroundColor: AppColors.divider,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.blue600,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "3/3 checks completed",
                        style: AppTextStyles.openSans(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Checklist Items
                      _buildChecklistItem(
                        icon: Icons.check_circle_rounded,
                        iconColor: AppColors.green500,
                        label: "Trading Configuration",
                        value: "Configured",
                        valueColor: AppColors.green500,
                      ),
                      SizedBox(height: 12.h),
                      _buildChecklistItem(
                        icon: Icons.check_circle_rounded,
                        iconColor: AppColors.green500,
                        label: "${broker.broker.toUpperCase()} Login",
                        value: "Logged in",
                        valueColor: AppColors.green500,
                        trailingWidget: broker.broker.toLowerCase() == 'dhan'
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blue50,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: AppColors.blue200,
                                    width: 1.w,
                                  ),
                                ),
                                child: Text(
                                  "Re-login",
                                  style: AppTextStyles.poppins(
                                    fontSize: 10.sp,
                                    color: AppColors.blue600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      SizedBox(height: 12.h),
                      _buildChecklistItem(
                        icon: Icons.flash_on,
                        iconColor: AppColors.green500,
                        label: "Subscription",
                        value: "Active",
                        valueColor: AppColors.green500,
                      ),

                      SizedBox(height: 12.h),
                      Center(
                        child: Text(
                          "Session: 8h 2m left",
                          style: AppTextStyles.openSans(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),
                      Divider(
                        color: AppColors.scaffoldBackground,
                        thickness: 1,
                      ),
                      SizedBox(height: 12.h),

                      // Live Funds Grid
                      if (broker.funds != null) ...[
                        Text(
                          "LIVE FUNDS",
                          style: AppTextStyles.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildFundMiniBox(
                                "Available Balance",
                                "₹${broker.funds!.availableBalance.toStringAsFixed(2)}",
                                textColor: AppColors.green600,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: _buildFundMiniBox(
                                "Utilized Amount",
                                "₹${broker.funds!.utilizedAmount.toStringAsFixed(2)}",
                                textColor: AppColors.red600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildFundMiniBox(
                                "Collateral Amount",
                                "₹${broker.funds!.collateralAmount.toStringAsFixed(2)}",
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: _buildFundMiniBox(
                                "Withdrawable",
                                "₹${broker.funds!.withdrawableBalance.toStringAsFixed(2)}",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Divider(
                          color: AppColors.scaffoldBackground,
                          thickness: 1,
                        ),
                        SizedBox(height: 12.h),
                      ],

                      // Monitoring Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Monitoring Status",
                                style: AppTextStyles.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                isSessionActive
                                    ? "Monitoring is active"
                                    : "Monitoring is stopped",
                                style: AppTextStyles.openSans(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSessionActive
                                  ? AppColors.green100
                                  : AppColors.red100,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              isSessionActive ? "Active" : "Halted",
                              style: AppTextStyles.poppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: isSessionActive
                                    ? AppColors.green800
                                    : AppColors.red800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Stop Monitoring Button
                      if (isSessionActive)
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.red100,
                              side: BorderSide(
                                color: AppColors.red200,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            onPressed: controller.triggerManualKill,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.crop_square,
                                  color: AppColors.red600,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Stop Monitoring",
                                  style: AppTextStyles.poppins(
                                    color: AppColors.red600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.divider, width: 1.w),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.01),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: AppColors.blue50,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.account_balance_outlined,
                              color: AppColors.blue600,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Link Stock Broker",
                                  style: AppTextStyles.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Setup required to start monitoring",
                                  style: AppTextStyles.openSans(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.amber100,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              "Pending Setup",
                              style: AppTextStyles.poppins(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.amber600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Divider(
                        color: AppColors.scaffoldBackground,
                        thickness: 1,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "SUPPORTED STOCK BROKERS",
                        style: AppTextStyles.openSans(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ..._buildSupportedBrokersList(),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigo500,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: () => Get.toNamed(Routes.BROKER_LINK),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 18.sp),
                              SizedBox(width: 8.w),
                              Text(
                                "Link Broker Account",
                                style: AppTextStyles.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.cardBackground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildChecklistItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
    Widget? trailingWidget,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18.sp),
        SizedBox(width: 8.w),
        Text(
          label,
          style: AppTextStyles.openSans(
            fontSize: 13.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (trailingWidget != null) ...[SizedBox(width: 8.w), trailingWidget],
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.poppins(
            fontSize: 13.sp,
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFundMiniBox(String label, String value, {Color? textColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyles.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: textColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBrokerColor(String broker) {
    switch (broker.toLowerCase()) {
      case 'dhan':
        return AppColors.dhanColor; // Teal
      case 'zerodha':
        return AppColors.orange600; // Orange
      case 'upstox':
        return AppColors.indigo600; // Indigo
      case 'angelone':
        return AppColors.blue500; // Blue
      default:
        return AppColors.indigo500; // Indigo
    }
  }

  String _getBrokerLetter(String broker) {
    if (broker.toLowerCase() == 'dhan') {
      return 'ध';
    }
    return broker.isNotEmpty ? broker.substring(0, 1).toUpperCase() : 'B';
  }

  List<Widget> _buildSupportedBrokersList() {
    final sup = controller.supportedBrokers.value;
    final liveList = sup?.live ?? ['dhan'];
    final comingSoonList = sup?.comingSoon ?? ['zerodha', 'upstox', 'angelone'];

    List<Widget> list = [];
    for (var broker in liveList) {
      list.add(_buildSupportedBrokerRow(broker, isLive: true));
    }
    for (var broker in comingSoonList) {
      list.add(_buildSupportedBrokerRow(broker, isLive: false));
    }
    return list;
  }

  Widget _buildSupportedBrokerRow(String brokerName, {required bool isLive}) {
    Color badgeColor;
    switch (brokerName.toLowerCase()) {
      case 'dhan':
        badgeColor = AppColors.dhanColor; // Teal
        break;
      case 'zerodha':
        badgeColor = AppColors.orange600; // Orange
        break;
      case 'upstox':
        badgeColor = AppColors.indigo600; // Indigo
        break;
      case 'angelone':
        badgeColor = AppColors.blue500; // Blue
        break;
      default:
        badgeColor = AppColors.textSecondary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              brokerName.toLowerCase() == 'dhan'
                  ? 'ध'
                  : brokerName.substring(0, 1).toUpperCase(),
              style: AppTextStyles.poppins(
                fontSize: 14.sp,
                color: badgeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            brokerName.toUpperCase(),
            style: AppTextStyles.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: isLive ? AppColors.green100 : AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              isLive ? "LIVE" : "SOON",
              style: AppTextStyles.poppins(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                color: isLive ? AppColors.green800 : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
