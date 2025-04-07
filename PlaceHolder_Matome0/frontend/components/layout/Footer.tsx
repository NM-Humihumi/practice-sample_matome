export default function Footer() {
  return (
    <footer className="bg-gray-800 text-white py-8">
      <div className="container mx-auto px-4">
        <div className="flex flex-col md:flex-row justify-between items-center">
          <div className="mb-4 md:mb-0">
            <p className="text-sm">
              &copy; {new Date().getFullYear()} まとめサイト All rights reserved.
            </p>
          </div>
          <div className="flex space-x-4">
            <a href="#" className="text-gray-300 hover:text-white">
              利用規約
            </a>
            <a href="#" className="text-gray-300 hover:text-white">
              プライバシーポリシー
            </a>
            <a href="#" className="text-gray-300 hover:text-white">
              お問い合わせ
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
