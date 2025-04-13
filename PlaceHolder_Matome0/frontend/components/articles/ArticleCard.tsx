import { format } from "date-fns";
import { ja } from "date-fns/locale";

interface ArticleCardProps {
  article: {
    id: string;
    title: string;
    digest: string;
    slug: string;
    publishedAt: string | null;
    categories: Array<{
      name: string;
      slug: string;
    }>;
    metadata?: {
      thumbnail_url?: string | null;
    };
    discussion_messages?: Array<{
      content: string;
      position: number;
    }>;
  };
}

export default function ArticleCard({ article }: ArticleCardProps) {
  const formattedDate =
    article.publishedAt && !isNaN(new Date(article.publishedAt).getTime())
      ? format(new Date(article.publishedAt), "yyyy年MM月dd日", { locale: ja })
      : "未公開";

  const comments = article.discussion_messages
    ? article.discussion_messages
        .sort((a, b) => a.position - b.position)
        .slice(0, 2)
    : [];

  return (
    <div className="border rounded-xl p-4 mb-4 bg-white shadow-md">
      <div className="flex">
        {/* 左側：本文 */}
        <div className="flex-1 pr-4">
          <div className="flex justify-between items-start mb-1">
            <h2 className="text-lg font-bold">{article.title}</h2>
            {article.categories.length > 0 && (
              <span className="text-xs bg-red-200 text-red-700 px-2 py-0.5 rounded-full">
                {article.categories.map((cat) => cat.name).join(" / ")}
              </span>
            )}
          </div>

          {article.digest && (
            <pre className="text-sm text-gray-600 mb-2 whitespace-pre-wrap">
              {article.digest}
            </pre>
          )}

          <time className="text-xs text-gray-500">{formattedDate}</time>
        </div>

        {/* 右側：コメント風ボックス */}
        <div className="flex flex-col space-y-2 text-sm w-1/3">
          {comments.map((msg, idx) => (
            <div
              key={idx}
              className={`border rounded-md px-2 py-1 ${
                idx % 2 === 0
                  ? "border-blue-400 text-blue-800"
                  : "border-red-400 text-red-700"
              }`}
            >
              {msg.content.split("\n").map((line, i) => (
                <div key={i}>{line}</div>
              ))}
            </div>
          ))}

          {/* コメント下にマーカー（仮） */}
          <div className="text-right pr-2 text-xl text-red-500">○</div>
        </div>
      </div>
    </div>
  );
}
