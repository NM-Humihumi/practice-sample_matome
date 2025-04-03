## **開発ロードマップ**

### **フェーズ1: 基本機能実装**
1. プロジェクト初期化とライブラリインストール
2. Railsバックエンドとの連携設定
3. 共通レイアウト・コンポーネント実装
4. 基本ページ（トップ、記事、カテゴリ）実装
5. データ取得・表示ロジック実装

### **フェーズ2: 高度な機能とSEO対策**
1. SEO最適化（メタタグ、構造化データ）
2. サイトマップとRSSフィード実装
3. ページネーション実装
4. 関連記事・タグ機能拡充
5. 画像最適化と遅延読み込み

### **フェーズ3: パフォーマンスとUX改善**
1. Core Web Vitals最適化
2. アクセシビリティ改善
3. 検索機能実装
4. 読み込み状態とエラー処理の改善
5. アニメーションと遷移効果

### **フェーズ4: デプロイと運用**
1. Vercelデプロイ設定
2. 環境変数の管理
3. リダイレクト設定
4. アナリティクス導入
5. パフォーマンスモニタリング設定

---

## **結論**

このNext.jsまとめサイトの実装プランは、シンプルかつ高速なサイト構築を目指しています。Pages RouterとApp Routerどちらのアプローチでも実装可能な設計となっており、SEO対策やパフォーマンス最適化も考慮しています。

コードは全てTypeScriptで記述することを推奨します。Railsとの連携はAPI経由で行い、ISR（Incremental Static Regeneration）を活用して高速なページ表示と最新データの反映を両立します。

Tailwind CSSによるスタイリングは保守性が高く、コンポーネントの再利用性を高めます。必要に応じてUI/UXデザインをカスタマイズし、ブランドイメージに合わせることができます。

## **補足: App Routerへの移行について**

Next.js 13以降はApp Routerが推奨されていますが、このプロンプトではPages Routerをベースに記述しています。App Routerへの移行を検討する場合は以下の点に注意してください：

1. `pages` ディレクトリから `app` ディレクトリへのファイル移行
2. `getStaticProps`/`getStaticPaths` から新しいデータ取得方法への変更
3. ルートレイアウトの実装
4. サーバーコンポーネントとクライアントコンポーネントの使い分け

## **基本ディレクトリ構造**
my-summary-site-project/
├── docs/                       # ドキュメント関連
│   ├── prompts/                # 制作に使用したプロンプト
│   │   ├── frontend.md         # フロントエンド開発用プロンプト
│   │   ├── backend.md          # バックエンド開発用プロンプト
│   │   └── design.md           # デザイン関連プロンプト
│   ├── specifications/         # 仕様書等
│   └── notes/                  # プロジェクト関連メモ
│
├── website/                    # まとめサイト本体
│   ├── frontend/               # Next.jsプロジェクト
│   │   ├── components/
│   │   ├── pages/
│   │   ├── public/
│   │   └── ...
│   │
│   └── backend/                # Railsバックエンド
│       ├── app/
│       ├── config/
│       └── ...
│
├── scripts/                    # 便利なスクリプト類
│   ├── setup.sh                # セットアップスクリプト
│   └── deploy.sh               # デプロイスクリプト
│
├── .gitignore
└── README.md                   # プロジェクト概要

**9 データ取得ロジック実装例**
#### **`lib/api/articles.js`**
```tsx
// 記事データを取得する共通関数
// 実際のAPIエンドポイントに合わせて調整してください

// Rails APIのベースURL
const API_URL = process.env.API_URL || 'http://localhost:3001/api';

// API呼び出しのためのヘルパー関数
async function fetchAPI(endpoint, options = {}) {
  const res = await fetch(`${API_URL}${endpoint}`, {
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
    ...options,
  });

  if (!res.ok) {
    console.error(`API error: ${res.status} ${res.statusText}`);
    return null;
  }

  const json = await res.json();
  return json;
}

// 最新の記事を取得
export async function getLatestArticles(limit = 10) {
  const data = await fetchAPI(`/articles?limit=${limit}&sort=published_at:desc`);
  return data?.articles || [];
}

// 特定の記事を取得
export async function getArticle(id) {
  const data = await fetchAPI(`/articles/${id}`);
  return data?.article || null;
}

// 関連記事を取得
export async function getRelatedArticles(articleId, categoryId, limit = 3) {
  const data = await fetchAPI(
    `/articles/related?id=${articleId}&category=${categoryId}&limit=${limit}`
  );
  return data?.articles || [];
}

// すべての記事IDを取得
export async function getAllArticleIds() {
  const data = await fetchAPI('/articles/ids');
  return data?.ids || [];
}

// カテゴリ別の記事を取得
export async function getArticlesByCategory(categoryId, page = 1, perPage = 12) {
  const data = await fetchAPI(
    `/categories/${categoryId}/articles?page=${page}&per_page=${perPage}`
  );
  
  return {
    articles: data?.articles || [],
    pagination: data?.pagination || {
      currentPage: page,
      totalPages: 1,
      totalItems: data?.articles?.length || 0,
    }
  };
}

// 特定のカテゴリを取得
export async function getCategory(id) {
  const data = await fetchAPI(`/categories/${id}`);
  return data?.category || null;
}

// すべてのカテゴリIDを取得
export async function getAllCategoryIds() {
  const data = await fetchAPI('/categories/ids');
  return data?.ids || [];
}

// カテゴリの一覧を取得
export async function getCategories() {
  const data = await fetchAPI('/categories');
  return data?.categories || [];
}

// タグ別の記事を取得
export async function getArticlesByTag(tagId, page = 1, perPage = 10) {
  const data = await fetchAPI(
    `/tags/${tagId}/articles?page=${page}&per_page=${perPage}`
  );
  
  return {
    articles: data?.articles || [],
    pagination: data?.pagination || {
      currentPage: page,
      totalPages: 1,
      totalItems: data?.articles?.length || 0,
    }
  };
}

// 特定のタグを取得
export async function getTag(id) {
  const data = await fetchAPI(`/tags/${id}`);
  return data?.tag || null;
}

// すべてのタグIDを取得
export async function getAllTagIds() {
  const data = await fetchAPI('/tags/ids');
  return data?.ids || [];
}

// 人気のタグを取得
export async function getPopularTags(limit = 20) {
  const data = await fetchAPI(`/tags/popular?limit=${limit}`);
  return data?.tags || [];
}

// ページネーション付きカテゴリパスを取得（静的生成用）
export async function getAllCategoryPaths() {
  const categories = await getCategories();
  let paths = [];
  
  for (const category of categories) {
    const { pagination } = await getArticlesByCategory(category.slug, 1, 12);
    
    // 2ページ目以降のパスを生成
    for (let page = 2; page <= pagination.totalPages; page++) {
      paths.push({
        params: { id: category.slug, page: page.toString() }
      });
    }
  }
  
  return paths;
}
```
### **8 コンポーネント実装例**
#### **`components/layout/Layout.js`**
```tsx
import Head from 'next/head';
import Header from './Header';
import Footer from './Footer';
import { DefaultSeo } from 'next-seo';

export default function Layout({ children }) {
  return (
    <>
      <DefaultSeo
        defaultTitle="まとめサイト"
        titleTemplate="%s | まとめサイト"
        description="最新の記事をまとめています"
        openGraph={{
          type: 'website',
          locale: 'ja_JP',
          url: process.env.NEXT_PUBLIC_SITE_URL,
          siteName: 'まとめサイト',
        }}
        twitter={{
          handle: '@yourhandle',
          site: '@site',
          cardType: 'summary_large_image',
        }}
      />
      <div className="flex flex-col min-h-screen">
        <Header />
        <main className="flex-grow">
          {children}
        </main>
        <Footer />
      </div>
    </>
  );
}
```

#### **`components/articles/ArticleCard.js`**
```tsx
import Link from 'next/link';
import Image from 'next/image';
import { format } from 'date-fns';
import { ja } from 'date-fns/locale';

export default function ArticleCard({ article, featured = false }) {
  const formattedDate = format(
    new Date(article.publishedAt),
    'yyyy年MM月dd日',
    { locale: ja }
  );

  return (
    <article className={`bg-white rounded-lg shadow-sm overflow-hidden border border-gray-100 transition hover:shadow-md ${featured ? 'lg:grid lg:grid-cols-5' : ''}`}>
      <Link 
        href={`/article/${article.id}`}
        className={`block ${featured ? 'lg:col-span-3' : ''}`}
      >
        <div className={`relative w-full ${featured ? 'h-56 lg:h-full' : 'h-48'}`}>
          {article.image ? (
            <Image
              src={article.image}
              alt={article.title}
              fill
              sizes={featured ? "(max-width: 768px) 100vw, 60vw" : "(max-width: 768px) 100vw, 33vw"}
              className="object-cover"
            />
          ) : (
            <div className="w-full h-full bg-gray-200 flex items-center justify-center">
              <span className="text-gray-400">No Image</span>
            </div>
          )}
          {article.category && (
            <span className="absolute top-3 left-3 px-2 py-1 text-xs bg-blue-600 text-white rounded">
              {article.category.name}
            </span>
          )}
        </div>
      </Link>
      
      <div className={`p-4 ${featured ? 'lg:col-span-2 lg:p-6' : ''}`}>
        <Link href={`/article/${article.id}`} className="block">
          <h2 className={`font-bold text-gray-900 mb-2 line-clamp-2 ${featured ? 'text-xl lg:text-2xl' : 'text-lg'}`}>
            {article.title}
          </h2>
        </Link>
        
        {article.excerpt && (
          <p className="text-gray-600 text-sm mb-3 line-clamp-2">
            {article.excerpt}
          </p>
        )}
        
        <div className="flex justify-between items-center text-sm text-gray-500">
          <time dateTime={article.publishedAt}>{formattedDate}</time>
          
          {article.tags && article.tags.length > 0 && (
            <div className="flex space-x-1">
              {article.tags.slice(0, featured ? 3 : 2).map(tag => (
                <Link 
                  key={tag.id} 
                  href={`/tag/${tag.slug}`}
                  className="text-blue-600 hover:text-blue-800 text-xs"
                >
                  #{tag.name}
                </Link>
              ))}
            </div>
          )}
        </div>
      </div>
    </article>
  );
}
```

#### **`components/common/Pagination.js`**
```tsx
import Link from 'next/link';

export default function Pagination({ currentPage, totalPages, basePath }) {
  // ページネーションに表示するページ数の範囲を決定
  const getPageRange = () => {
    const range = [];
    const rangeSize = 5; // 表示するページ数
    
    let start = Math.max(1, currentPage - Math.floor(rangeSize / 2));
    let end = Math.min(totalPages, start + rangeSize - 1);
    
    // 端に寄っている場合の調整
    if (end - start + 1 < rangeSize) {
      start = Math.max(1, end - rangeSize + 1);
    }
    
    for (let i = start; i <= end; i++) {
      range.push(i);
    }
    
    return range;
  };

  if (totalPages <= 1) return null;
  
  return (
    <nav className="flex justify-center" aria-label="ページネーション">
      <ul className="flex space-x-1">
        {/* 前のページへのリンク */}
        {currentPage > 1 && (
          <li>
            <Link
              href={currentPage === 2 ? basePath : `${basePath}/page/${currentPage - 1}`}
              className="flex items-center justify-center w-10 h-10 border border-gray-300 rounded-md hover:bg-gray-100"
              aria-label="前のページ"
            >
              &laquo;
            </Link>
          </li>
        )}
        
        {/* ページ番号 */}
        {getPageRange().map(page => (
          <li key={page}>
            <Link
              href={page === 1 ? basePath : `${basePath}/page/${page}`}
              className={`flex items-center justify-center w-10 h-10 border rounded-md ${
                page === currentPage
                  ? 'bg-blue-600 text-white border-blue-600'
                  : 'border-gray-300 hover:bg-gray-100'
              }`}
              aria-current={page === currentPage ? 'page' : undefined}
            >
              {page}
            </Link>
          </li>
        ))}
        
        {/* 次のページへのリンク */}
        {currentPage < totalPages && (
          <li>
            <Link
              href={`${basePath}/page/${currentPage + 1}`}
              className="flex items-center justify-center w-10 h-10 border border-gray-300 rounded-md hover:bg-gray-100"
              aria-label="次のページ"
            >
              &raquo;
            </Link>
          </li>
        )}
      </ul>
    </nav>
  );
}
```### **7 RSSフィード（`pages/feed.xml.js`）**
#### **`pages/feed.xml.js`**
```tsx
import { getLatestArticles } from "@/lib/api/articles";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://example.com';
const SITE_TITLE = process.env.NEXT_PUBLIC_SITE_TITLE || 'まとめサイト';
const SITE_DESCRIPTION = process.env.NEXT_PUBLIC_SITE_DESCRIPTION || '最新の記事をまとめています';

export async function getServerSideProps({ res }) {
  // 最新の記事を取得
  const articles = await getLatestArticles(20); // 最新20件
  
  // 現在の日時
  const now = new Date().toISOString();
  
  // RSSフィードのXML生成
  const feed = `<?xml version="1.0" encoding="UTF-8"?>
  <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
    <channel>
      <title>${SITE_TITLE}</title>
      <link>${SITE_URL}</link>
      <description>${SITE_DESCRIPTION}</description>
      <language>ja</language>
      <lastBuildDate>${now}</lastBuildDate>
      <atom:link href="${SITE_URL}/feed.xml" rel="self" type="application/rss+xml" />
      
      ${articles.map(article => {
        const pubDate = new Date(article.publishedAt).toUTCString();
        return `
          <item>
            <title><![CDATA[${article.title}]]></title>
            <link>${SITE_URL}/article/${article.id}</link>
            <guid>${SITE_URL}/article/${article.id}</guid>
            <pubDate>${pubDate}</pubDate>
            <description><![CDATA[${article.excerpt || ''}]]></description>
            ${article.category ? `<category>${article.category.name}</category>` : ''}
          </item>
        `;
      }).join("")}
    </channel>
  </rss>`;

  // ヘッダーを設定してレスポンスを返す
  res.setHeader("Content-Type", "application/rss+xml");
  res.setHeader("Cache-Control", "public, max-age=3600, stale-while-revalidate=86400");
  res.write(feed);
  res.end();
  
  return { props: {} };
}

export default function RSSFeed() {
  // Server Sideでレンダリングされるため、クライアント側での表示は不要
  return null;
}
```# **Next.js まとめサイト フロントエンド実装プロンプト**

## **目的**
個人管理のまとめサイトを、Next.js（App RouterまたはPages Router）を活用してシンプルかつ高速に構築する。  
Railsの管理画面からDBに直接アクセスし、記事データを取得・表示する。  

---

## **技術スタック**
- **Next.js 14**（SSG/ISRで記事取得・表示）
- **Tailwind CSS**（スタイリング）
- **next-sitemap**（サイトマップ生成）
- **next-seo**（SEO最適化）
- **RSSフィード対応**
- **MySQL/PostgreSQL**（Rails側で管理）
- **Vercelデプロイ（想定）**

---

## **フォルダ構成（Pages Router）**
```plaintext
my-summary-site/
 ├── pages/
 │   ├── api/          # API エンドポイント
 │   ├── category/     # カテゴリページ
 │   ├── tag/          # タグページ
 │   ├── article/      # 記事ページ
 │   ├── index.js      # トップページ
 │   ├── 404.js        # 404ページ
 │   ├── _app.js       # アプリケーションのラッパー
 │   ├── _document.js  # HTML ドキュメント設定
 │   ├── sitemap.xml.js # サイトマップ
 │   └── feed.xml.js   # RSSフィード
 ├── components/       # UIコンポーネント
 │   ├── layout/       # レイアウト関連コンポーネント
 │   ├── common/       # 共通UIコンポーネント
 │   └── articles/     # 記事関連コンポーネント
 ├── lib/              # データ取得ロジックと共通関数
 │   ├── api/          # API通信関連
 │   ├── hooks/        # カスタムフック
 │   └── utils/        # ユーティリティ関数
 ├── public/           # 静的ファイル
 │   └── images/       # 画像ファイル
 ├── styles/           # Tailwind関連とグローバルスタイル
 ├── next.config.js    # Next.jsの設定
 ├── tailwind.config.js # Tailwindの設定
 ├── postcss.config.js # PostCSSの設定
 └── package.json      # パッケージ管理
```

## **フォルダ構成（App Router - 代替案）**
```plaintext
my-summary-site/
 ├── app/              # App Router
 │   ├── api/          # API Routes
 │   ├── category/[id]/page.js # カテゴリページ
 │   ├── tag/[id]/page.js     # タグページ
 │   ├── article/[id]/page.js # 記事ページ
 │   ├── page.js      # トップページ
 │   ├── layout.js    # ルートレイアウト
 │   ├── not-found.js # 404ページ
 │   └── sitemap.js   # サイトマップ
 ├── components/      # UIコンポーネント
 ├── lib/             # データ取得ロジックと共通関数
 ├── public/          # 静的ファイル
 └── ... (他は同じ)
```

---

## **必要なページと機能**
### **1 トップページ（`/`）**
#### **`pages/index.js`**
```tsx
import { getLatestArticles, getCategories } from "@/lib/api/articles";
import Link from "next/link";
import { NextSeo } from "next-seo";
import ArticleCard from "@/components/articles/ArticleCard";
import CategoryList from "@/components/common/CategoryList";
import Layout from "@/components/layout/Layout";

export default function Home({ articles, categories, featuredArticle }) {
  return (
    <Layout>
      <NextSeo
        title="ホーム | まとめサイト"
        description="最新の記事をまとめています"
        openGraph={{
          title: "ホーム | まとめサイト",
          description: "最新の記事をまとめています",
        }}
      />
      
      <div className="container mx-auto px-4 py-8">
        {featuredArticle && (
          <div className="mb-8">
            <h2 className="text-2xl font-bold mb-4">注目記事</h2>
            <ArticleCard article={featuredArticle} featured={true} />
          </div>
        )}
        
        <div className="grid grid-cols-1 md:grid-cols-12 gap-8">
          <div className="md:col-span-8">
            <h2 className="text-2xl font-bold mb-4">最新記事</h2>
            <div className="grid gap-6">
              {articles.map((article) => (
                <ArticleCard key={article.id} article={article} />
              ))}
            </div>
          </div>
          
          <div className="md:col-span-4">
            <div className="sticky top-24">
              <h3 className="text-xl font-bold mb-4">カテゴリ</h3>
              <CategoryList categories={categories} />
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}

export async function getStaticProps() {
  const articles = await getLatestArticles(10); // 最新10件
  const categories = await getCategories();
  const featuredArticle = articles.find(article => article.featured) || null;
  
  return { 
    props: { 
      articles, 
      categories,
      featuredArticle 
    }, 
    revalidate: 60 // 1分ごとに再検証
  };
}
```

---

### **2 記事ページ（`/article/[id]`）**
#### **`pages/article/[id].js`**
```tsx
import { getArticle, getAllArticleIds, getRelatedArticles } from "@/lib/api/articles";
import { NextSeo } from "next-seo";
import { format } from "date-fns";
import { ja } from "date-fns/locale";
import Layout from "@/components/layout/Layout";
import ArticleContent from "@/components/articles/ArticleContent";
import RelatedArticles from "@/components/articles/RelatedArticles";
import Image from "next/image";
import Link from "next/link";

export default function ArticlePage({ article, relatedArticles }) {
  if (!article) return <h1>記事が見つかりません</h1>;

  const formattedDate = format(
    new Date(article.publishedAt),
    'yyyy年MM月dd日',
    { locale: ja }
  );

  return (
    <Layout>
      <NextSeo
        title={`${article.title} | まとめサイト`}
        description={article.excerpt || article.title}
        openGraph={{
          title: article.title,
          description: article.excerpt || article.title,
          images: article.image ? [{ url: article.image }] : [],
          type: 'article',
          article: {
            publishedTime: article.publishedAt,
            modifiedTime: article.updatedAt,
            tags: article.tags?.map(tag => tag.name) || [],
          },
        }}
      />
      
      <article className="container mx-auto px-4 py-8">
        <div className="max-w-3xl mx-auto">
          {article.image && (
            <div className="relative w-full h-64 md:h-96 mb-6 rounded-lg overflow-hidden">
              <Image
                src={article.image}
                alt={article.title}
                fill
                sizes="(max-width: 768px) 100vw, 768px"
                className="object-cover"
                priority
              />
            </div>
          )}
          
          <div className="mb-6">
            {article.category && (
              <Link 
                href={`/category/${article.category.slug}`}
                className="inline-block px-3 py-1 mb-4 text-sm bg-gray-100 text-gray-800 rounded-full hover:bg-gray-200 transition"
              >
                {article.category.name}
              </Link>
            )}
            
            <h1 className="text-3xl md:text-4xl font-bold mb-4">{article.title}</h1>
            
            <div className="flex items-center text-gray-600 mb-4">
              <time dateTime={article.publishedAt}>{formattedDate}</time>
              {article.updatedAt && article.updatedAt !== article.publishedAt && (
                <span className="ml-4 text-sm">
                  (更新: {format(new Date(article.updatedAt), 'yyyy年MM月dd日', { locale: ja })})
                </span>
              )}
            </div>
            
            {article.tags && article.tags.length > 0 && (
              <div className="flex flex-wrap gap-2 mb-6">
                {article.tags.map(tag => (
                  <Link 
                    key={tag.id} 
                    href={`/tag/${tag.slug}`}
                    className="text-sm text-blue-600 hover:text-blue-800"
                  >
                    #{tag.name}
                  </Link>
                ))}
              </div>
            )}
          </div>
          
          <ArticleContent content={article.content} />
          
          {relatedArticles.length > 0 && (
            <div className="mt-12 pt-8 border-t border-gray-200">
              <RelatedArticles articles={relatedArticles} />
            </div>
          )}
        </div>
      </article>
    </Layout>
  );
}

export async function getStaticPaths() {
  const ids = await getAllArticleIds();
  return { 
    paths: ids.map((id) => ({ params: { id: id.toString() } })), 
    fallback: "blocking" 
  };
}

export async function getStaticProps({ params }) {
  const article = await getArticle(params.id);
  
  if (!article) return { notFound: true };
  
  const relatedArticles = await getRelatedArticles(article.id, article.categoryId, 3);
  
  return { 
    props: { 
      article, 
      relatedArticles 
    }, 
    revalidate: 600 // 10分ごとに再検証
  };
}
```

---

### **3 カテゴリページ（`/category/[id]`）**
#### **`pages/category/[id].js`**
```tsx
import { getArticlesByCategory, getCategory, getAllCategoryIds } from "@/lib/api/articles";
import { NextSeo } from "next-seo";
import Layout from "@/components/layout/Layout";
import ArticleCard from "@/components/articles/ArticleCard";
import Pagination from "@/components/common/Pagination";

export default function CategoryPage({ category, articles, pagination }) {
  if (!category) return <h1>カテゴリが見つかりません</h1>;

  return (
    <Layout>
      <NextSeo
        title={`${category.name} の記事一覧 | まとめサイト`}
        description={`${category.name}に関する記事の一覧です。${category.description || ''}`}
        openGraph={{
          title: `${category.name} の記事一覧 | まとめサイト`,
          description: `${category.name}に関する記事の一覧です。${category.description || ''}`,
        }}
      />
      
      <div className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold mb-2">{category.name}</h1>
          {category.description && (
            <p className="text-gray-600">{category.description}</p>
          )}
        </div>
        
        {articles.length > 0 ? (
          <>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {articles.map((article) => (
                <ArticleCard key={article.id} article={article} />
              ))}
            </div>
            
            {pagination.totalPages > 1 && (
              <div className="mt-12">
                <Pagination
                  currentPage={pagination.currentPage}
                  totalPages={pagination.totalPages}
                  basePath={`/category/${category.slug}`}
                />
              </div>
            )}
          </>
        ) : (
          <p className="text-gray-600">このカテゴリの記事はまだありません。</p>
        )}
      </div>
    </Layout>
  );
}

export async function getStaticPaths() {
  const categoryIds = await getAllCategoryIds();
  return {
    paths: categoryIds.map((id) => ({ params: { id: id.toString() } })),
    fallback: 'blocking',
  };
}

export async function getStaticProps({ params }) {
  const page = 1; // デフォルトページ
  const perPage = 12; // 1ページあたりの記事数
  
  const category = await getCategory(params.id);
  
  if (!category) return { notFound: true };
  
  const { articles, pagination } = await getArticlesByCategory(
    params.id,
    page,
    perPage
  );
  
  return { 
    props: { 
      category,
      articles,
      pagination
    }, 
    revalidate: 600 // 10分ごとに再検証
  };
}
```

#### **`pages/category/[id]/page/[page].js`**
```tsx
import { getArticlesByCategory, getCategory, getAllCategoryPaths } from "@/lib/api/articles";
import { NextSeo } from "next-seo";
import Layout from "@/components/layout/Layout";
import ArticleCard from "@/components/articles/ArticleCard";
import Pagination from "@/components/common/Pagination";

export default function CategoryPageWithPagination({ category, articles, pagination }) {
  if (!category) return <h1>カテゴリが見つかりません</h1>;

  return (
    <Layout>
      <NextSeo
        title={`${category.name} の記事一覧 (${pagination.currentPage}ページ目) | まとめサイト`}
        description={`${category.name}に関する記事の${pagination.currentPage}ページ目です。`}
        canonical={`https://example.com/category/${category.slug}`}
        openGraph={{
          title: `${category.name} の記事一覧 (${pagination.currentPage}ページ目) | まとめサイト`,
          description: `${category.name}に関する記事の${pagination.currentPage}ページ目です。`,
        }}
      />
      
      {/* 内容は[id].jsと同様 */}
      <div className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold mb-2">{category.name}</h1>
          <p className="text-gray-600">{pagination.currentPage}ページ目</p>
        </div>
        
        {/* 記事一覧 */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {articles.map((article) => (
            <ArticleCard key={article.id} article={article} />
          ))}
        </div>
        
        {/* ページネーション */}
        {pagination.totalPages > 1 && (
          <div className="mt-12">
            <Pagination
              currentPage={pagination.currentPage}
              totalPages={pagination.totalPages}
              basePath={`/category/${category.slug}`}
            />
          </div>
        )}
      </div>
    </Layout>
  );
}

export async function getStaticPaths() {
  const paths = await getAllCategoryPaths();
  return {
    paths,
    fallback: 'blocking',
  };
}

export async function getStaticProps({ params }) {
  const page = parseInt(params.page, 10) || 1;
  const perPage = 12; // 1ページあたりの記事数
  
  const category = await getCategory(params.id);
  
  if (!category) return { notFound: true };
  
  const { articles, pagination } = await getArticlesByCategory(
    params.id,
    page,
    perPage
  );
  
  // ページが存在しない場合は404
  if (page > pagination.totalPages) {
    return { notFound: true };
  }
  
  return { 
    props: { 
      category,
      articles,
      pagination
    }, 
    revalidate: 600 // 10分ごとに再検証
  };
}
```

---

### **4 タグページ（`/tag/[id]`）**
#### **`pages/tag/[id].js`**
```tsx
import { getArticlesByTag, getTag, getPopularTags } from "@/lib/api/articles";
import { NextSeo } from "next-seo";
import Layout from "@/components/layout/Layout";
import ArticleCard from "@/components/articles/ArticleCard";
import Pagination from "@/components/common/Pagination";
import TagList from "@/components/common/TagList";

export default function TagPage({ tag, articles, pagination, popularTags }) {
  if (!tag) return <h1>タグが見つかりません</h1>;

  return (
    <Layout>
      <NextSeo
        title={`#${tag.name} の記事一覧 | まとめサイト`}
        description={`${tag.name}タグの記事一覧です。`}
        openGraph={{
          title: `#${tag.name} の記事一覧 | まとめサイト`,
          description: `${tag.name}タグの記事一覧です。`,
        }}
      />
      
      <div className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold mb-2">#{tag.name}</h1>
          <p className="text-gray-600">{articles.length}件の記事</p>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-12 gap-8">
          <div className="md:col-span-8">
            {articles.length > 0 ? (
              <>
                <div className="grid grid-cols-1 gap-6">
                  {articles.map((article) => (
                    <ArticleCard key={article.id} article={article} />
                  ))}
                </div>
                
                {pagination.totalPages > 1 && (
                  <div className="mt-12">
                    <Pagination
                      currentPage={pagination.currentPage}
                      totalPages={pagination.totalPages}
                      basePath={`/tag/${tag.slug}`}
                    />
                  </div>
                )}
              </>
            ) : (
              <p className="text-gray-600">このタグの記事はまだありません。</p>
            )}
          </div>
          
          <div className="md:col-span-4">
            <div className="sticky top-24">
              <h3 className="text-xl font-bold mb-4">人気のタグ</h3>
              <TagList tags={popularTags} />
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}

export async function getStaticPaths() {
  // 人気のタグのみ事前生成して、残りはオンデマンドで生成
  const popularTags = await getPopularTags(20);
  return {
    paths: popularTags.map((tag) => ({ params: { id: tag.slug } })),
    fallback: 'blocking',
  };
}

export async function getStaticProps({ params }) {
  const page = 1; // デフォルトページ
  const perPage = 10; // 1ページあたりの記事数
  
  const tag = await getTag(params.id);
  
  if (!tag) return { notFound: true };
  
  const { articles, pagination } = await getArticlesByTag(
    params.id,
    page,
    perPage
  );
  
  const popularTags = await getPopularTags(20);
  
  return { 
    props: { 
      tag,
      articles,
      pagination,
      popularTags
    }, 
    revalidate: 600 // 10分ごとに再検証
  };
}
```

#### **`pages/tag/[id]/page/[page].js`**
```tsx
// タグページのページネーション実装
// カテゴリページの[id]/page/[page].jsと同様の実装
```

---

### **5 404ページ（`pages/404.js`）**
```tsx
import Link from "next/link";
import { NextSeo } from "next-seo";
import Layout from "@/components/layout/Layout";

export default function Custom404() {
  return (
    <Layout>
      <NextSeo
        title="ページが見つかりません | まとめサイト"
        noindex={true}
      />
      
      <div className="container mx-auto px-4 py-16 flex flex-col items-center justify-center min-h-[60vh]">
        <h1 className="text-6xl font-bold text-gray-800 mb-4">404</h1>
        <p className="text-xl text-gray-600 mb-8">ページが見つかりませんでした</p>
        <p className="text-gray-500 mb-8 text-center max-w-md">
          お探しのページは削除されたか、URLが変更された可能性があります。
        </p>
        <Link 
          href="/"
          className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition duration-200"
        >
          トップページに戻る
        </Link>
      </div>
    </Layout>
  );
}
```

---

### **6 サイトマップ（`pages/sitemap.xml.js`）**
#### **`pages/sitemap.xml.js`**
```tsx
import { getAllArticleIds, getAllCategoryIds, getAllTagIds } from "@/lib/api/articles";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://example.com';

export async function getServerSideProps({ res }) {
  // 記事、カテゴリ、タグのIDを取得
  const articleIds = await getAllArticleIds();
  const categoryIds = await getAllCategoryIds();
  const tagIds = await getAllTagIds();
  
  // 現在の日時
  const now = new Date().toISOString();
  
  // サイトマップのXML生成
  const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
  <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <!-- トップページ -->
    <url>
      <loc>${SITE_URL}/</loc>
      <lastmod>${now}</lastmod>
      <changefreq>daily</changefreq>
      <priority>1.0</priority>
    </url>
    
    <!-- 記事ページ -->
    ${articleIds.map(id => `
      <url>
        <loc>${SITE_URL}/article/${id}</loc>
        <lastmod>${now}</lastmod>
        <changefreq>weekly</changefreq>
        <priority>0.8</priority>
      </url>
    `).join("")}
    
    <!-- カテゴリページ -->
    ${categoryIds.map(id => `
      <url>
        <loc>${SITE_URL}/category/${id}</loc>
        <lastmod>${now}</lastmod>
        <changefreq>weekly</changefreq>
        <priority>0.7</priority>
      </url>
    `).join("")}
    
    <!-- タグページ -->
    ${tagIds.map(id => `
      <url>
        <loc>${SITE_URL}/tag/${id}</loc>
        <lastmod>${now}</lastmod>
        <changefreq>weekly</changefreq>
        <priority>0.6</priority>
      </url>
    `).join("")}
  </urlset>`;

  // ヘッダーを設定してレスポンスを返す
  res.setHeader("Content-Type", "text/xml");
  res.setHeader("Cache-Control", "public, max-age=3600, stale-while-revalidate=86400");
  res.write(sitemap);
  res.end();
  
  return { props: {} };
}

export default function Sitemap() {
  // Server Sideでレンダリングされるため、クライアント側での表示は不要
  return null;
}
```

---

## **ライブラリと設定**
### **主要なパッケージ**
```bash
# 基本パッケージ
npm install next@latest react@latest react-dom@latest

# スタイリング
npm install tailwindcss postcss autoprefixer

# SEOとサイトマップ
npm install next-seo next-sitemap

# 日付フォーマット
npm install date-fns

# 画像の最適化とマークダウン
npm install sharp react-markdown
```

### **Tailwind CSS設定**
#### **`tailwind.config.js`**
```js
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
    "./app/**/*.{js,ts,jsx,tsx}", // App Routerを使う場合
  ],
  theme: {
    extend: {
      typography: {
        DEFAULT: {
          css: {
            a: {
              color: '#3182ce',
              '&:hover': {
                color: '#2c5282',
              },
            },
            img: {
              borderRadius: '0.375rem',
            },
          },
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'), // マークダウン表示用
    require('@tailwindcss/line-clamp'), // テキスト切り詰め表示用
  ],
};
```

#### **`styles/globals.css`**
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  body {
    @apply bg-gray-50 text-gray-900;
  }
  
  h1, h2, h3, h4, h5, h6 {
    @apply font-bold;
  }
}

@layer components {
  .container {
    @apply px-4 mx-auto max-w-7xl;
  }
  
  .btn {
    @apply px-4 py-2 rounded-md transition-colors;
  }
  
  .btn-primary {
    @apply bg-blue-600 text-white hover:bg-blue-700;
  }
}
```

### **Next.js設定**
#### **`next.config.js`**
```js
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
```

#### **`next-sitemap.config.js`**
```js
/** @type {import('next-sitemap').IConfig} */
module.exports = {
  siteUrl: process.env.NEXT_PUBLIC_SITE_URL || 'https://example.com',
  generateRobotsTxt: true,
  changefreq: 'daily',
  priority: 0.7,
  sitemapSize: 5000,
  exclude: ['/404'],
  robotsTxtOptions: {
    policies: [
      {
        userAgent: '*',
        allow: '/',
        disallow: ['/admin', '/private'],
      },
    ],
    additionalSitemaps: [
      `${process.env.NEXT_PUBLIC_SITE_URL || 'https://example.com'}/sitemap.xml`,
    ],
  },
};
```

---

## **実装チェックリスト**
### **基本機能**
- [ ] **レイアウト共通コンポーネント**
  - [ ] ヘッダー（ナビゲーション）
  - [ ] フッター
  - [ ] SEO設定
  - [ ] レスポンシブデザイン

- [ ] **トップページ（ISR）**
  - [ ] 最新記事一覧
  - [ ] カテゴリリスト
  - [ ] 注目記事（オプショナル）

- [ ] **記事ページ（ISR, 404対応）**
  - [ ] 記事本文表示
  - [ ] メタデータ表示（日付、カテゴリ、タグ）
  - [ ] 関連記事表示
  - [ ] SNSシェアボタン

- [ ] **カテゴリページ（ISR）**
  - [ ] カテゴリ別記事一覧
  - [ ] ページネーション

- [ ] **タグページ（ISR）**
  - [ ] タグ別記事一覧
  - [ ] ページネーション
  - [ ] 人気タグ一覧

- [ ] **404ページ**

### **SEO対策**
- [ ] **メタタグ最適化**
  - [ ] title, description
  - [ ] Open Graph (og:title, og:description, og:image)
  - [ ] Twitter Cards

- [ ] **構造化データ（JSON-LD）**
  - [ ] 記事ページ
  - [ ] パンくずリスト

- [ ] **サイトマップ**
  - [ ] XML生成
  - [ ] robots.txt

- [ ] **RSSフィード**

### **パフォーマンス最適化**
- [ ] **画像最適化**
  - [ ] next/image コンポーネント使用
  - [ ] WebP/AVIF形式対応
  - [ ] 適切なsizes属性設定

- [ ] **フォント最適化**
  - [ ] next/font 使用

- [ ] **Core Web Vitals対策**
  - [ ] LCP（最大コンテンツ描画）最適化
  - [ ] CLS（累積レイアウトシフト）防止
  - [ ] FID（初回入力遅延）最小化

### **アクセシビリティ**
- [ ] **セマンティックHTML**
- [ ] **キーボード操作対応**
- [ ] **適切なaria属性**
- [ ] **十分なコントラスト**

### **デプロイ**
- [ ] **Vercel設定**
  - [ ] 環境変数設定
  - [ ] カスタムドメイン設定
  - [ ] リダイレクト設定

- [ ] **APIキャッシュ戦略**
  - [ ] ISR revalidate 設定の最適化
  - [ ] SWR/React-Queryの検討

---
