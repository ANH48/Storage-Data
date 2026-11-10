# Photo Vault

Kho lưu ảnh gộp dung lượng của nhiều acc Google Drive. Ảnh được chia vào các acc theo kiểu round-robin.

Stack: Go, Echo, Uber Fx, Clean Architecture, Postgres (pgx, sqlc, golang-migrate), OpenAPI (oapi-codegen), templ + HTMX, Docker, Kubernetes.

## Tài liệu

| File | Nội dung |
|---|---|
| [`docs/PROGRESS.md`](docs/PROGRESS.md) | Tiến độ học, câu hỏi còn mở, các quyết định đã thay đổi |
| [`docs/database-schema.md`](docs/database-schema.md) | Sơ đồ bảng, khoá ngoại, ràng buộc và index |
| [`api/openapi.yaml`](api/openapi.yaml) | Contract của JSON API |

## Cần cài

| Công cụ | Dùng để | Kiểm tra |
|---|---|---|
| Go 1.27+ | Build và chạy server | `go version` |
| Docker Desktop | Chạy Postgres và Swagger UI | `docker version` |
| golang-migrate | Chạy migration (`brew install golang-migrate`) | `migrate -version` |
| Node.js | Lint spec bằng `npx` | `node --version` |

## Chạy ở local

### 1. Tạo file `.env`

```bash
cp .env.example .env
```

Sửa `.env`:

- Đổi `POSTGRES_PASSWORD`. Chỉ dùng chữ và số để không phải mã hoá ký tự trong `DATABASE_URL`.
- Đổi `POSTGRES_PORT` nếu cổng 5432 đã bị chiếm. Máy hiện tại dùng **5444**.
- Ghép `DATABASE_URL` từ các biến trên để không phải lặp password:

```
DATABASE_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable
```

Không bao giờ commit `.env`.

### 2. Bật Postgres

```bash
docker compose up -d
docker compose ps        # đợi tới khi thấy (healthy)
```

Vào `psql`:

```bash
docker compose exec postgres sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"'
```

### 3. Chạy migration

```bash
set -a; source .env; set +a
migrate -path db/migrations -database "$DATABASE_URL" up
```

| Việc | Lệnh |
|---|---|
| Xem version hiện tại | `migrate -path db/migrations -database "$DATABASE_URL" version` |
| Lùi một migration | `migrate -path db/migrations -database "$DATABASE_URL" down 1` |
| Lùi hết | `migrate -path db/migrations -database "$DATABASE_URL" down -all` |
| Tạo migration mới | `migrate create -ext sql -dir db/migrations -seq <ten_migration>` |

### 4. Xem API bằng Swagger UI

```bash
make swagger                  # mở http://localhost:8081
make swagger SWAGGER_PORT=9000
```

Hiện chỉ xem được tài liệu. **Try it out** sẽ lỗi cho tới khi có server ở Phase 6.

Lint spec:

```bash
npx @redocly/cli lint api/openapi.yaml
```

### 5. Chạy server

```bash
go run ./cmd/server
```

Hiện server chỉ in một dòng rồi thoát.

## Cấu trúc thư mục

```
cmd/server, cmd/reconciler   # entry point, mỗi thư mục build ra một binary
api/                         # openapi.yaml
db/migrations                # migration SQL
db/queries                   # query cho sqlc
internal/domain              # entity, luật nghiệp vụ, chỉ dùng thư viện chuẩn
internal/app/port            # interface app cần từ bên ngoài
internal/app/usecase         # luồng nghiệp vụ
internal/adapter/in/http     # handler JSON API, web HTMX, middleware
internal/adapter/out         # postgres, gdrive, telegram
internal/infra               # config, DB pool, crypto, Fx module
static/                      # htmx.js, pico.css
```

Import chỉ được hướng vào trong: `adapter → app → domain`.

## Ghi chú và bẫy

| Chỗ | Ghi chú |
|---|---|
| `ports` trong `docker-compose.yml` | Bên trái là cổng máy (lấy từ `.env`), bên phải luôn là `5432`. Đổi bên phải thì không kết nối được, nhưng healthcheck vẫn báo `healthy` |
| `docker compose down -v` | Xoá luôn volume, tức là **mất dữ liệu**. `down` thường thì giữ lại |
| `POSTGRES_PASSWORD` | Chỉ có tác dụng lần đầu tạo volume. Đổi sau đó thì DB vẫn giữ password cũ |
| Migration đã chạy ở môi trường khác | Không sửa, tạo migration mới |
| `photos.updated_at` | Không có trigger, mọi câu `UPDATE` trên `photos` phải tự đặt `updated_at = now()` |
| Phân trang ảnh | Dùng cursor `(created_at, id)`, không dùng offset |
| API và web | JSON API có prefix `/api/v1`. Callback Google là route web, không nằm trong spec |
