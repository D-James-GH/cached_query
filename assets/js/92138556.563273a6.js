"use strict";(self.webpackChunk=self.webpackChunk||[]).push([[416],{3905:(e,t,n)=>{n.d(t,{Zo:()=>d,kt:()=>p});var r=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function a(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?a(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):a(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},a=Object.keys(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var s=r.createContext({}),u=function(e){var t=r.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},d=function(e){var t=u(e.components);return r.createElement(s.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},h=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,a=e.originalType,s=e.parentName,d=l(e,["components","mdxType","originalType","parentName"]),h=u(n),p=o,m=h["".concat(s,".").concat(p)]||h[p]||c[p]||a;return n?r.createElement(m,i(i({ref:t},d),{},{components:n})):r.createElement(m,i({ref:t},d))}));function p(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var a=n.length,i=new Array(a);i[0]=h;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:o,i[1]=l;for(var u=2;u<a;u++)i[u]=n[u];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}h.displayName="MDXCreateElement"},9332:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>s,contentTitle:()=>i,default:()=>c,frontMatter:()=>a,metadata:()=>l,toc:()=>u});var r=n(7462),o=(n(7294),n(3905));const a={},i="Flutter Bloc Query",l={unversionedId:"examples/with-flutter-bloc",id:"examples/with-flutter-bloc",title:"Flutter Bloc Query",description:"We will use the Json Placeholder Api with a time delay to demonstrate",source:"@site/docs/examples/02-with-flutter-bloc.md",sourceDirName:"examples",slug:"/examples/with-flutter-bloc",permalink:"/examples/with-flutter-bloc",draft:!1,editUrl:"https://github.com/D-James-GH/cached_query/tree/main/docs/docs/examples/02-with-flutter-bloc.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{},sidebar:"examples",previous:{title:"Simple Query Example",permalink:"/examples/simple-query"},next:{title:"Infinite List with Bloc",permalink:"/examples/infinite-list-with-bloc"}},s={},u=[{value:"How to integrate?",id:"how-to-integrate",level:2},{value:"Map the query state to bloc state.",id:"map-the-query-state-to-bloc-state",level:3},{value:"Pro",id:"pro",level:4},{value:"Con",id:"con",level:4},{value:"Pass the query to an <code>QueryBuilder</code> in the UI.",id:"pass-the-query-to-an-querybuilder-in-the-ui",level:3},{value:"Pro",id:"pro-1",level:4},{value:"Con",id:"con-1",level:4},{value:"The Setup",id:"the-setup",level:2},{value:"Creating the Query",id:"creating-the-query",level:2},{value:"Post Model",id:"post-model",level:2},{value:"Bloc Events",id:"bloc-events",level:2},{value:"Option 1 - Passing the query to the UI",id:"option-1---passing-the-query-to-the-ui",level:2},{value:"Bloc State",id:"bloc-state",level:3},{value:"The Bloc",id:"the-bloc",level:3},{value:"The UI",id:"the-ui",level:3},{value:"Post Widget",id:"post-widget",level:3},{value:"Post Page",id:"post-page",level:3},{value:"Option 2 - Mapping the Query State to Bloc State",id:"option-2---mapping-the-query-state-to-bloc-state",level:2},{value:"Bloc State",id:"bloc-state-1",level:3},{value:"The Bloc",id:"the-bloc-1",level:3},{value:"The UI",id:"the-ui-1",level:3},{value:"Post Page",id:"post-page-1",level:3},{value:"Summary",id:"summary",level:2}],d={toc:u};function c(e){let{components:t,...n}=e;return(0,o.kt)("wrapper",(0,r.Z)({},d,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"flutter-bloc-query"},"Flutter Bloc Query"),(0,o.kt)("p",null,"We will use the ",(0,o.kt)("a",{parentName:"p",href:"https://jsonplaceholder.typicode.com/"},"Json Placeholder Api")," with a time delay to demonstrate\ncached data."),(0,o.kt)("p",null,"The source code for this example can be found here: ",(0,o.kt)("a",{parentName:"p",href:"https://github.com/D-James-GH/cached_query/tree/main/examples/simple_caching_with_bloc"},"https://github.com/D-James-GH/cached_query/tree/main/examples/simple_caching_with_bloc")),(0,o.kt)("p",null,"For this example we will walk through the simplest form of caching with Cached Query and Flutter Bloc together. Flutter bloc is a popular implementation of the bloc pattern. It is very useful for keeping app architecture structured as team size and app size grows."),(0,o.kt)("p",null,"Using Flutter Bloc along side Cached Query was an important consideration when creating this package. However, following example should be transferable to any app architecture."),(0,o.kt)("h2",{id:"how-to-integrate"},"How to integrate?"),(0,o.kt)("p",null,"There are two implementation options to consider when using Cached Query with Flutter Bloc. "),(0,o.kt)("h3",{id:"map-the-query-state-to-bloc-state"},"Map the query state to bloc state."),(0,o.kt)("p",null,"This option uses listens to the ",(0,o.kt)("inlineCode",{parentName:"p"},"Query")," stream in the bloc and maps incoming query states into outgoing bloc states."),(0,o.kt)("h4",{id:"pro"},"Pro"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"Easy to integrate into existing apps as only the repository and bloc layers need adjusting, the presentation layer will remain the same.")),(0,o.kt)("h4",{id:"con"},"Con"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"The query key will always have a subscriber if the bloc is still in memory. When using a ",(0,o.kt)("inlineCode",{parentName:"li"},"QueryBuilder")," the subscriber will be removed as soon as the component is removed from the widget tree.")),(0,o.kt)("h3",{id:"pass-the-query-to-an-querybuilder-in-the-ui"},"Pass the query to an ",(0,o.kt)("inlineCode",{parentName:"h3"},"QueryBuilder")," in the UI."),(0,o.kt)("p",null,"This option passes the ",(0,o.kt)("inlineCode",{parentName:"p"},"Query")," through to the UI an uses the ",(0,o.kt)("inlineCode",{parentName:"p"},"QueryBuilder")," to listen to state updates."),(0,o.kt)("h4",{id:"pro-1"},"Pro"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"As soon as the ",(0,o.kt)("inlineCode",{parentName:"li"},"QueryBuilder")," is removed from the widget tree the subscriber is removed, allowing for more effective cache management.")),(0,o.kt)("h4",{id:"con-1"},"Con"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"Needs an Infinite Query to be used directly in the UI, either with a ",(0,o.kt)("inlineCode",{parentName:"li"},"QueryBuilder")," or by listening/disposing of the stream.")),(0,o.kt)("h2",{id:"the-setup"},"The Setup"),(0,o.kt)("p",null,"Install the package."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"flutter pub add cached_query_flutter\n")),(0,o.kt)("p",null,"The setup is optional but to take full advantage of cached query we need to call the config function as early as possible."),(0,o.kt)("p",null,"The ",(0,o.kt)("inlineCode",{parentName:"p"},"config")," function lets cached query know that it should re-fetch queries if the connectivity is established and if\nthe app comes back into view."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"void main() async {\n  WidgetsFlutterBinding.ensureInitialized();\n  CachedQuery.instance.configFlutter(\n    refetchOnResume: true,\n    refetchOnConnection: true,\n  );\n  runApp(const MyApp());\n}\n")),(0,o.kt)("p",null,"The main app will just consist of one page.  "),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class MyApp extends StatelessWidget {\n  const MyApp({Key? key}) : super(key: key);\n  // This widget is the root of your application.\n  @override\n  Widget build(BuildContext context) {\n    return const MaterialApp(\n      title: 'Flutter Demo',\n      home: PostPage(),\n    );\n  }\n}\n")),(0,o.kt)("h2",{id:"creating-the-query"},"Creating the Query"),(0,o.kt)("p",null,"We create a service function which returns a ",(0,o.kt)("inlineCode",{parentName:"p"},"Query")," for us to display. The ",(0,o.kt)("inlineCode",{parentName:"p"},"queryFn")," is where the logic for the request\nneeds to go. This function will be first called when a listener is added to the query stream. "),(0,o.kt)("p",null,"As the app is going to fetch a post by an id we have to add the id to the query key as well. The helper function below\nreturns a key which includes the post id. "),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},'String postKey(int id) => "postKey$id";\n')),(0,o.kt)("p",null,"Each time the query key changes a new query will be created. "),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"\nQuery<PostModel> getPostById(int id) {\n  return Query<PostModel>(\n    key: postKey(id),\n    queryFn: () async {\n      final uri = Uri.parse(\n        'https://jsonplaceholder.typicode.com/posts/$id',\n      );\n      final res = await http.get(uri);\n      return Future.delayed(\n        const Duration(milliseconds: 500),\n        () => PostModel.fromJson(\n          jsonDecode(res.body) as Map<String, dynamic>,\n        ),\n      );\n    },\n  );\n}\n")),(0,o.kt)("h2",{id:"post-model"},"Post Model"),(0,o.kt)("p",null,"This post model is a simple object that we serialize the json payload into."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},'class PostModel {\n  final String title;\n  final int id;\n  final String body;\n  final int userId;\n\n  PostModel({\n    required this.title,\n    required this.id,\n    required this.body,\n    required this.userId,\n  });\n\n  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(\n    title: json["title"],\n    body: json["body"],\n    id: json["id"],\n    userId: json["userId"],\n  );\n}\n')),(0,o.kt)("h2",{id:"bloc-events"},"Bloc Events"),(0,o.kt)("p",null,"The events will be the same whether you are mapping the query to bloc state or not.\nWe have one that fetches a new query by it's id and another that refreshes the current query."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"abstract class PostEvent {}\n\nclass PostFetched extends PostEvent {\n  final int id;\n  PostFetched(this.id);\n}\n\nclass PostRefreshed extends PostEvent {}\n")),(0,o.kt)("h2",{id:"option-1---passing-the-query-to-the-ui"},"Option 1 - Passing the query to the UI"),(0,o.kt)("h3",{id:"bloc-state"},"Bloc State"),(0,o.kt)("p",null,"The Bloc state will differ depending on whether you are mapping the query state in the bloc or not."),(0,o.kt)("p",null,"If you would prefer to pass the query through to the UI then the state will hold the current query."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class PostWithBuilderState extends Equatable {\n  final int currentId;\n  final Query<PostModel> postQuery;\n\n  const PostWithBuilderState({\n    required this.currentId,\n    required this.postQuery,\n  });\n\n  @override\n  List<Object?> get props => [postQuery, currentId];\n}\n")),(0,o.kt)("h3",{id:"the-bloc"},"The Bloc"),(0,o.kt)("p",null,"When passing the query through to the UI the bloc is very simple. It simply needs to keep track of the current post id and pass through the new query when the current id changes."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class PostWithBuilderBloc\n    extends Bloc<PostWithBuilderEvent, PostWithBuilderState> {\n  PostWithBuilderBloc()\n      : super(PostWithBuilderState(currentId: 50, postQuery: getPostById(50))) {\n    on<PostWithBuilderFetched>(_onPostFetched);\n    on<PostWithBuilderRefreshed>(_onPostRefreshed);\n  }\n\n  FutureOr<void> _onPostFetched(\n    PostWithBuilderFetched event,\n    Emitter<PostWithBuilderState> emit,\n  ) {\n    final res = getPostById(event.id);\n    emit(PostWithBuilderState(currentId: event.id, postQuery: res));\n  }\n\n  FutureOr<void> _onPostRefreshed(\n    PostWithBuilderRefreshed event,\n    Emitter<PostWithBuilderState> emit,\n  ) {\n    getPostById(state.currentId).refetch();\n  }\n}\n")),(0,o.kt)("h3",{id:"the-ui"},"The UI"),(0,o.kt)("p",null,"When passing the query through we will use the ",(0,o.kt)("inlineCode",{parentName:"p"},"QueryBuilder")," to update the UI."),(0,o.kt)("h3",{id:"post-widget"},"Post Widget"),(0,o.kt)("p",null,"The Post widget will be take a ",(0,o.kt)("inlineCode",{parentName:"p"},"PostModel")," and display it."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},'class Post extends StatelessWidget {\n  final PostModel post;\n\n  const Post({super.key, required this.post});\n\n  @override\n  Widget build(BuildContext context) {\n    return Container(\n      margin: const EdgeInsets.all(10),\n      child: Column(\n        children: [\n          const Text(\n            "Title",\n            textAlign: TextAlign.center,\n            style: TextStyle(fontSize: 20),\n          ),\n          Text(\n            post.title,\n            textAlign: TextAlign.center,\n          ),\n          const Text(\n            "Body",\n            textAlign: TextAlign.center,\n            style: TextStyle(fontSize: 20),\n          ),\n          Text(\n            post.body,\n            textAlign: TextAlign.center,\n          ),\n        ],\n      ),\n    );\n  }\n}\n')),(0,o.kt)("h3",{id:"post-page"},"Post Page"),(0,o.kt)("p",null,"The post page utilises a combination of the query builder and bloc builder to update the UI."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},'class PostWithBuilderPage extends StatelessWidget {\n  const PostWithBuilderPage({Key? key}) : super(key: key);\n\n  @override\n  Widget build(BuildContext context) {\n    return BlocProvider(\n      create: (context) =>\n          PostWithBuilderBloc()..add(const PostWithBuilderFetched(50)),\n      child: Builder(builder: (context) {\n        return Scaffold(\n          appBar: AppBar(\n            centerTitle: true,\n            title: BlocSelector<PostWithBuilderBloc, PostWithBuilderState,\n                Query<PostModel>?>(\n              selector: (state) => state.postQuery,\n              builder: (context, query) {\n                if (query == null) return const SizedBox();\n                return QueryBuilder(\n                  query: query,\n                  builder: (context, state) {\n                    return Text(\n                      state.status == QueryStatus.loading ? "loading..." : "",\n                    );\n                  },\n                );\n              },\n            ),\n            actions: [\n              IconButton(\n                icon: const Icon(Icons.refresh),\n                onPressed: () => context\n                    .read<PostWithBuilderBloc>()\n                    .add(const PostWithBuilderRefreshed()),\n              )\n            ],\n          ),\n          body: Center(\n            child: Column(\n              children: [\n                BlocBuilder<PostWithBuilderBloc, PostWithBuilderState>(\n                  builder: (context, state) {\n                    final currentId = state.currentId;\n                    return Row(\n                      mainAxisAlignment: MainAxisAlignment.center,\n                      children: [\n                        IconButton(\n                          onPressed: () => context\n                              .read<PostWithBuilderBloc>()\n                              .add(PostWithBuilderFetched(currentId - 1)),\n                          icon: const Icon(Icons.arrow_left),\n                        ),\n                        Text(currentId.toString()),\n                        IconButton(\n                          onPressed: () => context\n                              .read<PostWithBuilderBloc>()\n                              .add(PostWithBuilderFetched(currentId + 1)),\n                          icon: const Icon(Icons.arrow_right),\n                        ),\n                      ],\n                    );\n                  },\n                ),\n                BlocSelector<PostWithBuilderBloc, PostWithBuilderState,\n                    Query<PostModel>>(\n                  selector: (state) => state.postQuery,\n                  builder: (context, query) {\n                    return QueryBuilder(\n                      query: query,\n                      builder: (context, state) {\n                        if (state.data == null) {\n                          return const SizedBox();\n                        }\n                        return Post(post: state.data!);\n                      },\n                    );\n                  },\n                ),\n              ],\n            ),\n          ),\n        );\n      }),\n    );\n  }\n}\n\n')),(0,o.kt)("h2",{id:"option-2---mapping-the-query-state-to-bloc-state"},"Option 2 - Mapping the Query State to Bloc State"),(0,o.kt)("h3",{id:"bloc-state-1"},"Bloc State"),(0,o.kt)("p",null,"The state of the bloc will contain the id of the current post and the current post. These are stored separately as the id is treated as local state."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class PostState extends Equatable {\n  final PostModel? post;\n  final int currentId;\n  final bool isLoading;\n\n  const PostState({this.isLoading = false, this.currentId = 1, this.post});\n\n  @override\n  List<Object?> get props => [post, isLoading, currentId];\n}\n")),(0,o.kt)("h3",{id:"the-bloc-1"},"The Bloc"),(0,o.kt)("p",null,"Mapping the query state to bloc state requires Flutter Bloc's ",(0,o.kt)("inlineCode",{parentName:"p"},"emit.foreach"),". The ",(0,o.kt)("inlineCode",{parentName:"p"},"emit.foreach")," function will manage the stream subscription for us.  "),(0,o.kt)("admonition",{type:"info"},(0,o.kt)("p",{parentName:"admonition"},"It is important to use the ",(0,o.kt)("inlineCode",{parentName:"p"},"restartable")," event transformer from Bloc Concurrency. This makes sure that there is only one query subscription at a time.")),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class PostBloc extends Bloc<PostEvent, PostState> {\n  PostBloc() : super(const PostState()) {\n    /// !important: use the restartable transformer to automatically subscribe and\n    /// unsubscribe when a new event comes in.\n    on<PostFetched>(_onFetched, transformer: restartable());\n    on<PostRefreshed>(_onRefresh);\n  }\n\n  FutureOr<void> _onFetched(\n    PostFetched event,\n    Emitter<PostState> emit,\n  ) {\n    return emit.forEach(\n      getPostById(event.id).stream,\n      onData: (queryState) {\n        return PostState(\n          currentId: event.id,\n          post: queryState.data,\n          isLoading: queryState.status == QueryStatus.loading,\n        );\n      },\n    );\n  }\n\n  FutureOr<void> _onRefresh(PostRefreshed event, Emitter<PostState> emit) {\n    getPostById(state.currentId).refetch();\n  }\n}\n")),(0,o.kt)("p",null,"The ",(0,o.kt)("inlineCode",{parentName:"p"},"onData")," function will be called whenever the query state is updated. This is where we map the current query state to a bloc state and return it. The listener will stay alive until there is a new ",(0,o.kt)("inlineCode",{parentName:"p"},"PostFetched")," event."),(0,o.kt)("h3",{id:"the-ui-1"},"The UI"),(0,o.kt)("p",null,"The UI will use the same post widget as option 1."),(0,o.kt)("h3",{id:"post-page-1"},"Post Page"),(0,o.kt)("p",null,"The post page here uses the bloc builder to update the UI. As the query state has already been listened to and mapped we don't need to use the query builder."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},'class PostPage extends StatelessWidget {\n  const PostPage({Key? key}) : super(key: key);\n\n  @override\n  Widget build(BuildContext context) {\n    return BlocProvider(\n      create: (context) => PostBloc()..add(PostFetched(50)),\n      child: Builder(builder: (context) {\n        return Scaffold(\n          appBar: AppBar(\n            centerTitle: true,\n            title: BlocSelector<PostBloc, PostState, bool>(\n              selector: (state) => state.isLoading,\n              builder: (context, isLoading) {\n                return Text(\n                  isLoading ? "loading..." : "",\n                );\n              },\n            ),\n            actions: [\n              IconButton(\n                icon: const Icon(Icons.refresh),\n                onPressed: () => context.read<PostBloc>().add(PostRefreshed()),\n              )\n            ],\n          ),\n          body: Center(\n            child: Column(\n              children: [\n                BlocBuilder<PostBloc, PostState>(\n                  builder: (context, state) {\n                    final currentId = state.currentId;\n                    return Row(\n                      mainAxisAlignment: MainAxisAlignment.center,\n                      children: [\n                        IconButton(\n                          onPressed: () => context\n                              .read<PostBloc>()\n                              .add(PostFetched(currentId - 1)),\n                          icon: const Icon(Icons.arrow_left),\n                        ),\n                        Text(currentId.toString()),\n                        IconButton(\n                          onPressed: () => context\n                              .read<PostBloc>()\n                              .add(PostFetched(currentId + 1)),\n                          icon: const Icon(Icons.arrow_right),\n                        ),\n                      ],\n                    );\n                  },\n                ),\n                BlocSelector<PostBloc, PostState, PostModel?>(\n                  selector: (state) => state.post,\n                  builder: (context, post) {\n                    if (post == null) {\n                      return const SizedBox();\n                    }\n                    return Post(post: post);\n                  },\n                ),\n              ],\n            ),\n          ),\n        );\n      }),\n    );\n  }\n}\n\n')),(0,o.kt)("h2",{id:"summary"},"Summary"),(0,o.kt)("p",null,"There are two ways to use Cached Query along side Flutter Bloc. Each with their own pros and cons. If you are starting from scratch you get some memory management benefits from passing the query through to the UI. However, if you are bringing Cached Query into an existing app then wrapping an API call with a query then mapping the state is much simpler."))}c.isMDXComponent=!0}}]);