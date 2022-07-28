"use strict";(self.webpackChunk=self.webpackChunk||[]).push([[908],{3905:(e,t,r)=>{r.d(t,{Zo:()=>u,kt:()=>f});var a=r(7294);function n(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function i(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,a)}return r}function o(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?i(Object(r),!0).forEach((function(t){n(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):i(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function l(e,t){if(null==e)return{};var r,a,n=function(e,t){if(null==e)return{};var r,a,n={},i=Object.keys(e);for(a=0;a<i.length;a++)r=i[a],t.indexOf(r)>=0||(n[r]=e[r]);return n}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(a=0;a<i.length;a++)r=i[a],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(n[r]=e[r])}return n}var c=a.createContext({}),s=function(e){var t=a.useContext(c),r=t;return e&&(r="function"==typeof e?e(t):o(o({},t),e)),r},u=function(e){var t=s(e.components);return a.createElement(c.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},p=a.forwardRef((function(e,t){var r=e.components,n=e.mdxType,i=e.originalType,c=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),p=s(r),f=n,h=p["".concat(c,".").concat(f)]||p[f]||d[f]||i;return r?a.createElement(h,o(o({ref:t},u),{},{components:r})):a.createElement(h,o({ref:t},u))}));function f(e,t){var r=arguments,n=t&&t.mdxType;if("string"==typeof e||n){var i=r.length,o=new Array(i);o[0]=p;var l={};for(var c in t)hasOwnProperty.call(t,c)&&(l[c]=t[c]);l.originalType=e,l.mdxType="string"==typeof e?e:n,o[1]=l;for(var s=2;s<i;s++)o[s]=r[s];return a.createElement.apply(null,o)}return a.createElement.apply(null,r)}p.displayName="MDXCreateElement"},7028:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>c,contentTitle:()=>o,default:()=>d,frontMatter:()=>i,metadata:()=>l,toc:()=>s});var a=r(7462),n=(r(7294),r(3905));const i={},o="Overview",l={unversionedId:"docs/overview",id:"docs/overview",title:"Overview",description:"Cached query is a collection of dart and flutter libraries inspired by tools such as SWR, React Query and RTKQuery from",source:"@site/docs/docs/01-overview.md",sourceDirName:"docs",slug:"/docs/overview",permalink:"/docs/overview",draft:!1,editUrl:"https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/docs/docs/01-overview.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{},sidebar:"docs",next:{title:"Quick Start",permalink:"/docs/quick-start"}},c={},s=[{value:"Features",id:"features",level:2},{value:"A Brief Overview Of How It Works...",id:"a-brief-overview-of-how-it-works",level:2}],u={toc:s};function d(e){let{components:t,...r}=e;return(0,n.kt)("wrapper",(0,a.Z)({},u,r,{components:t,mdxType:"MDXLayout"}),(0,n.kt)("h1",{id:"overview"},"Overview"),(0,n.kt)("p",null,"Cached query is a collection of dart and flutter libraries inspired by tools such as SWR, React Query and RTKQuery from\nthe React world."),(0,n.kt)("p",null,"It helps reduce the pain and repetitiveness of caching and updating server data."),(0,n.kt)("p",null,"The Cached Query packages are:"),(0,n.kt)("ul",null,(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",{parentName:"li",href:"https://pub.dev/packages/cached_query"},"Cached Query")," - The core package with no flutter dependencies."),(0,n.kt)("li",{parentName:"ul"},"\ud83d\udcf1 ",(0,n.kt)("a",{parentName:"li",href:"https://pub.dev/packages/cached_query_flutter"},"Cached Query Flutter")," - Useful flutter additions, including\nconnectivity status."),(0,n.kt)("li",{parentName:"ul"},"\ud83d\udcbd ",(0,n.kt)("a",{parentName:"li",href:"https://pub.dev/packages/cached_storage"},"Cached Storage")," - an implementation of the CachedQuery StorageInterface\nusing ",(0,n.kt)("a",{parentName:"li",href:"https://pub.dev/packages/sqflite"},"sqflite"),".")),(0,n.kt)("h2",{id:"features"},"Features"),(0,n.kt)("ul",null,(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",{parentName:"li",href:"/docs/guides/query"},"Cached responses")),(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",{parentName:"li",href:"/docs/guides/infinite-query"}," Infinite list caching ")),(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",{parentName:"li",href:"/docs/flutter-additions"},"Background fetching")),(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",{parentName:"li",href:"/docs/guides/mutations"},"Mutations")),(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",{parentName:"li",href:"/docs/storage"},"Persistent cache")," (flutter ios/android only, or easily create your own)"),(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",{parentName:"li",href:"/examples/with-flutter-bloc"},"Can be used alongside state management options")," (Bloc, Provider, etc...)"),(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",{parentName:"li",href:"/docs/flutter-additions"},"Re-fetch when connection is resumed")," (flutter only)"),(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",{parentName:"li",href:"/docs/flutter-additions"},"Re-fetch when app comes into the foreground "),"(flutter only)")),(0,n.kt)("h2",{id:"a-brief-overview-of-how-it-works"},"A Brief Overview Of How It Works..."),(0,n.kt)("p",null,"All queries are stored in a global cache so that they are available anywhere in the project. When a query is\ninstantiated it will check the global cache for the specified key and either return a pre-existing query or\ncreate a new one."),(0,n.kt)("p",null,"When the result of a query is requested it will always emit the currently stored value. If the data stored inside a\nquery is stale it will be re-fetched in the background."),(0,n.kt)("p",null,"This package uses darts built in streams to track the number of listeners attached to each query. Once a query has no\nmore listeners it will be removed from memory after a specific\n",(0,n.kt)("a",{parentName:"p",href:"/docs/guides/configuration#cache-duration"},"cache duration"),"."))}d.isMDXComponent=!0}}]);