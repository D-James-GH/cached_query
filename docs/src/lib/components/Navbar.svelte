<script lang="ts">
	import Icon from './Icon.svelte';
	export let toggleMenu: () => void;
</script>

<nav class="border-gray-500 flex w-screen items-center border-b px-2 py-2">
	<button on:click={toggleMenu} class="btn md:hidden">
		<Icon name="menu" class="text-color" height="30px" width="30px" />
	</button>

	<a href="/" class="btn text-2xl font-bold">
		Cached Query
	</a>
	<a
		href="https://github.com/D-James-GH/cached_query/tree/main/packages/cached_query"
		class="btn btn-ghost ml-auto"
	>
		<Icon name="github" width="20" height="20" />
	</a>
</nav>
