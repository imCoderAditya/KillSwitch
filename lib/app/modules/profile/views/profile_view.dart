import 'package:flutter/material.dart';
import 'package:killswitch/app/core/theme/app_colors.dart';
import 'package:killswitch/app/core/theme/app_text_styles.dart';
import 'package:killswitch/app/core/theme/theme_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:killswitch/components/snack_bar_view.dart';
import '../../logs/controllers/logs_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.userProfile.value;
      String name = profile?.name ?? "";
      String email = profile?.email ?? "";
      String mobile = "8978821901";
      String activeSince = "6 Feb 2026";

      if (profile != null && profile.createdAt.isNotEmpty) {
        try {
          DateTime dt = DateTime.parse(profile.createdAt);
          List<String> months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];
          activeSince = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
        } catch (_) {}
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            // Profile Header Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.divider, width: 1.w),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36.r,
                    backgroundColor: AppColors.divider,
                    child: ClipOval(
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyles.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: AppColors.green500,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Account Active",
                              style: AppTextStyles.openSans(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // INFO Card
            _buildConfigCard(
              title: "INFO",
              children: [
                _buildProfileInfoRow(Icons.mail_outline, "Email", email),
                _buildProfileInfoRow(Icons.phone_outlined, "Mobile", mobile),
                _buildProfileInfoRow(
                  Icons.calendar_today_outlined,
                  "Active since",
                  activeSince,
                  isLast: true,
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // SUBSCRIPTION Card
            _buildConfigCard(
              title: "SUBSCRIPTION",
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green100,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "Active",
                        style: AppTextStyles.poppins(
                          fontSize: 10.sp,
                          color: AppColors.green800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  "Yearly",
                  style: AppTextStyles.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.openSans(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(text: "Expired On: 12 Apr 2027 · "),
                      TextSpan(
                        text: "308 days left",
                        style: AppTextStyles.poppins(
                          color: AppColors.red600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Started: 10 May 2026",
                  style: AppTextStyles.openSans(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // SECURITY & TOOLS Card
            _buildConfigCard(
              title: "SECURITY & TOOLS",
              children: [
                _buildClickableRow(
                  Icons.history_outlined,
                  "Session History",
                  () => _showSessionHistorySheet(context),
                ),
                _buildClickableRow(
                  Icons.lock_outline,
                  "Change Password",
                  () => _showChangePasswordDialog(context),
                  isLast: true,
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // APPEARANCE & THEME Card
            Obx(() {
              final themeCtrl = Get.put(ThemeController());
              return _buildConfigCard(
                title: "APPEARANCE & THEME",
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.rose200,
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                            color: AppColors.rose100,
                          ),
                          child: Icon(
                            themeCtrl.isDarkMode.value
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            color: AppColors.rose600,
                            size: 16.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "Dark Mode",
                            style: AppTextStyles.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Switch(
                          value: themeCtrl.isDarkMode.value,
                          activeThumbColor: AppColors.indigo500,
                          onChanged: (val) {
                            themeCtrl.toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 12.h),

            // Link banner
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                border: Border.all(color: AppColors.blue200, width: 1.w),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.red600,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.openSans(
                          fontSize: 12.sp,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "To update or link accounts and preferences, visit ",
                          ),
                          TextSpan(
                            text: "killswitch.in",
                            style: AppTextStyles.poppins(
                              color: AppColors.red600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 18.sp,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Action buttons
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red600,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 0,
                ),
                onPressed: controller.logout,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text(
                      "Logout",
                      style: AppTextStyles.poppins(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  side: BorderSide(color: AppColors.red200, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text("Delete Account"),
                      content: Text(
                        "Are you sure you want to delete your account? This action is irreversible.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            controller.logout();
                          },
                          child: Text(
                            "Delete",
                            style: AppTextStyles.poppins(
                              color: AppColors.red600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: AppColors.red600,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Delete Account",
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
      );
    });
  }

  Widget _buildConfigCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
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

  Widget _buildProfileInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 18.sp),
              SizedBox(width: 12.w),
              Text(
                label,
                style: AppTextStyles.openSans(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
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

  Widget _buildClickableRow(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.rose200, width: 1.w),
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.rose100,
                  ),
                  child: Icon(icon, color: AppColors.rose600, size: 16.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 18.sp,
                ),
              ],
            ),
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

  void _showChangePasswordDialog(BuildContext context) {
    Get.dialog(
      const _ChangePasswordDialog(),
      barrierDismissible: false,
    );
  }

  void _showSessionHistorySheet(BuildContext context) {
    final logsCtrl = Get.find<LogsController>();
    logsCtrl.fetchSessionsHistory();

    Get.bottomSheet(
      Container(
        height: 500.h,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Session History',
                    style: AppTextStyles.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.divider),
            Expanded(
              child: Obx(() {
                if (logsCtrl.isFetchingSessions.value &&
                    logsCtrl.historicalSessions.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.indigo500,
                    ),
                  );
                }

                if (logsCtrl.historicalSessions.isEmpty) {
                  return Center(
                    child: Text(
                      'No past sessions found.',
                      style: AppTextStyles.openSans(
                        color: AppColors.textSecondary,
                        fontSize: 13.sp,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  itemCount:
                      logsCtrl.historicalSessions.length +
                      (logsCtrl.hasMoreSessions.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == logsCtrl.historicalSessions.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Center(
                          child: TextButton(
                            onPressed: () =>
                                logsCtrl.fetchSessionsHistory(loadMore: true),
                            child: Text(
                              'Load More',
                              style: AppTextStyles.poppins(
                                color: AppColors.indigo500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final session = logsCtrl.historicalSessions[index];
                    final isPositive = session.netPnL >= 0;

                    return Card(
                      color: AppColors.cardBackground,
                      surfaceTintColor: AppColors.cardBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: AppColors.divider),
                      ),
                      margin: EdgeInsets.only(bottom: 10.h),
                      child: ListTile(
                        onTap: () => _showSessionDetails(context, session.id),
                        title: Text(
                          session.id.length > 8
                              ? 'ID: ...${session.id.substring(session.id.length - 8)}'
                              : 'ID: ${session.id}',
                          style: AppTextStyles.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          'Status: ${session.status.toUpperCase()}',
                          style: AppTextStyles.openSans(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${session.netPnL.toStringAsFixed(2)}',
                              style: AppTextStyles.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: isPositive
                                    ? AppColors.green600
                                    : AppColors.red600,
                              ),
                            ),
                            Text(
                              '${session.tradesCount} trades',
                              style: AppTextStyles.openSans(
                                fontSize: 10.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionDetails(BuildContext context, String sessionId) async {
    final logsCtrl = Get.find<LogsController>();
    final detail = await logsCtrl.fetchSessionDetails(sessionId);
    if (detail == null) {
      SnackBarUiView.showError(message: 'Unable to fetch session details.');
      return;
    }

    final isPositive = detail.netPnL >= 0;

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBackground,
        surfaceTintColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Session Details',
          style: AppTextStyles.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Session ID', detail.id),
            _buildDetailRow('Status', detail.status.toUpperCase()),
            _buildDetailRow(
              'Net P&L',
              '₹${detail.netPnL.toStringAsFixed(2)}',
              valueColor: isPositive ? AppColors.green600 : AppColors.red600,
            ),
            _buildDetailRow('Trades Count', '${detail.tradesCount}'),
            _buildDetailRow('Positions', '${detail.positionsCount}'),
            _buildDetailRow('Orders Placed', '${detail.ordersCount}'),
            _buildDetailRow(
              'Locked Profit',
              '₹${detail.lockedProfit.toStringAsFixed(2)}',
            ),
            if (detail.breachReason != null && detail.breachReason!.isNotEmpty)
              _buildDetailRow(
                'Breach Reason',
                detail.breachReason!,
                valueColor: AppColors.red600,
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.openSans(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: AppTextStyles.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  late final TextEditingController currentPasswordCtrl;
  late final TextEditingController newPasswordCtrl;
  late final TextEditingController confirmPasswordCtrl;
  final formKey = GlobalKey<FormState>();

  final showCurrent = false.obs;
  final showNew = false.obs;
  final showConfirm = false.obs;
  final passwordStrength = 0.obs; // 0–4

  @override
  void initState() {
    super.initState();
    currentPasswordCtrl = TextEditingController();
    newPasswordCtrl = TextEditingController();
    confirmPasswordCtrl = TextEditingController();
  }

  @override
  void dispose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _updateStrength(String val) {
    int score = 0;
    if (val.length >= 6) score++;
    if (val.length >= 10) score++;
    if (val.contains(RegExp(r'[A-Z]'))) score++;
    if (val.contains(RegExp(r'[0-9]'))) score++;
    if (val.contains(RegExp(r'[!@#\$&*~%^()_\-+=\[\]{}|;:,.<>?]'))) score++;
    passwordStrength.value = score.clamp(0, 4);
  }

  Widget _strengthBar() {
    return Obx(() {
      final s = passwordStrength.value;
      final colors = [
        AppColors.red500,
        AppColors.orange600,
        AppColors.amber600,
        AppColors.green600,
        AppColors.green500,
      ];
      final labels = ['', 'Weak', 'Fair', 'Good', 'Strong'];
      final labelColors = [
        AppColors.textSecondary,
        AppColors.red500,
        AppColors.orange600,
        AppColors.amber600,
        AppColors.green600,
      ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (i) {
              final filled = i < s;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4.h,
                  margin: EdgeInsets.only(right: i < 3 ? 4.w : 0),
                  decoration: BoxDecoration(
                    color: filled ? colors[s] : AppColors.divider,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            }),
          ),
          if (s > 0) ...[
            SizedBox(height: 4.h),
            Text(
              labels[s],
              style: AppTextStyles.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: labelColors[s],
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildField({
    required TextEditingController ctrl,
    required RxBool show,
    required String label,
    required String hint,
    required IconData icon,
    void Function(String)? onChanged,
    required String? Function(String?) validator,
  }) {
    return Obx(
      () => TextFormField(
        controller: ctrl,
        obscureText: !show.value,
        onChanged: onChanged,
        style: AppTextStyles.poppins(
          fontSize: 14.sp,
          color: AppColors.textPrimary,
        ),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: AppTextStyles.poppins(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
          ),
          hintStyle: AppTextStyles.openSans(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(10.w),
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 14.sp, color: Colors.white),
          ),
          suffixIcon: Obx(
            () => GestureDetector(
              onTap: () => show.value = !show.value,
              child: Container(
                margin: EdgeInsets.all(10.w),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Icon(
                  show.value
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          filled: true,
          fillColor: AppColors.inputBackground,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 16.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.red500),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.red500, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.18),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Gradient Banner ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 28.h),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF4F46E5),
                        Color(0xFF7C3AED),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.security_rounded,
                          color: Colors.white,
                          size: 26.sp,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change Password',
                              style: AppTextStyles.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Keep your account safe & secure',
                              style: AppTextStyles.openSans(
                                fontSize: 12.sp,
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Form body ──
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Current password
                        _buildField(
                          ctrl: currentPasswordCtrl,
                          show: showCurrent,
                          label: 'Current Password',
                          hint: 'Enter your current password',
                          icon: Icons.lock_outlined,
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),

                        // New password + strength
                        _buildField(
                          ctrl: newPasswordCtrl,
                          show: showNew,
                          label: 'New Password',
                          hint: 'Min. 6 characters',
                          icon: Icons.lock_reset_rounded,
                          onChanged: _updateStrength,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Required';
                            }
                            if (val.length < 6) {
                              return 'At least 6 characters required';
                            }
                            if (val == currentPasswordCtrl.text) {
                              return 'Must differ from current password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8.h),
                        _strengthBar(),
                        SizedBox(height: 14.h),

                        // Confirm password
                        _buildField(
                          ctrl: confirmPasswordCtrl,
                          show: showConfirm,
                          label: 'Confirm Password',
                          hint: 'Re-enter new password',
                          icon: Icons.verified_user_outlined,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Required';
                            }
                            if (val != newPasswordCtrl.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 22.h),

                        // ── Buttons ──
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  side: BorderSide(
                                    color: AppColors.divider,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                onPressed: () => Get.back(),
                                child: Text(
                                  'Cancel',
                                  style: AppTextStyles.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              flex: 2,
                              child: Obx(() {
                                final loading =
                                    controller.isChangingPassword.value;
                                return GestureDetector(
                                  onTap: loading
                                      ? null
                                      : () async {
                                          if (formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            final success = await controller
                                                .changePassword(
                                                  currentPasswordCtrl.text,
                                                  newPasswordCtrl.text,
                                                );
                                            if (success) Get.back();
                                          }
                                        },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      gradient: loading
                                          ? LinearGradient(
                                              colors: [
                                                AppColors.slate400,
                                                AppColors.slate500,
                                              ],
                                            )
                                          : const LinearGradient(
                                              colors: [
                                                Color(0xFF6366F1),
                                                Color(0xFF7C3AED),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: loading
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF6366F1,
                                                ).withValues(alpha: 0.4),
                                                blurRadius: 16,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                    ),
                                    child: Center(
                                      child: loading
                                          ? SizedBox(
                                              width: 20.w,
                                              height: 20.w,
                                              child:
                                                  const CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.lock_open_rounded,
                                                  size: 16.sp,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  'Update Password',
                                                  style: AppTextStyles.poppins(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
