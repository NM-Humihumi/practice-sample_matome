import { NextSeo } from "next-seo";
import Layout from "@/components/layout/Layout";
import { GetServerSideProps } from "next";

interface ArticleCategory {
  id: number;
  name: string;
  slug: string;
}

interface ArticlePageProps {
  article: {
    id: string;
    title: string;
    digest: string;
    publishedAt: string;
    category?: string;
  };
}

export default function ArticlePage({ article }: ArticlePageProps) {
  return (
    <Layout>
      <NextSeo
        title={`${article.title} | まとめサイト`}
        description={article.digest.slice(0, 60) + "..."}
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
                {new Date(article.publishedAt).toLocaleDateString("ja-JP")}
              </time>
            </div>
          </header>

          <div
            className="article-content whitespace-pre-wrap"
          >
            {article.digest}
          </div>
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
      return { notFound: true };
    }

    const firstCategory = data.article_categories?.[0]?.name || "";

    const formattedArticle = {
      id: data.id.toString(),
      title: data.title,
      digest: data.digest,
      publishedAt: data.published_at,
      category: firstCategory,
    };

    return {
      props: {
        article: formattedArticle
      }
    };
  } catch (error) {
    console.error("Failed to fetch article:", error);
    return {
      notFound: true
    };
  }
};
