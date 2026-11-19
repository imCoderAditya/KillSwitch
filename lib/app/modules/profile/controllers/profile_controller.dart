import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:killswitch/components/snack_bar_view.dart';
import '../../../data/models/api_models.dart';
import '../../../data/repositories/trade_repository.dart';
import '../../../services/storage_service.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final _tradeRepo = TradeRepository();

  final isLoading = false.obs;
  final userProfile = Rxn<UserProfile>();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      final profile = await _tradeRepo.fetchUserProfile();
      userProfile.value = profile;
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final isChangingPassword = false.obs;

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    isChangingPassword.value = true;
    try {
      await _tradeRepo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      SnackBarUiView.showSuccess(
        message: 'Password changed successfully.',
        icon: Icons.lock_open_rounded,
      );
      return true;
    } catch (e) {
      SnackBarUiView.showError(
        message: 'Failed to change password. Please verify current password.',
      );
      return false;
    } finally {
      isChangingPassword.value = false;
    }
  }

  void logout() async {
    await StorageService.to.clearAll();
    Get.offAllNamed(Routes.LOGIN);
  }
}
