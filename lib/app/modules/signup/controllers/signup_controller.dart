import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:killswitch/components/snack_bar_view.dart';
import '../../../data/baseclient/base_client.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_service.dart';
import '../../../data/repositories/trade_repository.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  final _client = Get.find<BaseClient>();
  final _tradeRepo = TradeRepository();
  
  void signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please fill all fields';
      return;
    }
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final response = await _client.dio.post('/api/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      
      final data = response.data;
      if (data != null && data['data'] != null && data['data']['token'] != null) {
        final token = data['data']['token'];
        await StorageService.to.saveToken(token);
        
        if (data['data']['user'] != null) {
          await StorageService.to.saveUserData(Map<String, dynamic>.from(data['data']['user']));
        }
        Get.offAllNamed(Routes.HOME);
      } else {
        SnackBarUiView.showSuccess(
          message: 'Please sign in with your new credentials.',
          icon: Icons.check_circle_outline_rounded,
        );
        Get.offAllNamed(Routes.LOGIN);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errData = e.response?.data;
        if (errData is Map && errData['message'] != null) {
          errorMessage.value = errData['message'];
        } else {
          errorMessage.value = 'Registration failed. Try a different email.';
        }
      } else {
        errorMessage.value = 'Network error. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred.';
    } finally {
      isLoading.value = false;
    }
  }

  void loginWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _tradeRepo.googleLogin(
        name: 'Rohit Google',
        email: 'rohit.google@example.com',
        googleId: '1234567890abcdef',
        profilePicture: 'https://lh3.googleusercontent.com/a/randomimage',
      );
      
      if (response['success'] == true && response['data'] != null && response['data']['token'] != null) {
        final token = response['data']['token'];
        await StorageService.to.saveToken(token);
        
        if (response['data']['user'] != null) {
          await StorageService.to.saveUserData(Map<String, dynamic>.from(response['data']['user']));
        }
        
        Get.offAllNamed(Routes.HOME);
      } else {
        errorMessage.value = 'Invalid google login response';
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errData = e.response?.data;
        if (errData is Map && errData['message'] != null) {
          errorMessage.value = errData['message'];
        } else {
          errorMessage.value = 'Google Login failed.';
        }
      } else {
        errorMessage.value = 'Network error. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred during Google Sign-In.';
    } finally {
      isLoading.value = false;
    }
  }

  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
