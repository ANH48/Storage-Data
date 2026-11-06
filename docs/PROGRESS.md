# Photo Vault: Tiến độ học

## Đang làm
- Bước: 1.1 Viết `openapi.yaml`
- Bắt đầu: 2026-11-06

## Đã xong
| Bước | Ngày xong | Học được gì (1–2 dòng) |
|---|---|---|
| 0.1 Công cụ | 2026-11-06 | Máy có Go 1.27.3, Docker 29.9.2 (Client và Server), Git 2.56.0. |
| 0.2 Repo và module | 2026-11-06 | Có `go.mod`, `.gitignore`, `cmd/server/main.go`. `go build ./...` và `go run ./cmd/server` chạy được. `main.go` do mentor viết theo yêu cầu. |
| 0.3 Cấu trúc thư mục | 2026-11-06 | Import chỉ hướng vào trong (adapter → app → domain). Interface đặt ở phía dùng. Compiler không chặn `domain` import `pgx`, nên phải tự giữ quy ước. Câu `pgx` do mentor giải thích. |

## Câu hỏi còn mở
- 0.2: Vì sao module path nên đặt theo tên GitHub repo? (Nhựt chọn bỏ qua)
- 0.1: Chạy Postgres bằng Docker so với cài thẳng vào máy có lợi và bất lợi gì? (chưa trả lời, xem lại ở bước 2.1)

## Quyết định thay đổi
(Ưu tiên hơn references/decisions.md của skill)
| Ngày | Thay quyết định | Quyết định mới | Lý do |
|---|---|---|---|

## Ghi chú review
- Lỗi hay mắc, cần để ý:
