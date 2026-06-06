import 'package:an_gi/features/meal_plan/presentation/pages/meal_plan_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // 1. Đảm bảo các dịch vụ của Flutter được khởi tạo đầy đủ
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Supabase Client
  await Supabase.initialize(
    url: 'https://rxgsujnugkwrltaepjmg.supabase.co',
    publishableKey: 'sb_publishable_lxDUfPVyWhMqfccIkiPJlw_LLjs3Bb1',
  );

  // 3. Khởi tạo Storage cho HydratedBLoC (Xử lý lưu dữ liệu offline)
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );

  // 4. Chạy ứng dụng
  runApp(const AnGiApp());
}

class AnGiApp extends StatelessWidget {
  const AnGiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ăn Gì?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const MealPlanPage(),
    );
  }
}
