"use strict";(self.webpackChunk=self.webpackChunk||[]).push([[27],{3905:(e,t,r)=>{r.d(t,{Zo:()=>d,kt:()=>g});var n=r(7294);function a(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function o(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function i(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?o(Object(r),!0).forEach((function(t){a(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):o(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function s(e,t){if(null==e)return{};var r,n,a=function(e,t){if(null==e)return{};var r,n,a={},o=Object.keys(e);for(n=0;n<o.length;n++)r=o[n],t.indexOf(r)>=0||(a[r]=e[r]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(n=0;n<o.length;n++)r=o[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(a[r]=e[r])}return a}var c=n.createContext({}),l=function(e){var t=n.useContext(c),r=t;return e&&(r="function"==typeof e?e(t):i(i({},t),e)),r},d=function(e){var t=l(e.components);return n.createElement(c.Provider,{value:t},e.children)},u={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},p=n.forwardRef((function(e,t){var r=e.components,a=e.mdxType,o=e.originalType,c=e.parentName,d=s(e,["components","mdxType","originalType","parentName"]),p=l(r),g=a,m=p["".concat(c,".").concat(g)]||p[g]||u[g]||o;return r?n.createElement(m,i(i({ref:t},d),{},{components:r})):n.createElement(m,i({ref:t},d))}));function g(e,t){var r=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=r.length,i=new Array(o);i[0]=p;var s={};for(var c in t)hasOwnProperty.call(t,c)&&(s[c]=t[c]);s.originalType=e,s.mdxType="string"==typeof e?e:a,i[1]=s;for(var l=2;l<o;l++)i[l]=r[l];return n.createElement.apply(null,i)}return n.createElement.apply(null,r)}p.displayName="MDXCreateElement"},9092:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>c,contentTitle:()=>i,default:()=>u,frontMatter:()=>o,metadata:()=>s,toc:()=>l});var n=r(7462),a=(r(7294),r(3905));const o={},i="Storage",s={unversionedId:"docs/storage",id:"docs/storage",title:"Storage",description:"The quickest way to persist queries is to use Cached Storage. But you can",source:"@site/docs/docs/10-storage.md",sourceDirName:"docs",slug:"/docs/storage",permalink:"/docs/storage",draft:!1,editUrl:"https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/docs/docs/10-storage.md",tags:[],version:"current",sidebarPosition:10,frontMatter:{},sidebar:"docs",previous:{title:"Flutter Additions",permalink:"/docs/flutter-additions"}},c={},l=[{value:"CachedStorage",id:"cachedstorage",level:2},{value:"Getting Started",id:"getting-started",level:3},{value:"Serialization",id:"serialization",level:3},{value:"Custom Storage",id:"custom-storage",level:2}],d={toc:l};function u(e){let{components:t,...r}=e;return(0,a.kt)("wrapper",(0,n.Z)({},d,r,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"storage"},"Storage"),(0,a.kt)("p",null,"The quickest way to persist queries is to use ",(0,a.kt)("a",{parentName:"p",href:"https://pub.dev/packages/cached_storage"},"Cached Storage"),". But you can\nalso easily implement your own.  "),(0,a.kt)("h2",{id:"cachedstorage"},"CachedStorage"),(0,a.kt)("p",null,"Cached Storage is built upon ",(0,a.kt)("a",{parentName:"p",href:"https://pub.dev/packages/sqflite"},"Sqflite")," as this allows simple asyncronus access to a\ndatabase. "),(0,a.kt)("h3",{id:"getting-started"},"Getting Started"),(0,a.kt)("p",null,"Initialized cached query with the storage interface. This must be initialized before any query is called."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},"\nvoid main() async {\n  CachedQuery.instance.configFlutter(\n    storage: await CachedStorage.ensureInitialized(),\n  );\n}\n\n")),(0,a.kt)("p",null,"Queries will then automatically be persisted."),(0,a.kt)("h3",{id:"serialization"},"Serialization"),(0,a.kt)("p",null,"Cached Storage uses ",(0,a.kt)("inlineCode",{parentName:"p"},"jsonEncode")," to convert the data of a query to json, which is then stored. If you are returning\ndart objects from the ",(0,a.kt)("inlineCode",{parentName:"p"},"queryFn")," you will need to serialized the json back into the dart object. To do this, pass a\n",(0,a.kt)("inlineCode",{parentName:"p"},"serilizer")," to the QueryConfig which will be used to turn the stored data back into a dart object."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},' Query<JokeModel>(\n  key: \'joke\',\n  config: QueryConfig(\n    // Use a serializer to transform the store json to an object.\n    serializer: (dynamic json) =>\n        JokeModel.fromJson(json as Map<String, dynamic>),\n  ),\n  queryFn: () async {\n    final req = client.get(\n      Uri.parse("https://icanhazdadjoke.com/"),\n      headers: {"Accept": "application/json"},\n    );\n    final res = await req;\n    return JokeModel.fromJson(\n        jsonDecode(res.body) as Map<String, dynamic>,\n    );\n  },\n);\n')),(0,a.kt)("h2",{id:"custom-storage"},"Custom Storage"),(0,a.kt)("p",null,"There is no need to depend on Cached Storage if you are implementing a custom solution. To get started using a custom\nstorage solution extend ",(0,a.kt)("inlineCode",{parentName:"p"},"StorageInterface")," from Cached Query, shown below. "),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},"/// An interface for any storage adapter.\n///\n/// Used by the [CachedStorage] plugin to save the current cache.\nabstract class StorageInterface {\n  /// Get stored data from the storage instance.\n  FutureOr<dynamic> get(String key);\n\n  /// Delete the cache at a given key.\n  void delete(String key);\n\n  /// Update or add data with a given key.\n  /// Item will be the data from a Query or Infinite Query\n  void put<T>(String key, {required T item});\n\n  /// Delete all stored data.\n  void deleteAll();\n\n  /// Close and clean up the storage instance.\n  void close();\n}\n")),(0,a.kt)("p",null,"For a further example of implementing the storage interface look at the source code for Cached Storage:\n",(0,a.kt)("a",{parentName:"p",href:"https://github.com/D-James-GH/cached_query/blob/main/packages/cached_storage/lib/cached_storage.dart"},"Source Code")))}u.isMDXComponent=!0}}]);