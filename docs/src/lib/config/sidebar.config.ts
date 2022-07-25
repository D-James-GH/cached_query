export type Link = {
	title: string;
	slug: string;
	children?: ReadonlyArray<Link>;
};
export const config: ReadonlyArray<Link> = [
	{
		title: 'Getting Started',
		slug: 'getting-started',
		children: [
			{
				title: 'Introduction',
				slug: 'introduction'
			},
			{
				title: 'Quick Start',
				slug: 'quick-start'
			}
		]
	},
	{
		title: 'Tutorials',
		slug: 'tutorials',
		children: [{ slug: 'basic', title: 'Basic' }]
	}
];
