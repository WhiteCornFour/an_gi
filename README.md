# an_gi

A new Flutter project.

## Getting Started

lib/
├── core/                  # Chứa cấu hình dùng chung toàn app
│   ├── constants/         # Biến hằng số, màu sắc, font chữ
│   ├── network/           # Cấu hình Dio Client, Supabase Client, Cache
│   ├── theme/             # Cấu hình giao diện Sáng/Tối
│   └── utils/             # Tiện ích định dạng tiền tệ, ngày tháng
├── features/              # Chia theo từng tính năng của ứng dụng
│   ├── meal_plan/         # Tính năng Gợi ý thực đơn & Khóa/Xoay
│   │   ├── data/          # Models, Datasources, Repositories Impl
│   │   ├── domain/        # Entities, Usecases, Repositories Interface
│   │   └── presentation/  # BLoC, Pages, Widgets
│   ├── shopping_list/     # Tính năng Danh sách đi chợ thông minh
│   └── auth/              # Tính năng Đăng nhập
└── main.dart              # Điểm khởi chạy ứng dụng
