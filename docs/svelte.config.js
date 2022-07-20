import adapter from '@sveltejs/adapter-auto';
import preprocess from 'svelte-preprocess';
import { markdoc } from 'markdoc-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: [preprocess(), markdoc()],
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
