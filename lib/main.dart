import 'package:an_gi/core/app_config/app_config_cubit.dart';
import 'package:an_gi/core/localization/language_cubit.dart';
import 'package:an_gi/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(create: (context) => LanguageCubit()),
        BlocProvider<AppConfigCubit>(create: (context) => AppConfigCubit()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );
  }
}
