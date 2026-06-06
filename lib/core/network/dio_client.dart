import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class DioClient {
  late final Dio _dio;

  // Cấu hình Base URL dẫn tới REST API của Supabase
  static const String _baseUrl =
      'https://rxgsujnugkwrltaepjmg.supabase.co/rest/v1';
  // Mã khóa công khai (Publishable/Anon Key) để định danh ứng dụng
  static const String _supabaseKey =
      'sb_publishable_lxDUfPVyWhMqfccIkiPJlw_LLjs3Bb1';

  DioClient() {
    // 1. Thiết lập cấu hình Cache Options (Lưu cache trong bộ nhớ RAM tạm thời)
    // Mẹo: Bạn có thể đổi sang HiveCacheStore hoặc FileCacheStore nếu muốn lưu vĩnh viễn xuống ổ đĩa
    final cacheOptions = CacheOptions(
      store: MemCacheStore(), // Lưu cache trên RAM
      policy: CachePolicy
          .refreshForceCache, // Lấy dữ liệu mới nếu có mạng, mất mạng tự động lôi cache ra dùng [cite: 184]
      maxStale: const Duration(
        days: 7,
      ), // Thời gian cache tối đa là 7 ngày (phù hợp với thực đơn tuần) [cite: 147]
      priority: CachePriority.normal,
    );

    // 2. Khởi tạo Dio với các tham số mặc định
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(
          seconds: 5,
        ), // Quá 5s không kết nối được sẽ kích hoạt cache [cite: 184]
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'apikey': _supabaseKey,
          'Authorization': 'Bearer $_supabaseKey',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 3. Tích hợp bộ chặn (Interceptors) xử lý Cache [cite: 113, 182]
    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    // Thêm Log Interceptor để bạn dễ dàng debug, theo dõi dòng dữ liệu chạy trong Terminal khi Dev
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  // Hàm Getter để các Repository ở tầng Data có thể lấy ra sử dụng
  Dio get dio => _dio;
}
