"use strict";(self.webpackChunk=self.webpackChunk||[]).push([[204],{3905:(e,t,n)=>{n.d(t,{Zo:()=>c,kt:()=>f});var a=n(7294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,a,r=function(e,t){if(null==e)return{};var n,a,r={},i=Object.keys(e);for(a=0;a<i.length;a++)n=i[a],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(a=0;a<i.length;a++)n=i[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var o=a.createContext({}),u=function(e){var t=a.useContext(o),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},c=function(e){var t=u(e.components);return a.createElement(o.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},d=a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,i=e.originalType,o=e.parentName,c=s(e,["components","mdxType","originalType","parentName"]),d=u(n),f=r,h=d["".concat(o,".").concat(f)]||d[f]||p[f]||i;return n?a.createElement(h,l(l({ref:t},c),{},{components:n})):a.createElement(h,l({ref:t},c))}));function f(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var i=n.length,l=new Array(i);l[0]=d;var s={};for(var o in t)hasOwnProperty.call(t,o)&&(s[o]=t[o]);s.originalType=e,s.mdxType="string"==typeof e?e:r,l[1]=s;for(var u=2;u<i;u++)l[u]=n[u];return a.createElement.apply(null,l)}return a.createElement.apply(null,n)}d.displayName="MDXCreateElement"},8821:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>o,contentTitle:()=>l,default:()=>p,frontMatter:()=>i,metadata:()=>s,toc:()=>u});var a=n(7462),r=(n(7294),n(3905));const i={},l="Infinite Query",s={unversionedId:"docs/guides/infinite-query",id:"docs/guides/infinite-query",title:"Infinite Query",description:"An infinite query is used to cache an infinite list, which is a common occurrence with mobile apps. The caching works",source:"@site/docs/docs/guides/07-infinite-query.md",sourceDirName:"docs/guides",slug:"/docs/guides/infinite-query",permalink:"/docs/guides/infinite-query",draft:!1,editUrl:"https://github.com/D-James-GH/cached_query/tree/main/docs/docs/docs/guides/07-infinite-query.md",tags:[],version:"current",sidebarPosition:7,frontMatter:{},sidebar:"docs",previous:{title:"Global Cache",permalink:"/docs/guides/global-cache"},next:{title:"Optimistic Updates",permalink:"/docs/guides/optimistic-updates"}},o={},u=[{value:"Query Arguments",id:"query-arguments",level:2},{value:"Get Next Page",id:"get-next-page",level:2},{value:"Invalidation and Re-fetching",id:"invalidation-and-re-fetching",level:2},{value:"Side Effects",id:"side-effects",level:2},{value:"Local Cache",id:"local-cache",level:2}],c={toc:u};function p(e){let{components:t,...n}=e;return(0,r.kt)("wrapper",(0,a.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"infinite-query"},"Infinite Query"),(0,r.kt)("p",null,"An infinite query is used to cache an infinite list, which is a common occurrence with mobile apps. The caching works\nin much the same way as a Query and actually extends the QueryBase."),(0,r.kt)("p",null,"Infinite query takes two generic arguments, the first being the data that will be returned from the queryFn and the\nsecond is the type of the argument that will be passed to the queryFn."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-dart"},"final postsQuery = InfiniteQuery<List<PostModel>, int>(\n  key: 'posts',\n  getNextArg: (state) {\n    if (state.lastPage?.isEmpty ?? false) return null;\n    return state.length + 1;\n  },\n  queryFn: (page) => fetchPosts(endpoint: \"/api/data?page=${page}\"),\n);\n")),(0,r.kt)("h2",{id:"query-arguments"},"Query Arguments"),(0,r.kt)("p",null,"The function getNextArg will always be called before the query function. Whatever is returned from ",(0,r.kt)("inlineCode",{parentName:"p"},"getNextArg")," will be\npassed to the ",(0,r.kt)("inlineCode",{parentName:"p"},"queryFn"),". "),(0,r.kt)("p",null,"If the return value of getNextArg is null the state on the infinite query will be set to\n",(0,r.kt)("inlineCode",{parentName:"p"},"hasReachedMax = true"),". This will block further page calls."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-dart"},"getNextArg: (state) {\n  // If the last page is null then no request has happened yet. \n  // If the last page is empty then the api has no more items.\n    if (state.lastPage?.isEmpty ?? false) return null;\n    return state.length + 1;\n},\n")),(0,r.kt)("p",null,"The data of an infinite query will always be a list of previously fetched pages. "),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-dart"},"data: [\n  page1, \n  page2,\n]\n")),(0,r.kt)("p",null,"If a page is also a list the structure will be. "),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-dart"},"data: [\n  [item, item2],\n  [item3, item4],\n]\n")),(0,r.kt)("p",null,"This makes it easier to track which page returned what."),(0,r.kt)("h2",{id:"get-next-page"},"Get Next Page"),(0,r.kt)("p",null,"To fetch the next page use ",(0,r.kt)("inlineCode",{parentName:"p"},"infiniteQuery.getNextPage()"),"."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-dart"},"final postsQuery = InfiniteQuery<List<PostModel>, int>(\n  key: 'posts',\n  getNextArg: (state) {\n    if (state.lastPage?.isEmpty ?? false) return null;\n    return state.length + 1;\n  },\n  queryFn: (page) => fetchPosts(endpoint: \"/api/data?page=${page}\"),\n);\n---\nfinal nextPage = await postsQuery.getNextPage();\n")),(0,r.kt)("p",null,"The ",(0,r.kt)("inlineCode",{parentName:"p"},"getNextPage")," function returns a future of the infinite query state after the next page has completed. It is not\nnecessary to use this though, as the state will also be emitted down the query stream."),(0,r.kt)("p",null,"Each request for ",(0,r.kt)("inlineCode",{parentName:"p"},"getNextPage")," will be de-duplicated, so only one request can be made at a time. This normally reduces\nthe need for a throttle in an infinite list."),(0,r.kt)("h2",{id:"invalidation-and-re-fetching"},"Invalidation and Re-fetching"),(0,r.kt)("p",null,"When an infinite query becomes stale it needs to be refreshed, just like a query. By default, to prevent unnecessary api\ncalls, the infinite query will fetch the first page only and check to see if it is different to the cached first page.\nIf they are equal then the infinite query will not re-fetch anything else."),(0,r.kt)("p",null,"If the first two pages are different from each other there are two options: "),(0,r.kt)("ol",null,(0,r.kt)("li",{parentName:"ol"},"If ",(0,r.kt)("inlineCode",{parentName:"li"},"revalidateAll")," (Default) is false then the cached data will be reset to the first page only. "),(0,r.kt)("li",{parentName:"ol"},"If ",(0,r.kt)("inlineCode",{parentName:"li"},"revalidateAll")," is true then each cached page will be re-fetched sequentially.")),(0,r.kt)("p",null,"You can always re-fetch every page regardless of the first page equality by setting ",(0,r.kt)("inlineCode",{parentName:"p"},"forceRevalidateAll = true"),"."),(0,r.kt)("p",null,"The first page will be compared to prevent re-fetching if list hasn't changed:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-dart"},"final postsQuery = InfiniteQuery<List<PostModel>, int>(\n  key: 'posts',\n  getNextArg: (state) {\n    if (state.lastPage?.isEmpty ?? false) return null;\n    return state.length + 1;\n  },\n  queryFn: (page) => fetchPosts(endpoint: \"/api/data?page=${page}\"),\n);\n")),(0,r.kt)("p",null,"When stale all pages will always be re-fetched:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-dart"},"final postsQuery = InfiniteQuery<List<PostModel>, int>(\n  key: 'posts',\n  forceRevalidateAll: true,\n  getNextArg: (state) {\n    if (state.lastPage?.isEmpty ?? false) return null;\n    return state.length + 1;\n  },\n  queryFn: (page) => fetchPosts(endpoint: \"/api/data?page=${page}\"),\n);\n")),(0,r.kt)("h2",{id:"side-effects"},"Side Effects"),(0,r.kt)("p",null,"There are two side effects that can be passed to an infinite query."),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("inlineCode",{parentName:"li"},"onSuccess")," - This is called after the query function succeeds but before the query state is updated."),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("inlineCode",{parentName:"li"},"onError")," - This is called if the query function fails but before the query state is updated.")),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-dart"},'final query = InfiniteQuery<String>(\n  key: "sideEffects",\n  onSuccess: (dynamic r) { \n    // do something with the response\n  },\n  onError: (dynamic e){\n    // do something with the error\n  },\n  queryFn: () async {\n    //...queryFn\n  },\n);\n')),(0,r.kt)("h2",{id:"local-cache"},"Local Cache"),(0,r.kt)("p",null,"Each infinite query can take a local cache as a prop."),(0,r.kt)("p",null,"For more information, see ",(0,r.kt)("a",{parentName:"p",href:"/docs/guides/query#local-cache"},"local cache"),"."))}p.isMDXComponent=!0}}]);