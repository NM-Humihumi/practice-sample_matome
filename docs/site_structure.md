# まとめサイト プロジェクト構造

## 全体構成
```
PlaceHolder_Matome0/
├── docker-compose.yml
├── Dockerfile
└── frontend/
    ├── components/
    │   ├── articles/
    │   │   └── ArticleCard.tsx
    │   └── layout/
    │       ├── Footer.tsx
    │       ├── Header.tsx
    │       └── Layout.tsx
    ├── pages/
    │   ├── _app.tsx
    │   └── index.tsx
    ├── styles/
    │   └── globals.css
    ├── next-env.d.ts
    ├── next.config.js
    ├── package.json
    ├── package-lock.json
    ├── postcss.config.js
    ├── tailwind.config.js
    └── tsconfig.json
```

## 主要ファイル説明

### フロントエンド設定ファイル
- `next.config.js`: Next.js設定ファイル
- `tailwind.config.js`: Tailwind CSS設定
- `postcss.config.js`: PostCSS設定
- `tsconfig.json`: TypeScript設定 (baseUrlとpaths設定あり)

### コンポーネント構成
- `Layout.tsx`: 全体レイアウトコンポーネント
- `Header.tsx`: ヘッダーコンポーネント
- `Footer.tsx`: フッターコンポーネント
- `ArticleCard.tsx`: 記事カード表示コンポーネント

### ページ構成
- `_app.tsx`: アプリケーションエントリポイント
- `index.tsx`: メインページ

## 技術スタック
- Next.js (Reactフレームワーク)
- TypeScript
- Tailwind CSS
- PostCSS
- Dockerコンテナ環境

## 開発環境
- 開発サーバー: `docker-compose up`で起動
- ビルド: Next.js標準ビルドシステム
