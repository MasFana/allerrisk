import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/services/storage_service.dart';
import 'app/core/services/auth_service.dart';
import 'app/core/services/notification_service.dart';
import 'app/core/services/pdf_service.dart';
import 'app/bindings/app_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/constants/app_strings.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id');

  // Services must be initialized in order.
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => NotificationService().init());
  await Get.putAsync(() => PdfService().init());

  runApp(const AllerRiskApp());
}

class AllerRiskApp extends StatelessWidget {
  const AllerRiskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      themeMode: ThemeMode.light,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}
