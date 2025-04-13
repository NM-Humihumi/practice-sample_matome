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
    discussion_messages?: {
      content: string;
      position: number;
      speaker?: {
        display_name: string;
      };
    }[];
  };
}

export default function ArticleCard({ article }: ArticleCardProps) {
  const formattedDate =
    article.publishedAt && !isNaN(new Date(article.publishedAt).getTime())
      ? format(new Date(article.publishedAt), "yyyy年MM月dd日", { locale: ja })
      : "未公開";

  const comments = article.discussion_messages
    ? article.discussion_messages
        .sort((a, b) => {
          const aPos = a.position ?? 0;
          const bPos = b.position ?? 0;
          return aPos - bPos;
        })
        .slice(0, 2)
    : [];

  return (
    <div className="border rounded-xl p-4 mb-4 bg-white shadow-md">
      <div className="flex flex-col md:flex-row">
        {/* 本文（左側） */}
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

        {/* コメント（右側・固定幅、上位置調整） */}
        <div className="w-full md:w-[500px] shrink-0 space-y-2 mt-4 md:mt-0 self-start md:mt-[28px]">
          {comments.map((msg, idx) => {
            const isLeft = idx % 2 === 0;
            const speaker = msg.speaker || { display_name: "AI" };

            return (
              <div key={idx} className="flex items-start space-x-2">
                {/* 左アイコン */}
                {isLeft && (
                  <div className="flex flex-col items-center w-12 shrink-0">
                    <div className="w-10 h-10 rounded-full border-2 border-blue-500"></div>
                    <div className="text-[10px] text-blue-600 mt-1 leading-none">
                      {speaker.display_name}
                    </div>
                  </div>
                )}

                {/* ダミー空白 for 揃え */}
                {!isLeft && <div className="w-12 shrink-0" />}

                {/* 吹き出し */}
                <div
                  className={`border px-4 py-2 rounded-xl text-sm leading-snug max-w-[80%] line-clamp-2 ${
                    isLeft
                      ? "border-blue-400 text-blue-800"
                      : "border-red-400 text-red-700"
                  }`}
                >
                  {msg.content}
                </div>

                {/* 右アイコン */}
                {!isLeft && (
                  <div className="flex flex-col items-center w-12 shrink-0">
                    <div className="w-10 h-10 rounded-full border-2 border-red-500"></div>
                    <div className="text-[10px] text-red-600 mt-1 leading-none">
                      {speaker.display_name}
                    </div>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
