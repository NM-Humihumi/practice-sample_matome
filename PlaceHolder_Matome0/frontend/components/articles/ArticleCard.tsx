import Link from "next/link";
import { format } from "date-fns";
import { ja } from "date-fns/locale";

interface ArticleCardProps {
  article: {
    id: string;
    title: string;
    excerpt: string;
    slug: string;
    publishedAt: string | null;
    author?: string;
    category?: {
      name: string;
      slug: string;
    };
    tags?: Array<{
      name: string;
      slug: string;
    }>;
  };
}

export default function ArticleCard({ article }: ArticleCardProps) {
  const formattedDate =
    article.publishedAt && !isNaN(new Date(article.publishedAt).getTime())
      ? format(new Date(article.publishedAt), "yyyy年MM月dd日", { locale: ja })
      : "未公開";

  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
      <div className="p-6">
        {article.category && (
          <span className="inline-block mb-2 text-sm font-medium text-blue-600">
            {article.category.name}
          </span>
        )}

        <h2 className="text-xl font-bold mb-2">
          <Link href={`/articles/${article.slug}`} className="hover:text-gray-600">
            {article.title}
          </Link>
        </h2>

        {article.excerpt && (
          <p className="text-gray-600 mb-4">{article.excerpt}</p>
        )}

        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <time dateTime={article.publishedAt || undefined} className="text-sm text-gray-500">
              {formattedDate}
            </time>
            {article.author && (
              <span className="text-sm text-gray-500">by {article.author}</span>
            )}
          </div>

          {article.tags && article.tags.length > 0 && (
            <div className="flex space-x-2">
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
        </div>
      </div>
    </div>
  );
}
