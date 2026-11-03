# OilMitra — Used Cooking Oil Pickup Network

OilMitra connects hotels, restaurants, marriage halls, cloud kitchens, households, and other businesses that have used cooking oil with the **OilMitra pickup team**.

Suppliers list oil. The OilMitra operator team claims loads, collects the oil, records the litres and rate, and shares a receipt. Payment is recorded, not processed online.

## Live apps

| App | URL on your deployment |
| --- | --- |
| Supplier app | `https://YOUR-SERVICE.onrender.com/app/` |
| Operator console | `https://YOUR-SERVICE.onrender.com/admin/` |
| API docs | `https://YOUR-SERVICE.onrender.com/docs` |

This repository contains both browser apps and the API, so one Render service is enough.

## What's inside

```
oilmitra/
├── backend/          FastAPI + SQLAlchemy API
│   ├── app/          application code
│   ├── tests/        end-to-end smoke test
│   ├── webapp/       prebuilt supplier app served at /app/
│   ├── admin_webapp/ prebuilt operator app served at /admin/
│   ├── .env.example  configuration template
│   └── run_server.bat
├── mobile/           Flutter source for both apps
│   ├── lib/main.dart        supplier app
│   ├── lib/main_admin.dart  operator app
│   └── run_web.bat
├── deploy/           online guide and build scripts
└── render.yaml       Render blueprint
```

## Roles

- **Supplier** — registers in the supplier app, lists used oil, manages their own loads, and sees their own impact and earnings.
- **Operator** — signs in at `/admin/`, claims and collects loads, manages every listing, and sees network-wide impact and money.

Supplier accounts cannot claim or collect oil. Operator access is provisioned through the `ADMIN_USERNAMES` environment variable.

## Quick start on this PC

### 1. Backend

```powershell
cd backend
.\run_server.bat
```

The script creates `.venv` and `.env` on first run, then starts the API on port **8000**.

### 2. Open the apps

- Supplier: <http://localhost:8000/app/>
- Operator: <http://localhost:8000/admin/>
- API docs: <http://localhost:8000/docs/>

The prebuilt browser apps in `backend/webapp/` and `backend/admin_webapp/` work immediately. No Flutter install is needed to run the server.

### 3. Rebuild after changing Flutter screens

Install Flutter, then:

```powershell
cd mobile
.\run_web.bat
```

For the operator build:

```powershell
cd mobile
.\run_web_admin.bat
```

Both scripts copy their fresh build into the backend folder so the server serves the latest version.

## Deploy online (free: Neon + Render)

See **[deploy/ONLINE_GUIDE.md](deploy/ONLINE_GUIDE.md)** for the full walkthrough. Short version:

1. Create a free PostgreSQL database on [Neon](https://neon.tech).
2. Push this folder to a GitHub repository.
3. On [Render](https://render.com), create a **Blueprint** from the repository.
4. Paste the Neon connection string when Render asks for `DATABASE_URL`.
5. Set `ADMIN_USERNAMES` to your operator username(s).
6. Open `/app/` for suppliers and `/admin/` for the operator console.

## Configuration

The API reads `backend/.env` locally or environment variables on Render.

| Variable | Purpose |
| --- | --- |
| `DB_TYPE` | `sqlite`, `mysql`, or `postgres` |
| `DATABASE_URL` | PostgreSQL connection string (Neon) |
| `JWT_SECRET` | Long random string used to sign login tokens |
| `JWT_EXPIRE_DAYS` | Login lifetime in days (default 30) |
| `ADMIN_USERNAMES` | Comma-separated operator usernames |
| `DONATE_UPI_ID`, `DONATE_NAME`, `DONATE_URL` | Optional support pop-up; leave UPI empty to hide |
| `CO2_PER_LITER` | CO₂e avoided per litre (default 2.8) |
| `BIODIESEL_YIELD` | Biodiesel yield per litre (default 0.92) |

Never commit a real `.env`, database file, or Neon connection string.

## Tests

```powershell
cd backend
.\.venv\Scripts\python.exe tests\smoke_test.py http://127.0.0.1:8000
```

The smoke test is idempotent. It reuses the `demo` operator account and `supplier_smoke`, and checks role enforcement, claiming, collection, receipts, admin listing management, and both web app mounts.

Flutter checks:

```powershell
cd mobile
flutter analyze
flutter test
```

## API overview

- `POST /auth/register`, `POST /auth/login`, `GET/PUT /auth/me`
- `GET /listings`, `GET /listings/{id}`, `POST /listings`, `PUT/DELETE /listings/{id}`
- `POST /listings/{id}/claim`, `/release`, `/collect`, `/cancel`
- `GET /pickups`, `GET /pickups/{id}`, `POST /pickups/{id}/review`
- `GET /dashboard`, `/impact`, `/leaderboard`, `/rates`, `/app-config`
- `GET /public/receipts/{token}`, `GET /r/{token}`
- `GET /geo/search`, `GET /geo/reverse`
- `GET /` health check and `/docs` interactive API docs

## License

Add your preferred license before publishing publicly. No license file is included yet.
