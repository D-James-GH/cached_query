<script lang="ts">
	import feather from 'feather-icons';
	export const directions = ['n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw'];
	export let name: string;
	export let direction: typeof directions[number] = 'n';
	export let strokeWidth: string | undefined = undefined;
	export let stroke: string | undefined = undefined;
	export let width: string | undefined = '1em';
	export let height: string | undefined = '1em';
	export { className as class };
	let className: string = '';

	$: icon = feather.icons[name];
	$: rotation = directions.indexOf(direction) * 45;
	$: if (icon) {
		if (stroke) icon.attrs['stroke'] = stroke;
		if (strokeWidth) icon.attrs['stroke-width'] = strokeWidth;
	}
</script>

{#if icon}
	<svg
		{...icon.attrs}
		class={`${
			className || ''
		} h-14 w-14 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white`}
		style="width: {width}; height: {height}; transform: rotate({rotation}deg);"
	>
		<g>
			{@html icon.contents}
		</g>
	</svg>
{/if}

<style>
	svg {
		width: 1em;
		height: 1em;
		overflow: visible;
		transform-origin: 50% 50%;
	}
</style>
