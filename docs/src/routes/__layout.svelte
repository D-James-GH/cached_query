<script lang="ts">
	import SideBar from '$components/SideBar.svelte';
	import Navbar from '$lib/components/Navbar.svelte';
	import '../app.css';

	let sidebarOpen = false;
	function toggleMenu() {
		sidebarOpen = !sidebarOpen;
	}
	
</script>

<div class="flex h-screen flex-col">
	<Navbar {toggleMenu} />
	<div class="flex h-full">
		<SideBar onClose={toggleMenu} open={sidebarOpen} />
		<div class="flex flex-col">
			<main class="prose prose-zinc prose-purple flex-1 px-3 py-6 dark:prose-invert max-w-4xl">
				<slot />
			</main>
		</div>
	</div>
</div>
