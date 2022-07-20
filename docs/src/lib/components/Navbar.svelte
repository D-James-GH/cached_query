<script lang="ts">
	import Icon from './Icon.svelte';
	export let toggleMenu: () => void;
</script>

<nav class="flex w-screen border-b border-gray-500 px-2  py-2">
	<button on:click={toggleMenu} class="btn btn-ghost  md:hidden">
		<Icon
			name="menu"
			class="h-14 w-14 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white"
			height="30px"
			width="30px"
		/>
	</button>

	<a href="/" class="btn btn-ghost text-lg capitalize">Cached Query</a>
	<a
		href="https://github.com/D-James-GH/cached_query/tree/main/packages/cached_query"
		class="btn btn-ghost ml-auto"
	>
		<Icon name="github" width="20" height="20" />
	</a>
</nav>
