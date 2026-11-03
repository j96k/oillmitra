# Put OilMitra online for free (Neon + Render)

```
 Phones / browsers ──https──▶ Render (free web service, Singapore)
                                └─ FastAPI + supplier app at /app/
                                           + operator app at /admin/
                                        │
                                        ▼
                                   Neon (free PostgreSQL)
                                   └─ users, loads, pickups, photos
```

| Free plan limit | What it means |
| --- | --- |
| Render sleeps after 15 min with no visitors | The next visitor waits 30–60 s while it wakes up |
| Neon: 0.5 GB storage | Thousands of loads and photos |
| Render: 750 free hours / month | Enough for one service running all month |

Your local SQLite setup keeps working separately.

---

## Step 1 — Create the online database (Neon)

1. Go to <https://neon.tech> → **Sign up** (Google or GitHub, no card).
2. Create a project: name `oilmitra`, region **AWS Asia Pacific (Singapore)**.
3. Click **Connect** and copy the connection string. It looks like:
   `postgresql://neondb_owner:xxxx@ep-xxxx.ap-southeast-1.aws.neon.tech/neondb?sslmode=require`
4. Keep it secret. You will paste it into Render.

Tables are created automatically on first start.

## Step 2 — Push this folder to GitHub

On <https://github.com> → **New repository** → name `oilmitra` → **Private** (or Public) → do not add a README → **Create repository**.

In **cmd** (replace `YOUR-NAME`):

```bat
cd /d F:\OilMitra\live\oilmitra
git init -b main
git add .
git commit -m "OilMitra live"
git remote add origin https://github.com/YOUR-NAME/oilmitra.git
git push -u origin main
```

Later updates:

```bat
cd /d F:\OilMitra
deploy\prepare_online.bat
deploy\make_live.bat
cd live\oilmitra
git add .
git commit -m "update"
git push
```

## Step 3 — Run it on Render

1. Go to <https://render.com> → **Get Started** → sign up **with GitHub**.
2. **New → Blueprint** → choose the `oilmitra` repository.
3. Render finds `render.yaml` and asks for:
   - **DATABASE_URL** → paste the Neon connection string.
   - **ADMIN_USERNAMES** → your operator username(s), comma-separated.
4. Click **Apply** and wait 3–5 minutes for the first build.
5. When it says **Live**, note the address, e.g. `https://oilmitra.onrender.com`.

## Step 4 — Test

- Health: `https://YOUR-SERVICE.onrender.com/`
- Supplier app: `https://YOUR-SERVICE.onrender.com/app/`
- Operator console: `https://YOUR-SERVICE.onrender.com/admin/`
- API docs: `https://YOUR-SERVICE.onrender.com/docs`

Create the operator account first:

1. Open `/admin/` and choose **Create operator**.
2. Use one of the usernames listed in `ADMIN_USERNAMES`.
3. Pick a strong password.
4. Sign in and claim a test load.

Then create a supplier account in `/app/`, list a load, and verify it appears in the operator radar.

## Step 5 — Branding and Android

The browser builds use the default Flutter metadata. Replace `mobile/web/index.html` and `mobile/web/manifest.json` before a public launch, then rebuild with `deploy\prepare_online.bat`.

For an Android APK:

```bat
cd /d F:\OilMitra\mobile
call ..\env.bat
flutter build apk --release --dart-define=API_URL=https://YOUR-SERVICE.onrender.com
```

Set `android:label="OilMitra"` and add the INTERNET permission in `android/app/src/main/AndroidManifest.xml` first.

## Updating later

1. Changed screens? Run `deploy\prepare_online.bat` (needs Flutter).
2. Run `deploy\make_live.bat` to refresh the clean `live` folders.
3. Commit and push. Render redeploys automatically in 2–4 minutes.

## Optional: separate operator deployment

This repository already serves the operator console at `/admin/`, so a second service is **not required**.

If you want a separate operator URL, use the `live\oilmitra-operator` folder and point it at the **same Neon database**. Set the same `ADMIN_USERNAMES` value. See that folder's `deploy\ONLINE_GUIDE.md`.

Do not create a second database unless you deliberately want separate data.

## Seeing your online data

- Neon website → your project → **Tables**, or
- Any PostgreSQL client (for example Beekeeper Studio) using the Neon connection string with SSL enabled.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Service wakes slowly | Free Render services sleep after 15 minutes; wait 30–60 s |
| `DATABASE_URL` error | Use the full Neon string including `?sslmode=require` |
| Operator login rejected | Add the username to `ADMIN_USERNAMES`, then redeploy/restart |
| Photos disappear after restart | Use `DB_TYPE=postgres` so photos are stored in the database |
| `/app/` or `/admin/` is 404 | Check that `backend/webapp/index.html` / `backend/admin_webapp/index.html` were pushed |
