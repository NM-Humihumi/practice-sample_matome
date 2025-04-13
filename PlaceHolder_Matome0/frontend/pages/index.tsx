import { NextSeo } from "next-seo";
import Layout from "@/components/layout/Layout";
import ArticleCard from "@/components/articles/ArticleCard";

interface Article {
  id: string;
  title: string;
  digest: string;
  slug: string;
  publishedAt: string | null;
  categories: Array<{ name: string; slug: string }>;
  metadata?: { thumbnail_url?: string | null };
  discussion_messages?: Array<{ content: string; position: number }>;
}

export default function Home({ articles }: { articles: Article[] }) {
  console.log("取得した記事一覧:", articles);
  return (
    <Layout>
      <NextSeo title="記事一覧" />
      <div className="max-w-3xl mx-auto py-8">
        {articles.map((article) => (
          <ArticleCard key={article.id} article={article} />
        ))}
      </div>
    </Layout>
  );
}

export async function getServerSideProps() {
  try {
    const apiUrl = process.env.NEXT_PUBLIC_API_URL;
    const endpoint = `${apiUrl}/api/v1/articles`;

    const res = await fetch(endpoint, {
      headers: {
        Accept: "application/json",
      },
    });

    if (!res.ok) {
      throw new Error("記事取得に失敗しました");
    }

    const data = await res.json();

    const articles: Article[] = data.map((item: any) => ({
      id: item.id,
      title: item.title,
      digest: item.digest || "",
      slug: item.slug,
      publishedAt: item.published_at,
      categories: item.categories || [],
      metadata: item.metadata || {},
      discussion_messages: item.discussion?.discussion_messages || [],
    }));

    return { props: { articles } };
  } catch (error) {
    console.error("記事取得エラー:", error);
    return { props: { articles: [] } };
  }
}
