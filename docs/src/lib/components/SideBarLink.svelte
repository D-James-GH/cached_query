<script lang="ts">
	import Icon from './Icon.svelte';
	import { slide } from 'svelte/transition';
	import type { Link } from '$lib/config/sidebar.config';

	export let link: Link;
	export let baseUrl: string | undefined = '';

	let open = false;
	let linkClass =
		'w-full flex items-center px-2 py-1 text-base font-normal  rounded-lg  hover:bg-gray-100 dark:hover:bg-gray-700';

	function handleOpen() {
		open = !open;
	}
</script>

<li class="my-1">
	{#if link.children}
		<button
			class={linkClass}
			on:click={handleOpen}
			class:dark:bg-gray-700={open}
			class:bg-gray-100={open}
		>
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
		<a class={linkClass} href={`${baseUrl}/${link.slug}`}>
			{link.title}
		</a>
	{/if}
</li>
