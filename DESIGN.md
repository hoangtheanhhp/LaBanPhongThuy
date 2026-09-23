---
name: Phong Thuy Compass Design System
version: 1.0.0
description: Design specification for the Vietnamese Traditional Bat Trach Feng Shui Compass Mobile App.
colors:
  background: "#121212"
  surface: "#1E1E1E"
  surfaceElevated: "#2A2A2A"
  goldAccent: "#FFD700"
  northRed: "#E50914"
  auspiciousBg: "#FFF3B0"
  auspiciousText: "#B30000"
  inauspiciousBg: "#1B4332"
  inauspiciousText: "#FFFFFF"
  cardinalBg: "#E50914"
  cardinalText: "#FFFFFF"
  son24Bg: "#FFFFFF"
  son24Text: "#1A1A1A"
  directionBg: "#E8F5E9"
  directionText: "#1B5E20"
  cungMangText: "#0D47A1"
  cungBanMenhBg: "#E50914"
  cungBanMenhText: "#FFFFFF"
  trigramRed: "#D32F2F"
  borderRing: "#1565C0"
  yinYangGreen: "#1B5E20"
  yinYangYellow: "#FFD700"

typography:
  degreeDisplay:
    fontSize: 40px
    fontWeight: 700
    color: "{colors.goldAccent}"
  directionSubtitle:
    fontSize: 16px
    fontWeight: 500
    color: "#B0B0B0"
  statusBadge:
    fontSize: 13px
    fontWeight: 600
  dialDegreeTicks:
    fontSize: 6.8px
    fontWeight: 700
  dialPhucDuc:
    fontSize: 5.5px
    fontWeight: 700
  dialBatTrach:
    fontSize: 9.5px
    fontWeight: 800
  dialSon24:
    fontSize: 7.5px
    fontWeight: 700
  dialHuongDiaLy:
    fontSize: 7.0px
    fontWeight: 700
  dialCungMang:
    fontSize: 9.0px
    fontWeight: 800
---

# Thiết Kế Chi Tiết La Bàn Phong Thuỷ Bát Trạch

## 1. Tổng Quan & Cảm Hứng Thiết Kế
Thiết kế dựa trên nguyên mẫu La Bàn Bát Trạch truyền thống (như mẫu 1997 Đinh Sửu), tái hiện đầy đủ các tầng tri thức phong thuỷ cổ truyền nhưng tinh chỉnh tương phản và tỉ lệ để hiển thị sắc nét, gọn gàng trên thiết bị di động:
- **Kích thước La Bàn:** Tối ưu hiển thị chiếm trọn chiều ngang màn hình di động (`LayoutBuilder` linh hoạt hoặc đường kính 370px).
- **Hệ Thống Màu Sắc:**
  - 4 Cung Cát (*Sinh Khí, Thiên Y, Diên Niên, Phục Vị*): Nền vàng kem ấm sang trọng `#FFF3B0`, chữ đỏ trầm `#B30000` tạo độ tương phản cao, dễ đọc, không chói.
  - 4 Cung Hung (*Tuyệt Mạng, Ngũ Quỷ, Lục Sát, Họa Hại*): Nền xanh lục bảo sẫm `#1B4332`, chữ trắng tinh khiết `#FFFFFF` sắc nét.
  - Vành 24 Sơn Hướng: Nền trắng ngà thanh thoát, chữ xám đen `#1A1A1A`, 4 sơn chủ (*Tý, Ngọ, Mão, Dậu*) nhấn nền đỏ rực `#E50914` chữ trắng.
  - Vành 8 Hướng Địa Lý: Nền ngọc bích nhạt `#E8F5E9`, chữ xanh thẫm `#1B5E20`.
  - Vành Cung Mạng: Chữ xanh biển đậm cổ truyền `#0D47A1`, cung bản mệnh của gia chủ được bao bọc nền đỏ rực.
  - Vành Quẻ Hào: Đỏ son `#D32F2F` truyền thống, vạch hào mảnh sắc sảo.
  - Tâm Thái Cực: Âm Dương song hành Vàng Kim `#FFD700` & Xanh Lục Bản Mệnh `#1B5E20`.

## 2. Tinh Chỉnh Cỡ Chữ & Bố Cục
- Giảm cỡ chữ của toàn bộ các tầng la bàn từ 25% - 40% so với bản trước để chữ nằm trọn hoàn hảo trong lòng các vành cung, không bị đè vạch hay tràn viền.
- Tăng diện tích hiển thị của mặt la bàn, điều chỉnh lại độ dày các vành khuyên để tạo khoảng thở (padding) tối ưu cho từng chữ.
- Giảm độ cao phần hiển thị số độ ở đỉnh màn hình từ `54px` xuống `40px`, giảm khoảng cách đệm (padding) để la bàn có không gian mở rộng tối đa trên màn hình điện thoại.
