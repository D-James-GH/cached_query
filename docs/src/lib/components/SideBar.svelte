<script lang="ts">
	import SideBarLink from './SideBarLink.svelte';
	import { config } from '$lib/config/sidebar.config';
	export let open = false;
	export let onClose: () => void;
</script>

<div
	class={`fixed inset-0 z-10 md:translate-x-0 md:relative
    ${
			open
				? 'translate-x-0 '
				: '-translate-x-full transition-all delay-300'
		}
    `}
>
	<aside
		aria-label="Sidebar"
		class={'md:translate-x-0 md:w-72 md:relative md:shadow-none delay-400 absolute z-10 left-0 h-full w-screen max-w-lg bg-base-light shadow-xl transition-all duration-500 ease-in-out  ' +
			(open ? ' translate-x-0 ' : ' -translate-x-full ')}
	>

		<div class="h-full overflow-y-auto bg-base-light py-4 px-3 md:dark:bg-base-dark dark:bg-grey-800">
			<ul class="space-y-2">
				{#each config as link}
					<SideBarLink {link} />
				{/each}
			</ul>
		</div>
	</aside>
  
	<div
		on:click={onClose}
		class={`md:hidden h-full z-0 w-screen cursor-pointer transition-opacity duration-300 overflow-hidden bg-grey-900 bg-opacity-25 ease-in-out ${
			open
				? 'opacity-100'
				: 'opacity-0 '
		}`}
	/>
</div>
