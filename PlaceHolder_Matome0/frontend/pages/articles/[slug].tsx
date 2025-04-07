import { NextSeo } from "next-seo";
import Layout from "@/components/layout/Layout";
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

interface ArticlePageProps {
  article: {
    id: string;
    title: string;
    content: string;
    excerpt: string;
    publishedAt: string;
    category?: string;
    tags?: Array<{
      name: string;
      slug: string;
    }>;
  };
}

export default function ArticlePage({ article }: ArticlePageProps) {
  return (
    <Layout>
      <NextSeo
        title={`${article.title} | まとめサイト`}
        description={article.excerpt}
      />
      
      <div className="container mx-auto px-4 py-8">
        <article className="prose max-w-3xl mx-auto">
          <header className="mb-8">
            {article.category && (
              <span className="inline-block mb-2 text-sm font-medium text-blue-600">
                {article.category}
              </span>
            )}
            <h1 className="text-3xl font-bold mb-4">{article.title}</h1>
            <div className="flex items-center space-x-4 text-sm text-gray-500 mb-4">
              <time dateTime={article.publishedAt}>
                {new Date(article.publishedAt).toLocaleDateString('ja-JP')}
              </time>
            </div>
            {article.tags && article.tags.length > 0 && (
              <div className="flex flex-wrap gap-2 mb-6">
                {article.tags.map((tag) => (
                  <span
                    key={tag.slug}
                    className="text-xs px-2 py-1 bg-gray-100 rounded-full text-gray-600"
                  >
                    {tag.name}
                  </span>
                ))}
              </div>
            )}
          </header>
          
          <div 
            className="article-content"
            dangerouslySetInnerHTML={{ __html: article.content }}
          />
        </article>
      </div>
    </Layout>
  );
}

export const getServerSideProps: GetServerSideProps = async (context) => {
  const { slug } = context.params!;

  try {
    const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/articles/${slug}`);
    const data = await res.json();
    
    if (!data) {
      return {
        notFound: true
      };
    }

    const article = data;
    const formattedArticle = {
      id: article.id.toString(),
      title: article.title,
      content: article.content,
      excerpt: article.article_metadata?.excerpt || '',
      publishedAt: article.published_at,
      category: article.category,
      tags: article.article_metadata?.tags?.split(',').map(tag => ({
        name: tag.trim(),
        slug: tag.trim().toLowerCase().replace(/\s+/g, '-')
      }))
    };

    return {
      props: {
        article: formattedArticle
      }
    };
  } catch (error) {
    console.error('Failed to fetch article:', error);
    return {
      notFound: true
    };
  }
};
