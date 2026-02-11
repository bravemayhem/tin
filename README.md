# Tampon In? - PWA

Track your period product safely. A Progressive Web App you can install on any device.

## Features

- 7 product types with medically-informed recommended/maximum times
- Circular progress timer with color-coded warnings (green/yellow/orange/red)
- One-tap start/stop tracking
- Session history (last 5, persisted to localStorage)
- Installable as a PWA (Add to Home Screen on iOS/Android)
- Works offline via service worker

## Getting Started

### Prerequisites

- Node.js (18+)
- npm

### Install & Run

```bash
npm install
npm run dev
```

Open the URL shown in terminal (usually `http://localhost:5173`).

### Build for Production

```bash
npm run build
npm run preview
```

The `dist/` folder can be deployed to any static host (Vercel, Netlify, GitHub Pages).

### Install as PWA

- **iOS Safari**: Tap Share > Add to Home Screen
- **Android Chrome**: Tap the install banner or Menu > Add to Home Screen
- **Desktop Chrome**: Click the install icon in the address bar

## Product Timings

See [DURATION_GUIDE.md](DURATION_GUIDE.md) for the full reference table.

| Product           | Recommended | Maximum |
|-------------------|-------------|---------|
| Disposable Pad    | 3h 30m      | 8h      |
| Tampon            | 6h          | 8h      |
| Menstrual Cup     | 10h         | 12h     |
| Menstrual Disc    | 10h         | 12h     |
| Period Underwear  | 10h         | 12h     |
| Reusable Pad      | 5h          | 12h     |
| Menstrual Sponge  | 4h 30m      | 8h      |

## Tech Stack

- React 18
- Vite
- vite-plugin-pwa (Workbox service worker)
- No other runtime dependencies

## Branch Strategy

- `main` -- README + LICENSE
- `flutter` -- Flutter native app
- `pwa` -- This React PWA (you are here)
