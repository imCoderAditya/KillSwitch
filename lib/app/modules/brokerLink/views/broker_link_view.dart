import 'package:flutter/material.dart';
import 'package:killswitch/app/core/theme/app_colors.dart';
import 'package:killswitch/app/core/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/models/api_models.dart';
import '../controllers/broker_link_controller.dart';

class BrokerLinkView extends GetView<BrokerLinkController> {
  const BrokerLinkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.scaffoldBackground, // Light Slate 100
        appBar: AppBar(
          title: Text(
            'Connect Broker',
            style: AppTextStyles.poppins(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: AppColors.divider, height: 1),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Link Broker Account',
                style: AppTextStyles.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Select your stock broker and configure access keys to allow risk monitoring.',
                style: AppTextStyles.openSans(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),

              // --- Active Connections Section ---
              Text(
                'Active Connections',
                style: AppTextStyles.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 10.h),

              Obx(() {
                if (controller.isFetching.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: CircularProgressIndicator(
                        color: AppColors.indigo500,
                      ),
                    ),
                  );
                }

                if (controller.connectedBrokers.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 24.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.divider, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_balance_outlined,
                          size: 36.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No Broker Connected',
                          style: AppTextStyles.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Link a stock broker below to start trading and enforcing risk controls.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.openSans(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.connectedBrokers.length,
                  itemBuilder: (context, index) {
                    final broker = controller.connectedBrokers[index];
                    return _buildConnectedBrokerCard(broker);
                  },
                );
              }),

              Divider(color: AppColors.divider, thickness: 1),
              SizedBox(height: 24.h),

              // --- Connect New Broker Form ---
              Text(
                'Link New Account',
                style: AppTextStyles.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                'Select Stock Broker',
                style: AppTextStyles.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                final sup = controller.supportedBrokers.value;
                List<String> liveList = sup?.live ?? ['dhan'];
                List<String> comingSoonList =
                    sup?.comingSoon ?? ['zerodha', 'upstox', 'angelone'];
                List<String> fullList = [...liveList, ...comingSoonList];

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.divider, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedBroker.value,
                      dropdownColor: AppColors.cardBackground,
                      style: AppTextStyles.poppins(
                        color: AppColors.textPrimary,
                      ),
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.textSecondary,
                      ),
                      items: fullList.map((String value) {
                        bool isLive = liveList.contains(value);
                        return DropdownMenuItem<String>(
                          value: value,
                          enabled: isLive,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value.toUpperCase(),
                                style: AppTextStyles.poppins(
                                  color: isLive
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  fontWeight: isLive
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                              if (!isLive)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.scaffoldBackground,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(
                                      color: AppColors.divider,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    'SOON',
                                    style: AppTextStyles.poppins(
                                      fontSize: 8.sp,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.selectedBroker.value = newValue;
                        }
                      },
                    ),
                  ),
                );
              }),
              SizedBox(height: 20.h),

              Text(
                'Client ID / Trader ID',
                style: AppTextStyles.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.clientIdController,
                style: AppTextStyles.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Enter your Client ID',
                  hintStyle: AppTextStyles.poppins(
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.divider, width: 1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.divider, width: 1),
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
                'API Access Key / Token',
                style: AppTextStyles.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.apiKeyController,
                obscureText: true,
                style: AppTextStyles.poppins(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Enter access token',
                  hintStyle: AppTextStyles.poppins(
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.divider, width: 1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.divider, width: 1),
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
                String infoText = '';
                switch (controller.selectedBroker.value.toLowerCase()) {
                  case 'dhan':
                    infoText =
                        'For Dhan: Generate access token under Dhan App > Profile > Dhan API Console.';
                    break;
                  case 'zerodha':
                    infoText =
                        'For Zerodha: Create an app in Kite Connect Developer Portal to generate API key.';
                    break;
                  default:
                    infoText =
                        'Enter the client ID and token provided by your broker.';
                }
                return Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.blue50,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.blue200, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.blue700),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          infoText,
                          style: AppTextStyles.openSans(
                            color: AppColors.blue800,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 24.h),

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
                    color: AppColors.indigo500,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.indigo500.withValues(alpha: 0.2),
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
                          : controller.connectBroker,
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
                                'Connect Account',
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
      ),
    );
  }

  Widget _buildConnectedBrokerCard(BrokerConnection broker) {
    Color badgeColor;
    switch (broker.broker.toLowerCase()) {
      case 'dhan':
        badgeColor = AppColors.dhanColor; // Teal
        break;
      case 'zerodha':
        badgeColor = AppColors.orange600; // Orange
        break;
      default:
        badgeColor = AppColors.indigo600; // Indigo
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: badgeColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                broker.broker.isNotEmpty
                    ? broker.broker.substring(0, 1).toUpperCase()
                    : 'B',
                style: AppTextStyles.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  broker.broker.toUpperCase(),
                  style: AppTextStyles.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Client ID: ${broker.clientId}',
                  style: AppTextStyles.openSans(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  broker.balance != null
                      ? 'Balance: ₹${broker.balance!.toStringAsFixed(2)}'
                      : 'Balance: N/A',
                  style: AppTextStyles.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: broker.balance != null
                        ? AppColors.green600
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.link_off, color: AppColors.rose600),
            tooltip: 'Disconnect Broker',
            onPressed: () => _showDisconnectConfirmation(broker),
          ),
        ],
      ),
    );
  }

  void _showDisconnectConfirmation(BrokerConnection broker) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBackground,
        surfaceTintColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Disconnect ${broker.broker.toUpperCase()}?',
          style: AppTextStyles.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to disconnect this broker? This will remove access and any associated risk limits.',
          style: AppTextStyles.openSans(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.poppins(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rose600,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              Get.back();
              controller.disconnectBroker(broker.id);
            },
            child: Text(
              'Disconnect',
              style: AppTextStyles.poppins(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
