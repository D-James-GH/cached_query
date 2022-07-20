<script lang="ts">
	import SideBar from '$components/SideBar.svelte';
	import Navbar from '$lib/components/Navbar.svelte';
	import '../app.css';
	import 'prismjs';
	import 'prismjs/themes/prism.min.css';

	let sidebarOpen = false;
	function toggleMenu() {
		sidebarOpen = !sidebarOpen;
	}
</script>

<div class="flex h-screen flex-col">
	<Navbar {toggleMenu} />
	<div class="flex h-full">
		<SideBar open={sidebarOpen} />
		<section class="flex flex-col">
			<main class="flex-1">
				<slot />
			</main>
			<footer class="flex-none">I am a footer</footer>
		</section>
	</div>
</div>
