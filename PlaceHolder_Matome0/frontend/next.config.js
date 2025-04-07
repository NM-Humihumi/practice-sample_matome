/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    domains: [
      'localhost', // ローカル開発用
      'example.com', // 本番ドメインに変更
      'images.example.com', // 画像CDNがある場合
    ],
    formats: ['image/avif', 'image/webp'],
  },
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
        ],
      },
    ];
  },
  async redirects() {
    return [
      // 必要に応じてリダイレクトルールを追加
      {
        source: '/old-article/:id',
        destination: '/article/:id',
        permanent: true,
      },
    ];
  },
};

module.exports = nextConfig;
