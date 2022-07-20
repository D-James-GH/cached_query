<script lang="ts">
	import SideBarLink from './SideBarLink.svelte';
	import { config } from '$lib/config/sidebar.config';
	export let open = false;
</script>

<aside
	class={`${
		open ? 'translate-x-0' : '-translate-x-64'
	} fixed z-10 h-full w-64  border-r border-gray-500   transition-transform duration-200  md:relative md:translate-x-0`}
	aria-label="Sidebar"
>
	<div class="h-full overflow-y-auto bg-base-100 py-4 px-3">
		<ul class="space-y-2">
			{#each config as link}
				<SideBarLink {link} />
			{/each}
		</ul>
	</div>
</aside>
