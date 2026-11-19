// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import '../modules/nav/views/nav_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/logs/bindings/logs_binding.dart';
import '../modules/tradeConfig/bindings/trade_config_binding.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/brokerLink/bindings/broker_link_binding.dart';
import '../modules/brokerLink/views/broker_link_view.dart';
import '../modules/limits/bindings/limits_binding.dart';
import '../modules/limits/views/limits_view.dart';
import '../modules/nav/bindings/nav_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => NavView(),
      bindings: [
        NavBinding(),
        DashboardBinding(),
        LogsBinding(),
        TradeConfigBinding(),
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.BROKER_LINK,
      page: () => const BrokerLinkView(),
      binding: BrokerLinkBinding(),
    ),
    GetPage(
      name: _Paths.LIMITS,
      page: () => const LimitsView(),
      binding: LimitsBinding(),
    ),
  ];
}
