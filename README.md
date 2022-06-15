# Learn English App - Aki Flash

## Giới thiệu

Ứng dụng giúp tiếng Anh hiệu quả bằng việc học qua flashcard. Ứng dụng cung cấp nguồn từ vựng tiếng Anh, các bài học qua video, cho phép tra cứu bằng cách chụp hình các đồ vật.

## Công nghệ sử dụng

- **Mobile client**: [Flutter](https://flutter.dev/)
  - Đăng nhập bằng Google: [google_sign_in](https://pub.dev/packages/google_sign_in)
  - Thông báo: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
  - Youtube player: [youtube_player_flutter](https://pub.dev/packages/youtube_player_flutter)
  - ...
- **Backend server**: [Flask](https://flask.palletsprojects.com/)
  - Backend repo: [BuiChiTrung/EFlask](https://github.com/BuiChiTrung/EFlask)
  - CSDL: [MySQL](https://www.mysql.com/)
  - Nhận diện hình ảnh: [Google Cloud Vision AI](https://cloud.google.com/vision)
  - Liên hệ bằng SMS (dùng khi người dùng quên mật khẩu): [Twilio](https://www.twilio.com/)

## Thực thi

Khi chạy flutter, định nghĩa biến `API_BASE_URL` là đường dẫn đến server:

```bash
# AVD trỏ tới địa chỉ của host bằng 10.0.2.2
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5001/
```

Chạy server:

```bash
git clone https://github.com/BuiChiTrung/EFlask.git
cd EFlask
docker compose up
```
