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
  console.log('API URL:', `${process.env.NEXT_PUBLIC_API_URL}/api/v1/articles`);
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

export const getServerSideProps = async () => {
  console.log('API URL:', process.env.NEXT_PUBLIC_API_URL);
  const apiUrl = process.env.NEXT_PUBLIC_API_URL;
  console.log('getServerSideProps/Fetching API URL:', `${apiUrl}/api/v1/articles`);
  const res = await fetch(`${apiUrl}/api/v1/articles`,{
    headers: {
      Accept: "application/json"
    }
  });

  const text = await res.text();
  console.log("Article Response: ", text);

  try {
    const data = JSON.parse(text);
    return {
      props: {
        articles: data
      }
    };
  } catch (err) {
    console.error("JSONパース失敗:", err);
    return { props: { articles: [] } };
  }
};

// export const getServerSideProps: GetServerSideProps = async () => {
//   try {
//     console.log("TEST1");
//     const apiUrl = process.env.NEXT_PUBLIC_API_URL;
//     console.log('getServerSideProps/Fetching API URL:', `${apiUrl}/api/v1/articles`);
//     const res = await fetch(`${apiUrl}/api/v1/articles`,{
//       headers: {
//         Accept: "application/json"
//       }
//     });
//     const data: Article[] = await res.json();

//     console.log("TEST2");

//     const articles = data.map(article => ({
//       id: article.id.toString(),
//       title: article.title,
//       excerpt: article.article_metadata?.excerpt || '',
//       slug: article.slug,
//       publishedAt: article.published_at,
//       category: typeof article.category === 'string' ? {
//         name: article.category,
//         slug: article.category.toLowerCase().replace(/\s+/g, '-')
//       } : undefined,
//       tags: typeof article.article_metadata?.tags === 'string' ? 
//         article.article_metadata.tags.split(',').map(tag => ({
//           name: tag.trim(),
//           slug: tag.trim().toLowerCase().replace(/\s+/g, '-')
//         })) : []
//     }));

//     console.log(articles)

//     return {
//       props: {
//         articles
//       }
//     };
//   } catch (error) {
//     console.error('Failed to fetch articles:', error);
//     return {
//       props: {
//         articles: []
//       }
//     };
//   }
// };
