"use strict";(self.webpackChunk=self.webpackChunk||[]).push([[801],{3905:(e,t,n)=>{n.d(t,{Zo:()=>c,kt:()=>h});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function u(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},i=Object.keys(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var o=r.createContext({}),l=function(e){var t=r.useContext(o),n=t;return e&&(n="function"==typeof e?e(t):u(u({},t),e)),n},c=function(e){var t=l(e.components);return r.createElement(o.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},y=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,i=e.originalType,o=e.parentName,c=s(e,["components","mdxType","originalType","parentName"]),y=l(n),h=a,p=y["".concat(o,".").concat(h)]||y[h]||d[h]||i;return n?r.createElement(p,u(u({ref:t},c),{},{components:n})):r.createElement(p,u({ref:t},c))}));function h(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var i=n.length,u=new Array(i);u[0]=y;var s={};for(var o in t)hasOwnProperty.call(t,o)&&(s[o]=t[o]);s.originalType=e,s.mdxType="string"==typeof e?e:a,u[1]=s;for(var l=2;l<i;l++)u[l]=n[l];return r.createElement.apply(null,u)}return r.createElement.apply(null,n)}y.displayName="MDXCreateElement"},3701:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>o,contentTitle:()=>u,default:()=>d,frontMatter:()=>i,metadata:()=>s,toc:()=>l});var r=n(7462),a=(n(7294),n(3905));const i={title:"Query"},u="Automatic Caching with Query",s={unversionedId:"docs/guides/query",id:"docs/guides/query",title:"Query",description:"A query is used to cache single asynchronous requests in a unified and consistent way. The simplest form of a query is",source:"@site/docs/docs/guides/03-query.md",sourceDirName:"docs/guides",slug:"/docs/guides/query",permalink:"/docs/guides/query",draft:!1,editUrl:"https://github.com/D-James-GH/cached_query/tree/main/docs/docs/docs/guides/03-query.md",tags:[],version:"current",sidebarPosition:3,frontMatter:{title:"Query"},sidebar:"docs",previous:{title:"Quick Start",permalink:"/docs/quick-start"},next:{title:"Configuration",permalink:"/docs/guides/configuration"}},o={},l=[{value:"Query State",id:"query-state",level:3},{value:"Query Stream",id:"query-stream",level:2},{value:"Query Result",id:"query-result",level:2},{value:"Error Handling",id:"error-handling",level:2},{value:"Side Effects",id:"side-effects",level:2}],c={toc:l};function d(e){let{components:t,...n}=e;return(0,a.kt)("wrapper",(0,r.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"automatic-caching-with-query"},"Automatic Caching with Query"),(0,a.kt)("p",null,"A query is used to cache single asynchronous requests in a unified and consistent way. The simplest form of a query is\nshown below. No global configuration is needed, although possible."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},'final query = Query(\n  key: "my_data", \n  initialData: "Pre-populated data",\n  queryFn: () => api.getData(),\n);\n')),(0,a.kt)("p",null,"Each Query must have a queryFn. This is an asynchronous function that can return any custom or built in type. The return\nvalue of the queryFn will be cached. "),(0,a.kt)("p",null,"A query must be given a unique key which can be any json serializable value. Each unique key will create a new query in\nthe cache. Initial data can be passed to the query. On the first request this initial data will be emitted as part of the state\nrather than null. Any global query configuration can be overridden when instantiating a new query. See ",(0,a.kt)("a",{parentName:"p",href:"/docs/guides/configuration"},"configuration"),"\nfor more details."),(0,a.kt)("p",null,"Each query can be updated using ",(0,a.kt)("inlineCode",{parentName:"p"},"Query.update"),". This change will be emitted to any listening query. For more information\non updating a query see ",(0,a.kt)("a",{parentName:"p",href:"/docs/guides/optimistic-updates"},"optimistic updates")),(0,a.kt)("h3",{id:"query-state"},"Query State"),(0,a.kt)("p",null,(0,a.kt)("inlineCode",{parentName:"p"},"QueryState")," is the object containing the current state of the query. It holds the ",(0,a.kt)("strong",{parentName:"p"},"data")," returned from the queryFn\nalong with the current status of the query (loading, success, error, initial), the time of the last fetch and any errors\nthrow in the fetch."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},"final state = query.state;\nfinal isLoading = state.status == QueryStatus.loading;\nfinal data = state.data;\n")),(0,a.kt)("p",null,"A query can only hold one future at a time. This is so that the result can be requested from many places at once but only\none call to the queryFn will be made. A query will not invoke the queryFn until one of two things is used:"),(0,a.kt)("ol",null,(0,a.kt)("li",{parentName:"ol"},"The ",(0,a.kt)("inlineCode",{parentName:"li"},"result")," is requested via the future ",(0,a.kt)("inlineCode",{parentName:"li"},"Query.result")),(0,a.kt)("li",{parentName:"ol"},"A listener is added to the query stream.")),(0,a.kt)("h2",{id:"query-stream"},"Query Stream"),(0,a.kt)("p",null,"Each query manages its own stream controller. Streams enable a query to display currently existing data while fetching\nnew data in the background. When the new data is ready it will be emitted. A query stream will also emit any time the\nstate of the query is changed, this is useful for ",(0,a.kt)("a",{parentName:"p",href:"/docs/guides/mutations"},"mutations")," and\n",(0,a.kt)("a",{parentName:"p",href:"/docs/guides/optimistic-updates"},"optimistic updates"),"."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},'final query = Query(key: "my_data", queryFn: () => api.getData());\n\nquery.stream((state) {\n  if(state.status == QueryStatus.loading){\n    // show loading spinner\n  }\n  if(state.data != null){\n    // update ui to show the data.\n  }\n});\n')),(0,a.kt)("h2",{id:"query-result"},"Query Result"),(0,a.kt)("p",null,(0,a.kt)("inlineCode",{parentName:"p"},"Query.result")," is a quick and easy way to request the result of a queryFn. It returns ",(0,a.kt)("a",{parentName:"p",href:"#query-state"},"QueryState")," once\nthe queryFn has completed. For the full benefits of Cached Query use the stream api."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},'final query = Query(key: "my_data", queryFn: () => api.getData());\n\nfinal queryState = await query.result;\n')),(0,a.kt)("p",null,"There are a few downsides to using a query this way. The future always completes after the queryFn has completed. If the\ndata is stale then nothing will show until fresh data is available, meaning you are not getting the benefits of\nbackground fetches. "),(0,a.kt)("p",null,"As the Queries use streams to detect how many listeners they have left, using ",(0,a.kt)("inlineCode",{parentName:"p"},"Query.result")," never adds a\nlistener to the query. So, when the future is requested the ",(0,a.kt)("a",{parentName:"p",href:"/docs/guides/configuration"},"cache duration")," timer is started\nimmediately if there are no other listeners attached."),(0,a.kt)("h2",{id:"error-handling"},"Error Handling"),(0,a.kt)("p",null,"If a query, infinite query or a mutation throws an error or exception it will be caught and the current state will be\nupdated with the error. "),(0,a.kt)("h2",{id:"side-effects"},"Side Effects"),(0,a.kt)("p",null,"There are two side effects that can be passed to a query. "),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},(0,a.kt)("inlineCode",{parentName:"li"},"onSuccess")," - This is called after the query function succeeds but before the query state is updated."),(0,a.kt)("li",{parentName:"ul"},(0,a.kt)("inlineCode",{parentName:"li"},"onError")," - This is called if the query function fails but before the query state is updated.")),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},'final query = Query<String>(\n  key: "onSuccess",\n  onSuccess: (dynamic r) { \n    // do something with the response\n  },\n  onError: (dynamic e){\n    // do something with the error\n  },\n  queryFn: () async {\n    //...queryFn\n  },\n);\n')))}d.isMDXComponent=!0}}]);