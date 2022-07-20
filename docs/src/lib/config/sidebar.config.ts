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
				title: 'Installation',
				slug: 'installation'
			},
			{
				title: 'Basic Setup',
				slug: 'basic-setup'
			}
		]
	},
	{
		title: 'Tutorials',
		slug: 'tutorials',
		children: [{ slug: 'basic', title: 'Basic' }]
	}
];
