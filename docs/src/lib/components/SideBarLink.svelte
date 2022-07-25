<script lang="ts">
	import Icon from './Icon.svelte';
	import { slide } from 'svelte/transition';
	import type { Link } from '$lib/config/sidebar.config';

	export let link: Link;
	export let baseUrl: string | undefined = '';

	let open = false;

	function handleOpen() {
		open = !open;
	}
</script>

<li class="my-1">
	{#if link.children}
		<button on:click={handleOpen} class="link text-color" class:open>
			{link.title}
			<span class="ml-auto transition duration-200" class:rotate-180={open}>
				<Icon name="chevron-down" />
			</span>
		</button>

		{#if open}
			<div transition:slide={{ duration: 500 }} class="ml-3">
				{#each link.children as child}
					<svelte:self link={child} baseUrl={`${baseUrl}/${link.slug}`} />
				{/each}
			</div>
		{/if}
	{:else}
		<a class="link text-color" href={`${baseUrl}/${link.slug}`}>
			{link.title}
		</a>
	{/if}
</li>

<style type="text/postcss">
	.link {
		@apply flex w-full items-center rounded-lg px-2 py-1 font-normal   hover:bg-grey-200  dark:hover:bg-grey-700;
	}
	.open {
		@apply bg-grey-200 dark:bg-grey-700;
	}
</style>
