// frontend/pages/test.tsx
export default function Test({ time }: { time: string }) {
    return <div>現在時刻: {time}</div>;
  }
  
  export async function getServerSideProps() {
    console.log("★★ getServerSideProps 実行されたよ！");
    return {
      props: {
        time: new Date().toISOString(),
      },
    };
  }
  