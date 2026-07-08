# Examples Mock API

Local Dart mock server for the `examples/full` app. Replaces DummyJSON and icanhazdadjoke with a self-contained backend.

## Start the server

From the repo root:

```bash
melos run backend
```

Or from this directory:

```bash
dart run bin/server.dart
```

The server listens on `http://127.0.0.1:8080` by default. Set `PORT` to override.

## Endpoints

All routes accept an optional `delay` query parameter (milliseconds) to simulate slow networks.

| Method | Path | Description |
|--------|------|-------------|
| GET | `/posts?limit=&skip=&delay=` | Paginated posts (DummyJSON shape) |
| GET | `/posts/{id}?delay=` | Single post |
| POST | `/posts?delay=` | Create post (`{title, body, userId}`) |
| GET | `/movies?limit=&skip=&delay=` | Paginated movies |
| GET | `/movies/random?delay=` | Random movie |
| GET | `/movies/{imdbId}?delay=` | Movie by imdb ID (e.g. `tt0111161`) |

## Running `examples/full`

1. Start this server.
2. Run the Flutter app from `examples/full`.

Default API URL: `http://localhost:8080`

### Android emulator

The emulator cannot reach `localhost` on your machine. Run the app with:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

### Testing slow responses

Append `delay` to any request, for example:

```bash
curl "http://localhost:8080/posts?limit=10&skip=0&delay=3000"
```

## Data

- `data/posts.json` — DummyJSON export (150 posts)
- `data/movies-250.json` — [toedter/movies-demo](https://github.com/toedter/movies-demo) movie dataset
