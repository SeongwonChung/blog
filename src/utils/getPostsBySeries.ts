import type { CollectionEntry } from "astro:content";
import postFilter from "./postFilter";
import { slugifyStr } from "./slugify";

const getPostsBySeries = (
  posts: CollectionEntry<"blog">[],
  series: string
) =>
  posts
    .filter(postFilter)
    .filter(post => post.data.series && slugifyStr(post.data.series) === series)
    .sort(
      (a, b) =>
        new Date(a.data.pubDatetime).getTime() -
        new Date(b.data.pubDatetime).getTime()
    );

export default getPostsBySeries;
