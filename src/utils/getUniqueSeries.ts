import type { CollectionEntry } from "astro:content";
import { slugifyStr } from "./slugify";
import postFilter from "./postFilter";

interface Series {
  series: string;
  seriesName: string;
}

const getUniqueSeries = (posts: CollectionEntry<"blog">[]) => {
  const series: Series[] = posts
    .filter(postFilter)
    .filter(post => post.data.series)
    .map(post => ({
      series: slugifyStr(post.data.series!),
      seriesName: post.data.series!,
    }))
    .filter(
      (value, index, self) =>
        self.findIndex(s => s.series === value.series) === index
    )
    .sort((a, b) => a.series.localeCompare(b.series));
  return series;
};

export default getUniqueSeries;
