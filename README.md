# LogScanner UI

React frontend for LogScanner - a powerful log file analysis tool.

![React](https://img.shields.io/badge/React-18-blue.svg)
![Vite](https://img.shields.io/badge/Vite-5-purple.svg)
![Ant Design](https://img.shields.io/badge/Ant%20Design-5-blue.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Overview

Modern, responsive web interface for LogScanner providing:

- file upload with progress tracking
- Real-time search and filtering
- Log level visualization and statistics
- Export functionality (CSV/JSON)

## Tech Stack

- **React 18** - UI framework
- **Vite 5** - Build tool
- **Ant Design 5** - UI components
- **Day.js** - Date handling

## Quick Start

### Prerequisites

- Node.js 18+ (or 20+)
- Yarn or npm

### Development Setup

```bash
# Clone the repository
git clone https://github.com/YOUR_ORG/logscanner-ui.git
cd logscanner-ui

# Install dependencies
yarn install

# Start development server
yarn dev

# Open http://localhost:3000
```

### Connect to Backend

The dev server proxies API requests to `http://localhost:8080`. Make sure the backend is running:

```bash
# In another terminal, start the backend
cd ../logscanner-processor
./mvnw spring-boot:run
```

## Project Structure

```
src/
├── components/              # React components
│   ├── Header.jsx          # App header with logo
│   ├── Header.css
│   ├── Footer.jsx          # App footer
│   ├── Footer.css
│   ├── JobProgressCard.jsx # Upload progress card
│   ├── JobProgressCard.css
│   ├── LogViewer.jsx       # Basic log viewer
│   ├── LogViewer.css
│   ├── LogViewerEnhanced.jsx  # Advanced log viewer
│   └── LogViewerEnhanced.css
├── services/
│   └── api.js              # API client
├── App.jsx                 # Main app component
├── App.css
├── main.jsx               # Entry point
└── index.css
```

## Features

### File Upload
- Progress tracking
- Format validation (.log, .txt, .json, .csv)
- Size limit: 500MB per file

### Search & Filter
- Full-text search
- Log level filter (ERROR, WARN, INFO, DEBUG, TRACE)
- Date range picker
- Source/filename filter
- Real-time results

### Log Viewer
- Syntax highlighting by log level
- Expandable log details
- Pagination
- Sort by timestamp or level

### Statistics
- Log level distribution chart
- Timeline visualization
- Error rate tracking

### Export
- Export to CSV
- Export to JSON
- Filtered export

## Available Scripts

```bash
# Start development server
yarn dev

# Build for production
yarn build

# Preview production build
yarn preview

# Run linter
yarn lint
```

## Configuration

### Vite Config (vite.config.js)

```javascript
export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/logs': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },
      '/actuator': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
```

### Environment Variables

Create `.env.local` for local development:

```env
VITE_API_URL=http://localhost:8080
```

For production, the nginx proxy handles API routing.

## API Integration

### api.js

```javascript
const API_BASE_URL = import.meta.env.VITE_API_URL || '';

export const uploadFile = async (file, onProgress) => {
  const formData = new FormData();
  formData.append('file', file);
  // ...
};

export const queryLogs = async (params) => {
  // ...
};

export const getJobStatus = async (jobId) => {
  // ...
};
```

## Building for Production

```bash
# Build
yarn build

# Output in dist/ folder
```

### Docker Build

```bash
# Build Docker image
docker build -t logscanner-ui .

# Run container
docker run -p 3000:80 logscanner-ui
```

### Dockerfile

Multi-stage build with nginx:

```dockerfile
# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

# Production stage
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Nginx Configuration

```nginx
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    client_max_body_size 500M;

    # API proxy
    location /logs/ {
        proxy_pass http://backend:8080/logs/;
        proxy_read_timeout 300s;
    }

    # SPA routing
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

## Component Documentation

### Header

```jsx
import Header from './components/Header';

<Header />
```

### JobProgressCard

```jsx
import JobProgressCard from './components/JobProgressCard';

<JobProgressCard
  job={{
    jobId: 'abc123',
    fileName: 'app.log',
    status: 'PROCESSING',
    progress: 45,
    totalLines: 10000,
    processedLines: 4500
  }}
  onDelete={(jobId) => handleDelete(jobId)}
/>
```

### LogViewerEnhanced

```jsx
import LogViewerEnhanced from './components/LogViewerEnhanced';

<LogViewerEnhanced
  jobs={jobs}
  onJobSelect={(jobId) => setSelectedJob(jobId)}
/>
```

## Styling

Using CSS modules and Ant Design theming:

```css
/* App.css */
.log-error { color: #ff4d4f; }
.log-warn { color: #faad14; }
.log-info { color: #1890ff; }
.log-debug { color: #52c41a; }
```

### Ant Design Theme

```jsx
import { ConfigProvider } from 'antd';

<ConfigProvider
  theme={{
    token: {
      colorPrimary: '#1890ff',
    },
  }}
>
  <App />
</ConfigProvider>
```

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Development

### Prerequisites

1. Install Node.js 18+
2. Install Yarn: `npm install -g yarn`

### IDE Setup

**VS Code Extensions:**
- ES7+ React/Redux/React-Native snippets
- ESLint
- Prettier

**Settings:**
```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

## Related Repositories

- [logscanner](https://github.com/YOUR_ORG/logscanner) - Docker Compose & documentation
- [logscanner-backend](https://github.com/YOUR_ORG/logscanner-backend) - Spring Boot API

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### Code Style

- Use functional components with hooks
- Follow ESLint rules
- Use meaningful component names
- Add PropTypes or TypeScript types

## License

Apache-2.0 License - see [LICENSE](LICENSE) for details.
