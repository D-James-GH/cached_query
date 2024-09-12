"use strict";(self.webpackChunk=self.webpackChunk||[]).push([[648],{3905:(e,t,n)=>{n.d(t,{Zo:()=>d,kt:()=>y});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function o(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},i=Object.keys(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var u=r.createContext({}),s=function(e){var t=r.useContext(u),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},d=function(e){var t=s(e.components);return r.createElement(u.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},p=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,i=e.originalType,u=e.parentName,d=o(e,["components","mdxType","originalType","parentName"]),p=s(n),y=a,f=p["".concat(u,".").concat(y)]||p[y]||c[y]||i;return n?r.createElement(f,l(l({ref:t},d),{},{components:n})):r.createElement(f,l({ref:t},d))}));function y(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var i=n.length,l=new Array(i);l[0]=p;var o={};for(var u in t)hasOwnProperty.call(t,u)&&(o[u]=t[u]);o.originalType=e,o.mdxType="string"==typeof e?e:a,l[1]=o;for(var s=2;s<i;s++)l[s]=n[s];return r.createElement.apply(null,l)}return r.createElement.apply(null,n)}p.displayName="MDXCreateElement"},5889:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>u,contentTitle:()=>l,default:()=>c,frontMatter:()=>i,metadata:()=>o,toc:()=>s});var r=n(7462),a=(n(7294),n(3905));const i={},l="Flutter Additions",o={unversionedId:"docs/flutter-additions",id:"docs/flutter-additions",title:"Flutter Additions",description:"If you are using flutter there are a couple of useful additions added.",source:"@site/docs/docs/03-flutter-additions.md",sourceDirName:"docs",slug:"/docs/flutter-additions",permalink:"/docs/flutter-additions",draft:!1,editUrl:"https://github.com/D-James-GH/cached_query/tree/main/docs/docs/docs/03-flutter-additions.md",tags:[],version:"current",sidebarPosition:3,frontMatter:{},sidebar:"docs",previous:{title:"Observer",permalink:"/docs/guides/observer"},next:{title:"Storage",permalink:"/docs/storage"}},u={},s=[{value:"Connection Monitoring",id:"connection-monitoring",level:2},{value:"Refetch On Resume",id:"refetch-on-resume",level:2},{value:"Builders",id:"builders",level:2},{value:"Enabling and Disabling",id:"enabling-and-disabling",level:3},{value:"QueryBuilder",id:"querybuilder",level:3},{value:"InfiniteQueryBuilder",id:"infinitequerybuilder",level:3},{value:"MutationBuilder",id:"mutationbuilder",level:3}],d={toc:s};function c(e){let{components:t,...n}=e;return(0,a.kt)("wrapper",(0,r.Z)({},d,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"flutter-additions"},"Flutter Additions"),(0,a.kt)("p",null,"If you are using flutter there are a couple of useful additions added."),(0,a.kt)("p",null,"To globally configure Cached Query Flutter use ",(0,a.kt)("inlineCode",{parentName:"p"},"CachedQuery.configFlutter")," instead of ",(0,a.kt)("inlineCode",{parentName:"p"},"config"),"."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},"CachedQuery.instance.configFlutter(\n  storage: await CachedStorage.ensureInitialized(),\n  config: QueryConfig(),\n);\n")),(0,a.kt)("h2",{id:"connection-monitoring"},"Connection Monitoring"),(0,a.kt)("p",null,"Cached query flutter uses the ",(0,a.kt)("a",{parentName:"p",href:"https://pub.dev/packages/connectivity_plus"},"Connectivity Plus"),' to monitor the connection\nstatus. If the connection changes from no-connection to valid connection Cached Query will ping example.com to verify the\nconnection status. Any Query or Infinite Query that has listeners will be considered "active". Any active queries will be\nre-fetched if the connection is restored. Use the config to turn this off. '),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},"CachedQuery.instance.configFlutter(\n  config: QueryConfigFlutter(\n    refetchOnConnection: true,\n  ),\n);\n")),(0,a.kt)("p",null,"This can be configured in the individual query."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},'Query(\n  key: "a query key",\n  queryFn: () async => _api.getData(),\n  config: QueryConfigFlutter(\n    refetchOnResume: false,\n    refetchOnConnection: true,\n  ),\n),\n')),(0,a.kt)("h2",{id:"refetch-on-resume"},"Refetch On Resume"),(0,a.kt)("p",null,"Cached Query Flutter uses the ",(0,a.kt)("inlineCode",{parentName:"p"},"WidgetsBindingObserver")," to monitor the lifecycle state of the app. If the app state is\nresumed any active queries will be re-fetched. Turn this off with the global flutter config."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},"CachedQuery.instance.configFlutter(\n  config: QueryConfigFlutter(\n    refetchOnResume: false,\n    refetchOnConnection: true,\n  ),\n);\n")),(0,a.kt)("p",null,"This can be configured in the individual query."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},'Query(\n  key: "a query key",\n  queryFn: () async => _api.getData(),\n  config: QueryConfigFlutter(\n    refetchOnResume: false,\n    refetchOnConnection: true,\n  ),\n),\n')),(0,a.kt)("h2",{id:"builders"},"Builders"),(0,a.kt)("p",null,"Three builders are added for ease of use. They act very similar to a ",(0,a.kt)("inlineCode",{parentName:"p"},"StreamBuilder"),". "),(0,a.kt)("h3",{id:"enabling-and-disabling"},"Enabling and Disabling"),(0,a.kt)("p",null,"By default, the builders will subscribe to the query's listener on ",(0,a.kt)("inlineCode",{parentName:"p"},"initState")," and unsubscribe on ",(0,a.kt)("inlineCode",{parentName:"p"},"dispose"),".\nThis means that the query will be fetched when the widget is first rendered. You can prevent this using the ",(0,a.kt)("inlineCode",{parentName:"p"},"enabled")," flag\non the ",(0,a.kt)("inlineCode",{parentName:"p"},"InfiniteQueryBuilder")," and ",(0,a.kt)("inlineCode",{parentName:"p"},"QueryBuilder"),"."),(0,a.kt)("admonition",{type:"warning"},(0,a.kt)("p",{parentName:"admonition"},"This will only prevent the widget from adding a listener to the query. If you have other listeners elsewhere then the\nquery will still be fetched.")),(0,a.kt)("h3",{id:"querybuilder"},"QueryBuilder"),(0,a.kt)("p",null,"QueryBuilder takes a query and will call the builder method whenever the query state changes."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},' QueryBuilder<DataModel?>(\n  enabled: false,\n  query: Query(\n    key: "a query key",\n    queryFn: () async => _api.getData(),\n  ),\n  builder: (context, state) {\n    return Column(\n      children: [\n        if(state.status == QuerStatus.loading)\n          const CircularProgressIndicator(),\n        const DisplayData(data: state.data)\n      ],\n    );\n  },\n),\n')),(0,a.kt)("p",null,"If you know that a query has already been instantiated then you can pass a key to the Query Builder instead, however this will fail if there is no query in the cache with that key."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},' QueryBuilder<DataModel?>(\n  queryKey: "a query key",\n  builder: (context, state) {\n    return Column(\n      children: [\n        if(state.status == QuerStatus.loading)\n          const CircularProgressIndicator(),\n        const DisplayData(data: state.data)\n      ],\n    );\n  },\n),\n')),(0,a.kt)("h3",{id:"infinitequerybuilder"},"InfiniteQueryBuilder"),(0,a.kt)("p",null,"InfiniteQueryBuilder takes an infinite query and will call the builder method whenever the query state changes."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},' InfiniteQueryBuilder<DataModel?>(\n  query: InfiniteQuery(\n    key: "a query key",\n    queryFn: () async => _api.getData(),\n    getNextArg: (state) {\n      if (state.lastPage?.isEmpty ?? false) return null;\n      return state.length + 1;\n    },\n  ),\n  builder: (context, state) {\n    if(state.data == null) return SizedBox();\n    final allPosts = state.data!.expand((e) => e).toList();\n    \n    return CustomScrollView(\n      slivers: [\n        if (state.status == QueryStatus.error &&\n            state.error is SocketException)\n          SliverToBoxAdapter(\n            child: DecoratedBox(\n              decoration:\n                  BoxDecoration(color: Theme.of(context).errorColor),\n              child: const Text(\n                "No internet connection",\n                style: TextStyle(color: Colors.white),\n                textAlign: TextAlign.center,\n              ),\n            ),\n          ),\n        SliverList(\n          delegate: SliverChildBuilderDelegate(\n            (context, i) => _Post(\n              post: allPosts[i],\n              index: i,\n            ),\n            childCount: allPosts.length,\n          ),\n        ),\n        if (state.status == QueryStatus.loading)\n          const SliverToBoxAdapter(\n            child: Center(\n              child: SizedBox(\n                height: 40,\n                width: 40,\n                child: CircularProgressIndicator(),\n              ),\n            ),\n          ),\n        SliverPadding(\n          padding: EdgeInsets.only(\n            bottom: MediaQuery.of(context).padding.bottom,\n          ),\n        )\n      ],\n    );\n  },\n)\n')),(0,a.kt)("p",null,"Similar to the query builder you can also pass a key to the ",(0,a.kt)("inlineCode",{parentName:"p"},"InfiniteQueryBuilder")," if you know there is a query available."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},' InfiniteQueryBuilder<DataModel?>(\n  query: InfiniteQuery(\n    key: "a query key",\n    queryFn: () async => _api.getData(),\n    getNextArg: (state) {\n      if (state.lastPage?.isEmpty ?? false) return null;\n      return state.length + 1;\n    },\n  ),\n  builder: (context, state) {\n    //...build ui\n  },\n)\n')),(0,a.kt)("h3",{id:"mutationbuilder"},"MutationBuilder"),(0,a.kt)("p",null,"Much the same as the query builder. It will call the builder function when the mutation state changes."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"}," MutationBuilder<PostModel, PostModel>(\n    mutation: _postService.createPost(),\n    builder: (context, state, mutate) {\n      // Can use the mutate() function directly in the builder.\n    },\n  ),\n")))}c.isMDXComponent=!0}}]);