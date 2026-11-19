import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/baseclient/base_client.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_service.dart';

import '../../../data/repositories/trade_repository.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  final _client = Get.find<BaseClient>();
  final _tradeRepo = TradeRepository();
  
  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please enter email and password';
      return;
    }
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final response = await _client.dio.post('/api/auth/login', data: {
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
        errorMessage.value = 'Invalid login response structure';
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errData = e.response?.data;
        if (errData is Map && errData['message'] != null) {
          errorMessage.value = errData['message'];
        } else {
          errorMessage.value = 'Login failed. Please check credentials.';
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
