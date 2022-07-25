const colors = require('tailwindcss/colors');
/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./src/**/*.{html,js,svelte,ts,css}'],
	theme: {
		colors: {
			'base-dark': colors.zinc[900],
			'base-light': colors.zinc[50],
			grey: colors.zinc
		},
		extend: {
			typography: {
				DEFAULT: {
					css: {
						'code::before': {
							content: '""'
						},
						'code::after': {
							content: '""'
						}
					}
				}
			}
		}
	},
	plugins: [require('@tailwindcss/typography')]
};
