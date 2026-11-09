# Photo Vault: Tiến độ học

## Đang làm
- Bước: 2.2 Migration bằng golang-migrate
- Bắt đầu: 2026-11-06

## Đã xong
| Bước | Ngày xong | Học được gì (1–2 dòng) |
|---|---|---|
| 0.1 Công cụ | 2026-11-06 | Máy có Go 1.27.3, Docker 29.9.2 (Client và Server), Git 2.56.0. |
| 0.2 Repo và module | 2026-11-06 | Có `go.mod`, `.gitignore`, `cmd/server/main.go`. `go build ./...` và `go run ./cmd/server` chạy được. `main.go` do mentor viết theo yêu cầu. |
| 0.3 Cấu trúc thư mục | 2026-11-06 | Import chỉ hướng vào trong (adapter → app → domain). Interface đặt ở phía dùng. Compiler không chặn `domain` import `pgx`, nên phải tự giữ quy ước. Câu `pgx` do mentor giải thích. |
| 1.1 Viết `openapi.yaml` | 2026-11-06 | Spec có 9 endpoint, lint không có error. Spec do mentor viết theo yêu cầu. Nhựt trả lời được 422 khác 507. Cursor cần kèm `id` để thứ tự là duy nhất. |
| 1.2 Swagger UI qua Docker | 2026-11-06 | Xem spec bằng `make swagger` ở cổng 8081. Hiểu `-p`, `-v`, `-e`, `--rm` và khác biệt giữa code-first với contract-first. |
| 2.1 Postgres bằng Docker Compose | 2026-11-09 | Postgres 17 chạy ở `localhost:5444`, healthy, volume `storage-data_pgdata`. Bên trái của `ports` là cổng máy, bên phải là cổng container (luôn 5432). Healthcheck không phát hiện map cổng sai. |

## Câu hỏi còn mở
- 0.2: Vì sao module path nên đặt theo tên GitHub repo? (Nhựt chọn bỏ qua)
- 0.1: Chạy Postgres bằng Docker so với cài thẳng vào máy có lợi và bất lợi gì? (chưa trả lời)
- 2.1: Bind mount và named volume khác nhau thế nào? (chưa trả lời)

## Quyết định thay đổi
(Ưu tiên hơn references/decisions.md của skill)
| Ngày | Thay quyết định | Quyết định mới | Lý do |
|---|---|---|---|
| 2026-11-06 | Roadmap 1.1: có endpoint delete linked account | MVP không có delete, chỉ cho lưu. Bỏ `DELETE /linked-accounts/{id}` | Giữ MVP đơn giản, tránh xử lý ảnh còn nằm trên acc bị gỡ |
| 2026-11-06 | Roadmap 1.1: callback nằm trong spec | Callback Google là route web, không nằm trong `openapi.yaml` | Trình duyệt gọi, xác thực bằng `state`, trả về redirect |
| 2026-11-06 | `flows.md`: chỉ có connect dạng redirect | API dùng `POST /api/v1/linked-accounts/google/connect` trả `auth_url`, web giữ redirect 302 | Bearer token không đi theo điều hướng của trình duyệt |
| 2026-11-06 | Chưa có prefix cho API | JSON API dùng prefix `/api/v1` | Tránh trùng đường dẫn với route web trên cùng Echo server |
| 2026-11-06 | Bảng lỗi chỉ có 507 khi hết chỗ | User chưa liên kết acc nào mà upload thì trả 422, mọi acc đều đầy thì trả 507 | Nhựt chốt: chưa liên kết là việc user phải làm, khác với hết dung lượng |

## Ghi chú review
- Việc để sau: Phase 6 thêm `docs_handler` trong `internal/adapter/in/http/` để server tự phục vụ Swagger tại `/docs` (nhúng spec bằng `go:embed`). Tới lúc đó vẫn giữ `make swagger` cho tới khi handler chạy được.
- Việc để sau: bước 2.2 index gallery của `photos` nên thêm `id` ở cuối để khớp cursor `(created_at, id)`.
- Lỗi hay mắc, cần để ý:
