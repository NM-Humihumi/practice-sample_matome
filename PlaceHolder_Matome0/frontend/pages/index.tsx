import { NextSeo } from "next-seo";
import Layout from "@/components/layout/Layout";
import ArticleCard from "@/components/articles/ArticleCard";
import { GetServerSideProps } from "next";

interface Article {
  id: string;
  title: string;
  slug: string;
  published_at: string;
  article_metadata?: {
    excerpt: string;
    category: string;
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
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {articles.map((article) => (
            <ArticleCard key={article.id} article={article} />
          ))}
        </div>
      </div>
    </Layout>
  );
}

export const getServerSideProps: GetServerSideProps = async () => {
  try {
    const res = await fetch('http://backend:3000/api/v1/articles');
    const data: Article[] = await res.json();

    const articles = data.map(article => ({
      id: article.id.toString(),
      title: article.title,
      excerpt: article.article_metadata?.excerpt || '',
      slug: article.slug,
      publishedAt: article.published_at,
      category: article.article_metadata?.category ? {
        name: article.article_metadata.category,
        slug: article.article_metadata.category.toLowerCase().replace(/\s+/g, '-')
      } : undefined,
      tags: article.article_metadata?.tags?.split(',').map(tag => ({
        name: tag.trim(),
        slug: tag.trim().toLowerCase().replace(/\s+/g, '-')
      }))
    }));

    return {
      props: {
        articles
      }
    };
  } catch (error) {
    console.error('Failed to fetch articles:', error);
    return {
      props: {
        articles: []
      }
    };
  }
};
