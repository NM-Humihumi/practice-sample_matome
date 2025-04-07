import { NextSeo } from "next-seo";
import Layout from "@/components/layout/Layout";
import ArticleCard from "@/components/articles/ArticleCard";
import { GetServerSideProps } from "next";

interface Article {
  id: string;
  title: string;
  slug: string;
  content: string;
  published_at: string;
  category?: string;
  article_metadata?: {
    excerpt: string;
    tags: string;
  };
}

interface HomeProps {
  articles: {
    id: string;
    title: string;
    excerpt: string;
    slug: string;
    publishedAt: string;
    category?: {
      name: string;
      slug: string;
    };
    tags?: Array<{
      name: string;
      slug: string;
    }>;
  }[];
}

export default function Home({ articles }: HomeProps) {
  
  return (
    <Layout>
      <NextSeo
        title="ホーム | まとめサイト"
        description="最新の記事をまとめています"
      />
      
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">最新記事</h1>

        {articles.length === 0 ? (
          <p className="text-gray-500">記事の取得に失敗しました。</p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {articles.map((article) => (
              <ArticleCard key={article.id} article={article} />
            ))}
          </div>
        )}
      </div>
    </Layout>
  );
}

export const getServerSideProps: GetServerSideProps = async () => {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL;
  const endpoint = `${apiUrl}/api/v1/articles`;

  try {
    const res = await fetch(endpoint, {
      headers: {
        Accept: "application/json",
      },
    });

    // ステータスコードが 200 以外でも try/catch を通すため明示チェック
    if (!res.ok) {
      console.error(`Fetch失敗: ${res.status} ${res.statusText}`);
      return { props: { articles: [] } };
    }

    let data: Article[] = [];

    try {
      data = await res.json();
    } catch (parseError) {
      console.error("JSONのパース失敗:", parseError);
      return { props: { articles: [] } };
    }

    const articles = data.map(article => ({
      id: article.id.toString(),
      title: article.title,
      excerpt: article.article_metadata?.excerpt || '',
      slug: article.slug,
      publishedAt: article.published_at,
      category: typeof article.category === 'string' ? {
        name: article.category,
        slug: article.category.toLowerCase().replace(/\s+/g, '-')
      } : undefined,
      tags: typeof article.article_metadata?.tags === 'string'
        ? article.article_metadata.tags.split(',').map(tag => ({
            name: tag.trim(),
            slug: tag.trim().toLowerCase().replace(/\s+/g, '-')
          }))
        : []
    }));

    return {
      props: {
        articles,
      },
    };
  } catch (error) {
    console.error("記事データの取得失敗:", error);
    return {
      props: {
        articles: [],
      },
    };
  }
};
