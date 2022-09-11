"use strict";(self.webpackChunk=self.webpackChunk||[]).push([[116],{3905:(e,t,n)=>{n.d(t,{Zo:()=>c,kt:()=>p});var i=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function s(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);t&&(i=i.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,i)}return n}function r(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?s(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):s(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function a(e,t){if(null==e)return{};var n,i,o=function(e,t){if(null==e)return{};var n,i,o={},s=Object.keys(e);for(i=0;i<s.length;i++)n=s[i],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var s=Object.getOwnPropertySymbols(e);for(i=0;i<s.length;i++)n=s[i],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var l=i.createContext({}),d=function(e){var t=i.useContext(l),n=t;return e&&(n="function"==typeof e?e(t):r(r({},t),e)),n},c=function(e){var t=d(e.components);return i.createElement(l.Provider,{value:t},e.children)},u={inlineCode:"code",wrapper:function(e){var t=e.children;return i.createElement(i.Fragment,{},t)}},h=i.forwardRef((function(e,t){var n=e.components,o=e.mdxType,s=e.originalType,l=e.parentName,c=a(e,["components","mdxType","originalType","parentName"]),h=d(n),p=o,m=h["".concat(l,".").concat(p)]||h[p]||u[p]||s;return n?i.createElement(m,r(r({ref:t},c),{},{components:n})):i.createElement(m,r({ref:t},c))}));function p(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var s=n.length,r=new Array(s);r[0]=h;var a={};for(var l in t)hasOwnProperty.call(t,l)&&(a[l]=t[l]);a.originalType=e,a.mdxType="string"==typeof e?e:o,r[1]=a;for(var d=2;d<s;d++)r[d]=n[d];return i.createElement.apply(null,r)}return i.createElement.apply(null,n)}h.displayName="MDXCreateElement"},3270:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>l,contentTitle:()=>r,default:()=>u,frontMatter:()=>s,metadata:()=>a,toc:()=>d});var i=n(7462),o=(n(7294),n(3905));const s={},r="Infinite List with Bloc",a={unversionedId:"examples/infinite-list-with-bloc",id:"examples/infinite-list-with-bloc",title:"Infinite List with Bloc",description:"This blog will demonstrate how to create a cached infinite list with cached query and flutter bloc.",source:"@site/docs/examples/04-infinite-list-with-bloc.md",sourceDirName:"examples",slug:"/examples/infinite-list-with-bloc",permalink:"/examples/infinite-list-with-bloc",draft:!1,editUrl:"https://github.com/D-James-GH/cached_query/tree/main/docs/docs/examples/04-infinite-list-with-bloc.md",tags:[],version:"current",sidebarPosition:4,frontMatter:{},sidebar:"examples",previous:{title:"Flutter Bloc",permalink:"/examples/with-flutter-bloc"}},l={},d=[{value:"Data Layers",id:"data-layers",level:2},{value:"Service",id:"service",level:3},{value:"Repository",id:"repository",level:3},{value:"Post Model",id:"post-model",level:3},{value:"Bloc without the InfiniteQueryBuilder",id:"bloc-without-the-infinitequerybuilder",level:2},{value:"The Events",id:"the-events",level:3},{value:"Bloc state",id:"bloc-state",level:3},{value:"The Bloc",id:"the-bloc",level:3},{value:"The UI",id:"the-ui",level:3},{value:"Post Widget",id:"post-widget",level:4},{value:"Post List Page",id:"post-list-page",level:4},{value:"Adding the IntiniteQueryBuilder",id:"adding-the-intinitequerybuilder",level:2},{value:"Events",id:"events",level:3},{value:"State",id:"state",level:2},{value:"The Bloc",id:"the-bloc-1",level:3},{value:"The UI",id:"the-ui-1",level:3},{value:"Wrap up",id:"wrap-up",level:2}],c={toc:d};function u(e){let{components:t,...n}=e;return(0,o.kt)("wrapper",(0,i.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"infinite-list-with-bloc"},"Infinite List with Bloc"),(0,o.kt)("p",null,"This blog will demonstrate how to create a cached infinite list with cached query and flutter bloc."),(0,o.kt)("p",null,"There are two options when integrating cached query with flutter bloc."),(0,o.kt)("p",null,"The code for this example can be found here:\n",(0,o.kt)("a",{parentName:"p",href:"https://github.com/D-James-GH/cached_query/tree/main/examples/infinite_list_with_bloc"},"https://github.com/D-James-GH/cached_query/tree/main/examples/infinite_list_with_bloc")),(0,o.kt)("ol",null,(0,o.kt)("li",{parentName:"ol"},(0,o.kt)("p",{parentName:"li"},"Map the query state to bloc state in the bloc."),(0,o.kt)("p",{parentName:"li"},"Pro:"),(0,o.kt)("ul",{parentName:"li"},(0,o.kt)("li",{parentName:"ul"},"Easy to integrate into existing apps as only the repository and bloc layers need adjusting, the presentation layer will remain the same.")),(0,o.kt)("p",{parentName:"li"},"Con:"),(0,o.kt)("ul",{parentName:"li"},(0,o.kt)("li",{parentName:"ul"},"The query key will always have a subscriber if the bloc is still in memory. When using a ",(0,o.kt)("inlineCode",{parentName:"li"},"InfiniteQueryBuilder")," the subscriber will be removed as soon as the component is removed from the widget tree."))),(0,o.kt)("li",{parentName:"ol"},(0,o.kt)("p",{parentName:"li"},"Hold the Infinite Query in the bloc state and use a ",(0,o.kt)("inlineCode",{parentName:"p"},"InfiniteQueryBuilder")," in the UI."),(0,o.kt)("p",{parentName:"li"},"Pro:"),(0,o.kt)("ul",{parentName:"li"},(0,o.kt)("li",{parentName:"ul"},"As soon as the ",(0,o.kt)("inlineCode",{parentName:"li"},"InfiniteQueryBuilder")," is removed from the widget tree the subscriber is removed, allowing for more effective cache management.")),(0,o.kt)("p",{parentName:"li"},"Con:"),(0,o.kt)("ul",{parentName:"li"},(0,o.kt)("li",{parentName:"ul"},"Needs an Infinite Query to be used directly in the UI, either with a ",(0,o.kt)("inlineCode",{parentName:"li"},"InfiniteQueryBuilder")," or by listening/disposing of the stream.")))),(0,o.kt)("h2",{id:"data-layers"},"Data Layers"),(0,o.kt)("p",null,"Both methods will required the same service and repository. For this example we will use the ",(0,o.kt)("a",{parentName:"p",href:"https://jsonplaceholder.typicode.com/"},"json placeholder")," api. We are also adding a one second delay to the http request purely to demonstrate the caching fully."),(0,o.kt)("h3",{id:"service"},"Service"),(0,o.kt)("p",null,"A simple service function that will take the current page number and the limit to be returned."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class PostService {\n  Future<List<dynamic>> getPosts({\n    required int limit,\n    required int page,\n  }) async {\n    final uri = Uri.parse(\n      'https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page',\n    );\n    final res = await http.get(uri);\n    // extra delay for testing purposes\n    return Future.delayed(\n      const Duration(seconds: 1),\n      () => jsonDecode(res.body) as List<dynamic>,\n    );\n  }\n}\n")),(0,o.kt)("h3",{id:"repository"},"Repository"),(0,o.kt)("p",null,"Here we create the infinite query. The query function will not be called until the query has a listener or ",(0,o.kt)("inlineCode",{parentName:"p"},"result")," is called."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class PostRepository {\n  final _service = PostService();\n\n  InfiniteQuery<List<PostModel>, int> getPosts() {\n    return InfiniteQuery<List<PostModel>, int>(\n      key: 'posts',\n      getNextArg: (state) {\n        if (state.lastPage?.isEmpty ?? false) return null;\n        return state.length + 1;\n      },\n      queryFn: (page) async => PostModel.listFromJson(\n        await _service.getPosts(page: page, limit: 10),\n      ),\n    );\n  }\n}\n")),(0,o.kt)("p",null,"The return value of ",(0,o.kt)("inlineCode",{parentName:"p"},"getNextArg")," will be passed to the ",(0,o.kt)("inlineCode",{parentName:"p"},"queryFn")," which in this case is an integer. If the last page is ",(0,o.kt)("strong",{parentName:"p"},"Not")," null and it is empty then it means there are no more pages that can be fetched and therefore we return null from ",(0,o.kt)("inlineCode",{parentName:"p"},"getNextArg"),". Returning null sets the state of the infinite query the ",(0,o.kt)("inlineCode",{parentName:"p"},"hasReachedMax"),". If the last page was null or had data then we return the length of the state plus 1 for the next page."),(0,o.kt)("h3",{id:"post-model"},"Post Model"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},'class PostModel extends Equatable {\n  final int id;\n  final String title;\n  final String body;\n  final int userId;\n\n  const PostModel({\n    required this.id,\n    required this.title,\n    required this.body,\n    required this.userId,\n  });\n\n  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(\n        id: json["id"],\n        title: json["title"],\n        body: json["body"],\n        userId: json["userId"],\n      );\n\n  static List<PostModel> listFromJson(List<dynamic> json) => json\n      .map(\n        (dynamic postJson) =>\n            PostModel.fromJson(postJson as Map<String, dynamic>),\n      )\n      .toList();\n\n  @override\n  List<Object?> get props => [id, title, body, userId];\n}\n')),(0,o.kt)("p",null,"Using Equatable or freezed to override the equality operator is a good idea, as Cached Query uses equality when determining which pages need re-fetching."),(0,o.kt)("h2",{id:"bloc-without-the-infinitequerybuilder"},"Bloc without the InfiniteQueryBuilder"),(0,o.kt)("p",null,"As mentioned at the start, when integrating cached query into an existing project you can map the stream of the infinite query into a stream of bloc states."),(0,o.kt)("p",null,"The following section will focus on mapping the infinite query stream to bloc states."),(0,o.kt)("h3",{id:"the-events"},"The Events"),(0,o.kt)("p",null,"We only need two events in the bloc. One to initialise the query and listen to the stream (",(0,o.kt)("inlineCode",{parentName:"p"},"PostsFetched"),") and one to get the next page."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"@immutable\nabstract class PostEvent extends Equatable {}\n\nclass PostsFetched extends PostEvent {\n  @override\n  List<Object?> get props => [];\n}\n\nclass PostsNextPage extends PostEvent {\n  @override\n  List<Object?> get props => [];\n}\n")),(0,o.kt)("h3",{id:"bloc-state"},"Bloc state"),(0,o.kt)("p",null,"The bloc state consists of the current list of posts to show, whether the infinite query has any more pages and the current status of the requests."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"enum PostStatus { loading, initial, success }\n\nclass PostState extends Equatable {\n  final PostStatus status;\n  final List<PostModel>? posts;\n  final bool hasReachedMax;\n\n  const PostState({\n    this.status = PostStatus.initial,\n    this.posts,\n    this.hasReachedMax = false,\n  });\n\n  @override\n  List<Object?> get props => [posts, status, hasReachedMax];\n\n  PostState copyWith({\n    PostStatus? status,\n    List<PostModel>? posts,\n    bool? hasReachedMax,\n    bool? isMutationLoading,\n  }) {\n    return PostState(\n      status: status ?? this.status,\n      posts: posts ?? this.posts,\n      hasReachedMax: hasReachedMax ?? this.hasReachedMax,\n    );\n  }\n}\n")),(0,o.kt)("h3",{id:"the-bloc"},"The Bloc"),(0,o.kt)("p",null,"We use Flutter Blocs ",(0,o.kt)("inlineCode",{parentName:"p"},"emit.forEach")," to manage the stream subscription for us. Any time data is emitted from the infinite query then ",(0,o.kt)("inlineCode",{parentName:"p"},"onData")," will be called. In side ",(0,o.kt)("inlineCode",{parentName:"p"},"onData")," we map the incoming infinite query state to a bloc state."),(0,o.kt)("admonition",{type:"info"},(0,o.kt)("p",{parentName:"admonition"},"As the event ",(0,o.kt)("inlineCode",{parentName:"p"},"PostsFetched")," can be called multiple times, it is important to add the ",(0,o.kt)("inlineCode",{parentName:"p"},"restartable")," event transformer from ",(0,o.kt)("a",{parentName:"p",href:"https://pub.dev/packages/bloc_concurrency"},"Bloc Concurrency"),". This will make sure there can only be one listener added to the infinite query at a time.")),(0,o.kt)("p",null,"To get the next page we just get the infinite query from the repository and call ",(0,o.kt)("inlineCode",{parentName:"p"},"getNextPage")," any state updates will be reflected in the bloc because we are listening to the infinite query stream."),(0,o.kt)("admonition",{type:"note"},(0,o.kt)("p",{parentName:"admonition"},"Notice there is no event transformer or throttle on the ",(0,o.kt)("inlineCode",{parentName:"p"},"getNextPage")," event. This is not needed as called to ",(0,o.kt)("inlineCode",{parentName:"p"},"getNextPage")," are de-duplicated so only one can happen at a time.")),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class PostBloc extends Bloc<PostEvent, PostState> {\n  final _repo = PostRepository();\n\n  PostBloc() : super(const PostState()) {\n    // use restartable\n    on<PostsFetched>(_onPostsFetched, transformer: restartable());\n    on<PostsNextPage>(_onPostsNextPage);\n  }\n\n  FutureOr<void> _onPostsFetched(\n    PostsFetched event,\n    Emitter<PostState> emit,\n  ) {\n    final query = _repo.getPosts();\n    // Subscribe to the stream from the infinite query.\n    return emit.forEach<InfiniteQueryState<List<PostModel>>>(\n      query.stream,\n      onData: (queryState) {\n        return state.copyWith(\n          posts: queryState.data?.expand((page) => page).toList() ?? [],\n          status: queryState.status == QueryStatus.loading\n              ? PostStatus.loading\n              : PostStatus.success,\n          hasReachedMax: queryState.hasReachedMax,\n        );\n      },\n    );\n  }\n\n  void _onPostsNextPage(PostEvent _, Emitter<PostState> __) {\n    // No need to store the query in a variable as calling getPosts() again will\n    // retrieve the same instance of infinite query.\n    _repo.getPosts().getNextPage();\n  }\n}\n")),(0,o.kt)("h3",{id:"the-ui"},"The UI"),(0,o.kt)("p",null,"In order to take advantage of re-fetch on connection and re-fetching when the app comes back into view we need to configure Cached Query Flutter. "),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"void main() async {\n  WidgetsFlutterBinding.ensureInitialized();\n\n  CachedQuery.instance\n      .configFlutter(refetchOnResume: true, refetchOnConnection: true);\n\n  runApp(const MyApp());\n}\n\nclass MyApp extends StatelessWidget {\n  const MyApp({super.key});\n\n  // This widget is the root of your application.\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      title: 'Flutter Demo',\n      routes: {\n        PostListPage.routeName: (_) => const PostListPage(),\n        PostListWithBuilderPage.routeName: (_) =>\n            const PostListWithBuilderPage(),\n      },\n    );\n  }\n}\n")),(0,o.kt)("h4",{id:"post-widget"},"Post Widget"),(0,o.kt)("p",null,"The post component will very simply display each posts data. "),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},'class Post extends StatelessWidget {\n  final PostModel post;\n\n  const Post({Key? key, required this.post}) : super(key: key);\n\n  @override\n  Widget build(BuildContext context) {\n    return Container(\n      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),\n      decoration: const BoxDecoration(\n        border: Border(bottom: BorderSide(color: Colors.black12)),\n      ),\n      child: Row(\n        children: [\n          Padding(\n            padding: const EdgeInsets.only(right: 8.0),\n            child: Text("id:${post.id.toString()}"),\n          ),\n          Expanded(\n            child: Column(\n              crossAxisAlignment: CrossAxisAlignment.start,\n              children: [\n                Text(\n                  post.title,\n                  style: Theme.of(context).textTheme.headline6,\n                ),\n                Text(post.body),\n              ],\n            ),\n          ),\n        ],\n      ),\n    );\n  }\n}\n')),(0,o.kt)("h4",{id:"post-list-page"},"Post List Page"),(0,o.kt)("p",null,"The post list page is responsible for displaying the posts and keep track of the scroll position. I displays a loading icon in the app bar whenever the post bloc status is loading."),(0,o.kt)("admonition",{type:"tip"},(0,o.kt)("p",{parentName:"admonition"},"Scope the bloc to a certain section of the UI. This will mean that when the page is removed from the widget tree the listener on the infinite query will also be removed.")),(0,o.kt)("p",null,"When the list scrolls to 90% of the screen the next page event will be added to the bloc. All of these calls will be de-duplicated so there is no need to throttle this call."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class PostListPage extends StatelessWidget {\n  static const routeName = '/';\n  const PostListPage({Key? key}) : super(key: key);\n\n  @override\n  Widget build(BuildContext context) {\n    return BlocProvider(\n      create: (context) => PostBloc(),\n      child: Scaffold(\n        appBar: AppBar(\n          title: BlocBuilder<PostBloc, PostState>(\n            builder: (context, state) {\n              return SizedBox(\n                width: 150,\n                child: Stack(\n                  children: [\n                    if (state.status == PostStatus.loading)\n                      const Align(\n                        alignment: Alignment.centerLeft,\n                        child: SizedBox(\n                          height: 20,\n                          width: 20,\n                          child: CircularProgressIndicator(\n                            valueColor:\n                                AlwaysStoppedAnimation<Color>(Colors.white),\n                          ),\n                        ),\n                      ),\n                    const Center(child: Text('Posts')),\n                  ],\n                ),\n              );\n            },\n          ),\n        ),\n        body: const _List(),\n      ),\n    );\n  }\n}\n\nclass _List extends StatefulWidget {\n  const _List();\n\n  @override\n  State<_List> createState() => _ListState();\n}\n\nclass _ListState extends State<_List> {\n  final _scrollController = ScrollController();\n\n  @override\n  void initState() {\n    super.initState();\n    _scrollController.addListener(_onScroll);\n    context.read<PostBloc>().add(PostsFetched());\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    return BlocBuilder<PostBloc, PostState>(\n      builder: (context, state) {\n        final posts = state.posts;\n        if (posts != null) {\n          return ListView.builder(\n            controller: _scrollController,\n            itemCount:\n                !state.hasReachedMax && state.status == PostStatus.loading\n                    ? posts.length + 1\n                    : posts.length,\n            itemBuilder: (context, i) {\n              if (i < posts.length) {\n                return Post(post: posts[i]);\n              }\n              return const Center(\n                child: SizedBox(\n                  height: 40,\n                  width: 40,\n                  child: CircularProgressIndicator(),\n                ),\n              );\n            },\n          );\n        }\n        if (state.status == PostStatus.loading) {\n          return const Center(\n            child: SizedBox(\n              height: 40,\n              width: 40,\n              child: CircularProgressIndicator(),\n            ),\n          );\n        }\n        return const Text(\"no posts found\");\n      },\n    );\n  }\n\n  void _onScroll() {\n    if (_isBottom) context.read<PostBloc>().add(PostsNextPage());\n  }\n\n  bool get _isBottom {\n    if (!_scrollController.hasClients) return false;\n    final maxScroll = _scrollController.position.maxScrollExtent;\n    final currentScroll = _scrollController.offset;\n    return currentScroll >= (maxScroll * 0.9);\n  }\n\n  @override\n  void dispose() {\n    _scrollController\n      ..removeListener(_onScroll)\n      ..dispose();\n    super.dispose();\n  }\n}\n")),(0,o.kt)("h2",{id:"adding-the-intinitequerybuilder"},"Adding the IntiniteQueryBuilder"),(0,o.kt)("p",null,"For better cache management it is a good idea to use the ",(0,o.kt)("inlineCode",{parentName:"p"},"InfiniteQueryBuilder"),". When the builder is removed from the widget tree the listener to the cache will be removed immediately. Unlike listening to the query in the bloc where the listener will only be removed when the bloc is removed from the tree."),(0,o.kt)("h3",{id:"events"},"Events"),(0,o.kt)("p",null,"There are the same two events here. One to fetch the initial list and one to get the next page."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"@immutable\nabstract class PostWithBuilderEvent {}\n\nclass PostsWithBuilderFetched extends PostWithBuilderEvent {}\n\nclass PostsWithBuilderNextPage extends PostWithBuilderEvent {}\n")),(0,o.kt)("h2",{id:"state"},"State"),(0,o.kt)("p",null,"The state is simpler when using the query builder. The success state only needs to hold the ",(0,o.kt)("inlineCode",{parentName:"p"},"InfiniteQuery")," itself."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"abstract class PostWithBuilderState extends Equatable {}\n\nclass PostWithBuilderInitial extends PostWithBuilderState {\n  @override\n  List<Object?> get props => [];\n}\n\nclass PostWithBuilderSuccess extends PostWithBuilderState {\n  final InfiniteQuery<List<PostModel>, int> postQuery;\n\n  PostWithBuilderSuccess({required this.postQuery});\n\n  @override\n  List<Object?> get props => [postQuery];\n}\n")),(0,o.kt)("h3",{id:"the-bloc-1"},"The Bloc"),(0,o.kt)("p",null,"The bloc is also simpler as its only responsible is to stream the infinite query directly to the UI."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class PostWithBuilderBloc extends Bloc<PostWithBuilderEvent, PostWithBuilderState> {\n  final _repo = PostRepository();\n\n  PostWithBuilderBloc() : super(PostWithBuilderInitial()) {\n    on<PostsWithBuilderFetched>(_onPostsFetched);\n    on<PostsWithBuilderNextPage>(_onPostsNextPage);\n  }\n\n  FutureOr<void> _onPostsFetched(\n    PostsWithBuilderFetched _,\n    Emitter<PostWithBuilderState> emit,\n  ) {\n    final query = _repo.getPosts();\n    emit(PostWithBuilderSuccess(postQuery: query));\n  }\n\n  void _onPostsNextPage(\n    PostWithBuilderEvent _,\n    Emitter<PostWithBuilderState> __\n  ) {\n    // No need to store the query in a variable as calling getPosts() again will\n    // retrieve the same instance of infinite query.\n    _repo.getPosts().getNextPage();\n  }\n}\n")),(0,o.kt)("h3",{id:"the-ui-1"},"The UI"),(0,o.kt)("p",null,"The UI with the build is must the same as with the bloc builder. "),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"class PostListWithBuilderPage extends StatelessWidget {\n  static const routeName = 'postWithBuilderList';\n  const PostListWithBuilderPage({Key? key}) : super(key: key);\n\n  @override\n  Widget build(BuildContext context) {\n    return BlocProvider(\n      create: (_) => PostWithBuilderBloc()..add(PostsWithBuilderFetched()),\n      child: Scaffold(\n        appBar: AppBar(\n          title: const Text(\"Posts With Builder\"),\n          actions: [\n            IconButton(\n              icon: const Icon(Icons.arrow_right_alt),\n              onPressed: () => Navigator.pushReplacementNamed(\n                context,\n                PostListPage.routeName,\n              ),\n            )\n          ],\n        ),\n        body: const _List(),\n      ),\n    );\n  }\n}\n")),(0,o.kt)("p",null,"The List component this time uses a custom scroll view so that other loading widgets and information banners can be displayed in the list."),(0,o.kt)("p",null,"We pass the infinite query from the bloc state to the Infinite Query Builder. The builder will then call the builder function whenever a new ",(0,o.kt)("inlineCode",{parentName:"p"},"InfiniteQueryState")," is emitted down the query stream."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},'class _List extends StatefulWidget {\n  const _List();\n\n  @override\n  State<_List> createState() => _ListState();\n}\n\nclass _ListState extends State<_List> {\n  final _scrollController = ScrollController();\n\n  @override\n  void initState() {\n    super.initState();\n    _scrollController.addListener(_onScroll);\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    return BlocBuilder<PostWithBuilderBloc, PostWithBuilderState>(\n      builder: (context, state) {\n        if (state is PostWithBuilderSuccess) {\n          return InfiniteQueryBuilder<List<PostModel>, int>(\n            query: state.postQuery,\n            builder: (context, state, query) {\n              if (state.data != null && state.data!.isNotEmpty) {\n                final allPosts = state.data!.expand((e) => e).toList();\n                return CustomScrollView(\n                  controller: _scrollController,\n                  slivers: [\n                    if (state.status == QueryStatus.error &&\n                        state.error is SocketException)\n                      SliverToBoxAdapter(\n                        child: DecoratedBox(\n                          decoration: BoxDecoration(\n                              color: Theme.of(context).errorColor),\n                          child: const Text(\n                            "No internet connection",\n                            style: TextStyle(color: Colors.white),\n                            textAlign: TextAlign.center,\n                          ),\n                        ),\n                      ),\n                    SliverList(\n                      delegate: SliverChildBuilderDelegate(\n                        (context, i) => Post(post: allPosts[i]),\n                        childCount: allPosts.length,\n                      ),\n                    ),\n                    if (state.status == QueryStatus.loading)\n                      const SliverToBoxAdapter(\n                        child: Center(\n                          child: SizedBox(\n                            height: 40,\n                            width: 40,\n                            child: CircularProgressIndicator(),\n                          ),\n                        ),\n                      ),\n                    SliverPadding(\n                      padding: EdgeInsets.only(\n                        bottom: MediaQuery.of(context).padding.bottom,\n                      ),\n                    )\n                  ],\n                );\n              }\n              if (state.status == QueryStatus.loading) {\n                return const Center(\n                  child: SizedBox(\n                    height: 40,\n                    width: 40,\n                    child: CircularProgressIndicator(),\n                  ),\n                );\n              }\n              return const Text("no posts found");\n            },\n          );\n        }\n        return const Text("No query");\n      },\n    );\n  }\n\n  void _onScroll() {\n    if (_isBottom) {\n      context.read<PostWithBuilderBloc>().add(PostsWithBuilderNextPage());\n    }\n  }\n\n  bool get _isBottom {\n    if (!_scrollController.hasClients) return false;\n    final maxScroll = _scrollController.position.maxScrollExtent;\n    final currentScroll = _scrollController.offset;\n    return currentScroll >= (maxScroll * 0.9);\n  }\n\n  @override\n  void dispose() {\n    _scrollController\n      ..removeListener(_onScroll)\n      ..dispose();\n    super.dispose();\n  }\n}\n')),(0,o.kt)("h2",{id:"wrap-up"},"Wrap up"),(0,o.kt)("p",null,"We have shown two examples of how an infinite list can be cached using Cached Query and Flutter Bloc together. The same integration techniques could easily be transferable to other state management options."),(0,o.kt)("p",null,"It is up to you which method of integration is best for your app and architecture."))}u.isMDXComponent=!0}}]);