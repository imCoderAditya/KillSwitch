import 'package:flutter/material.dart';
import 'package:killswitch/app/core/theme/app_colors.dart';
import 'package:killswitch/app/core/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/models/api_models.dart';
import '../controllers/logs_controller.dart';

class LogsView extends GetView<LogsController> {
  const LogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.historicalSessions.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        color: AppColors.indigo500,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Stats Summary Cards ──
                    _buildStatsSummary(),
                    SizedBox(height: 20.h),

                    // ── Today's Session ──
                    _buildTodaySession(),
                    SizedBox(height: 20.h),

                    // ── Sessions History Header ──
                    Row(
                      children: [
                        Container(
                          width: 3.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: AppColors.indigo500,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'SESSION HISTORY',
                          style: AppTextStyles.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),

            // ── Sessions list ──
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == controller.historicalSessions.length) {
                    return _buildLoadMoreFooter();
                  }
                  return Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
                    child: _buildSessionCard(controller.historicalSessions[index]),
                  );
                },
                childCount: controller.historicalSessions.length + 1,
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─────────────────────────────────────────
  // Stats Summary Strip
  // ─────────────────────────────────────────
  Widget _buildStatsSummary() {
    final stats = controller.statsSummary.value;
    final totalPnL = stats?.totalPnL ?? 0.0;
    final totalBreaches = stats?.totalBreaches ?? 0;
    final totalSessions = stats?.totalSessions ?? 0;
    final avgPnL = stats?.averagePnL ?? 0.0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.slate200.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ALL TIME SUMMARY',
            style: AppTextStyles.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryTile(
                  label: 'Total P&L',
                  value: '₹${totalPnL.toStringAsFixed(2)}',
                  valueColor: totalPnL >= 0 ? AppColors.green600 : AppColors.red600,
                  icon: Icons.show_chart_rounded,
                  iconColor: totalPnL >= 0 ? AppColors.green600 : AppColors.red600,
                ),
              ),
              _buildVerticalDivider(),
              Expanded(
                child: _buildSummaryTile(
                  label: 'Avg P&L',
                  value: '₹${avgPnL.toStringAsFixed(2)}',
                  valueColor: avgPnL >= 0 ? AppColors.green600 : AppColors.red600,
                  icon: Icons.analytics_outlined,
                  iconColor: AppColors.blue600,
                ),
              ),
              _buildVerticalDivider(),
              Expanded(
                child: _buildSummaryTile(
                  label: 'Sessions',
                  value: '$totalSessions',
                  valueColor: AppColors.textPrimary,
                  icon: Icons.calendar_today_rounded,
                  iconColor: AppColors.indigo500,
                ),
              ),
              _buildVerticalDivider(),
              Expanded(
                child: _buildSummaryTile(
                  label: 'Breaches',
                  value: '$totalBreaches',
                  valueColor: totalBreaches > 0 ? AppColors.red600 : AppColors.textPrimary,
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppColors.orange600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40.h,
      color: AppColors.divider,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
    );
  }

  Widget _buildSummaryTile({
    required String label,
    required String value,
    required Color valueColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16.sp, color: iconColor),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.openSans(
            fontSize: 9.sp,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // Today's Session Card
  // ─────────────────────────────────────────
  Widget _buildTodaySession() {
    final session = controller.todaySession.value;
    if (session == null) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.divider),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 32.sp, color: AppColors.textSecondary),
              SizedBox(height: 8.h),
              Text(
                'No active session today',
                style: AppTextStyles.poppins(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isHalted = session.status.toUpperCase() == 'HALTED';
    final isActive = session.status.toUpperCase() == 'ACTIVE';
    final statusColor = isActive
        ? AppColors.green600
        : isHalted
            ? AppColors.red600
            : AppColors.amber600;
    final statusBg = isActive
        ? AppColors.green50
        : isHalted
            ? AppColors.red50
            : AppColors.amber100;
    final pnl = session.netPnL;
    final breachReason = session.breachReason ?? '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isHalted ? AppColors.red200 : AppColors.divider,
          width: isHalted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.slate200.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "TODAY'S SESSION",
                  style: AppTextStyles.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    session.status.toUpperCase(),
                    style: AppTextStyles.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildSessionStatItem(
                        label: 'P&L',
                        value: '₹${pnl.toStringAsFixed(2)}',
                        color: pnl >= 0 ? AppColors.green600 : AppColors.red600,
                        icon: Icons.currency_rupee_rounded,
                      ),
                    ),
                    Expanded(
                      child: _buildSessionStatItem(
                        label: 'Trades',
                        value: '${session.tradesCount}',
                        color: AppColors.textPrimary,
                        icon: Icons.swap_horiz_rounded,
                      ),
                    ),
                    Expanded(
                      child: _buildSessionStatItem(
                        label: 'Broker',
                        value: session.brokerName?.toUpperCase() ?? 'N/A',
                        color: session.brokerName != null
                            ? AppColors.dhanColor
                            : AppColors.textSecondary,
                        icon: Icons.account_balance_rounded,
                      ),
                    ),
                  ],
                ),

                // Breach reason
                if (breachReason.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.red50Variant,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.red200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 14.sp, color: AppColors.red600),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            breachReason,
                            style: AppTextStyles.openSans(
                              fontSize: 11.sp,
                              color: AppColors.red600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Reactivate button only when HALTED
                if (isHalted) ...[
                  SizedBox(height: 14.h),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        height: 42.h,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigo500,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: controller.isReactivating.value
                              ? null
                              : () => controller.reactivateSession(session.id),
                          icon: controller.isReactivating.value
                              ? SizedBox(
                                  width: 16.w,
                                  height: 16.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(Icons.play_arrow_rounded, size: 18.sp),
                          label: Text(
                            controller.isReactivating.value
                                ? 'Reactivating...'
                                : 'Reactivate Session',
                            style: AppTextStyles.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      )),
                ],

                // Audit logs
                if (session.auditLog.isNotEmpty) ...[
                  SizedBox(height: 14.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'AUDIT LOG',
                      style: AppTextStyles.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ...session.auditLog.reversed
                      .take(5)
                      .map((log) => _buildAuditLogRow(log)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStatItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18.sp, color: color),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.openSans(
            fontSize: 10.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // Session History Card
  // ─────────────────────────────────────────
  Widget _buildSessionCard(TradingSession session) {
    final isHalted = session.status.toUpperCase() == 'HALTED';
    final isActive = session.status.toUpperCase() == 'ACTIVE';
    final statusColor = isActive
        ? AppColors.green600
        : isHalted
            ? AppColors.red600
            : AppColors.amber600;

    final dateStr = _formatDate(session.date);
    final pnl = session.netPnL;
    final breachReason = (session.breachReason ?? '').trim();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          childrenPadding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
          leading: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              isActive
                  ? Icons.play_circle_outline_rounded
                  : isHalted
                      ? Icons.pause_circle_outline_rounded
                      : Icons.circle_outlined,
              color: statusColor,
              size: 20.sp,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: AppTextStyles.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (session.brokerName != null)
                      Text(
                        session.brokerName!.toUpperCase(),
                        style: AppTextStyles.openSans(
                          fontSize: 10.sp,
                          color: AppColors.dhanColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${pnl.toStringAsFixed(2)}',
                    style: AppTextStyles.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: pnl >= 0 ? AppColors.green600 : AppColors.red600,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      session.status.toUpperCase(),
                      style: AppTextStyles.poppins(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            // Quick info row
            Row(
              children: [
                _buildChip(
                  icon: Icons.swap_horiz_rounded,
                  label: '${session.tradesCount} trades',
                  color: AppColors.blue600,
                ),
                SizedBox(width: 6.w),
                _buildChip(
                  icon: Icons.list_alt_rounded,
                  label: '${session.auditLog.length} events',
                  color: AppColors.indigo500,
                ),
              ],
            ),

            // Breach reason
            if (breachReason.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: AppColors.red50Variant,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.red200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.gpp_bad_outlined,
                        size: 13.sp, color: AppColors.red600),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        breachReason,
                        style: AppTextStyles.openSans(
                          fontSize: 11.sp,
                          color: AppColors.red600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Audit logs
            if (session.auditLog.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'AUDIT LOG',
                  style: AppTextStyles.poppins(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              ...session.auditLog.reversed.map((log) => _buildAuditLogRow(log)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Audit Log Row
  // ─────────────────────────────────────────
  Widget _buildAuditLogRow(AuditLogItem log) {
    Color dotColor;
    final action = log.action.toUpperCase();
    switch (action) {
      case 'KILL_SWITCH_TRIGGERED':
        dotColor = AppColors.red600;
        break;
      case 'SESSION_REACTIVATED':
        dotColor = AppColors.green600;
        break;
      case 'CONFIRMED':
        dotColor = AppColors.green600;
        break;
      case 'WARNING':
        dotColor = AppColors.orange600;
        break;
      case 'ERROR':
        dotColor = AppColors.red600;
        break;
      case 'LOCK':
        dotColor = AppColors.blue600;
        break;
      default:
        dotColor = AppColors.indigo500;
    }

    String timeStr = '';
    try {
      final dt = DateTime.parse(log.timestamp).toLocal();
      timeStr =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
    } catch (_) {}

    final displayAction = action
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0]}${w.substring(1).toLowerCase()}')
        .join(' ');

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(height: 3.h),
              Container(
                width: 7.w,
                height: 7.w,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      displayAction,
                      style: AppTextStyles.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: dotColor,
                      ),
                    ),
                    Text(
                      timeStr,
                      style: AppTextStyles.openSans(
                        fontSize: 9.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  log.details,
                  style: AppTextStyles.openSans(
                    fontSize: 11.sp,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Load More Footer
  // ─────────────────────────────────────────
  Widget _buildLoadMoreFooter() {
    return Obx(() {
      if (controller.isFetchingSessions.value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Center(
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.indigo500,
              ),
            ),
          ),
        );
      }
      if (!controller.hasMoreSessions.value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Center(
            child: Text(
              '— End of history —',
              style: AppTextStyles.openSans(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.indigo500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          onPressed: () => controller.fetchSessionsHistory(loadMore: true),
          child: Text(
            'Load More',
            style: AppTextStyles.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.indigo500,
            ),
          ),
        ),
      );
    });
  }

  // ─────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────
  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}
