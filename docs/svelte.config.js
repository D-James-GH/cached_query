import adapter from '@sveltejs/adapter-auto';
import preprocess from 'svelte-preprocess';
import { mdsvex } from 'mdsvex';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: [
		preprocess({
			postcss: true
		}),
		mdsvex({
			extensions: ['.md', '.svx']
		})
	],
	extensions: ['.svelte', '.md'],
	kit: {
		adapter: adapter(),
		alias: {
			$components: 'src/lib/components'
		},
		files: {
			lib: 'src/lib'
		}
	}
};

export default config;
