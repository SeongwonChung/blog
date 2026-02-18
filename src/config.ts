export const SITE = {
  website: "https://seongwonchung.com/",
  author: "Seongwon Chung",
  profile: "https://seongwonchung.com/",
  desc: "SeongwonChung's dev blog — web, blockchain, and more.",
  title: "SeongwonChung's log",
  ogImage: "astropaper-og.jpg",
  lightAndDarkMode: true,
  postPerIndex: 4,
  postPerPage: 8,
  scheduledPostMargin: 15 * 60 * 1000, // 15 minutes
  showArchives: true,
  showBackButton: true,
  editPost: {
    enabled: false,
    text: "Edit page",
    url: "",
  },
  dynamicOgImage: true,
  dir: "ltr",
  lang: "ko",
  timezone: "Asia/Seoul",
} as const;
