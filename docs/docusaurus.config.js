// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require("prism-react-renderer/themes/github");
const darkCodeTheme = require("prism-react-renderer/themes/oceanicNext");

/** @type {import('@docusaurus/types').Config} */
const config = {
    title: "Cached Query",
    tagline: "Create fast user interfaces with Cached Query and Flutter",
    url: "https://www.cachedquery.dev",
    baseUrl: "/",
    onBrokenLinks: "throw",
    onBrokenMarkdownLinks: "warn",
    favicon: "img/favicon.ico",
    // GitHub pages deployment config.
    // If you aren't using GitHub pages, you don't need these.
    organizationName: "D-James-GH", // Usually your GitHub org/user name.
    projectName: "cached_query", // Usually your repo name.
    trailingSlash: false,

    // Even if you don't use internalization, you can use this field to set useful
    // metadata like html lang. For example, if your site is Chinese, you may want
    // to replace "en" with "zh-Hans".

    i18n: {
        defaultLocale: "en",
        locales: ["en"],
    },


    presets: [
        [
            "classic",
            /** @type {import('@docusaurus/preset-classic').Options} */
            ({
                docs: {
                    routeBasePath: "/",
                    sidebarPath: require.resolve("./sidebars.js"),

                    // Please change this to your repo.
                    // Remove this to remove the "edit this page" links.
                    editUrl: "https://github.com/D-James-GH/cached_query/tree/main/docs",
                },

                blog: false,
                theme: {
                    customCss: require.resolve("./src/css/custom.css"),
                },
            }),
        ],
    ],

    themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
        ({
            algolia: {
                // The application ID provided by Algolia
                appId: "MDO9CERRRH",

                // Public API key: it is safe to commit it
                apiKey: "376a219c65e17b14fb64c68bd8de3915",

                indexName: "cachedquery",

                // Optional: see doc section below
                contextualSearch: true,

                // Optional: Specify domains where the navigation should occur through window.location instead on history.push. Useful when our Algolia config crawls multiple documentation sites and we want to navigate with window.location.href to them.
                externalUrlRegex: "external\\.com|domain\\.com",

                // Optional: Algolia search parameters
                searchParameters: {},

                // Optional: path for search page that enabled by default (`false` to disable it)
                searchPagePath: "search",
            },
            metadata: [
                {
                    name: "keywords",
                    content: "flutter, cached-query, query, cached, http, api, package, android, ios"
                },
            ],
            navbar: {
                title: "Cached Query",
                items: [
                    {
                        type: "doc",
                        docId: "docs/overview",
                        position: "left",
                        label: "Docs",
                    },
                    {
                        type: "doc",
                        docId: "examples/overview",
                        position: "left",
                        label: "Examples",
                    },
                    {
                        href: "https://github.com/D-James-GH/cached_query/tree/main/packages/cached_query",
                        label: "GitHub",
                        position: "right",
                    },
                ],
            },
            footer: {
                style: "dark",
                links: [
                    {
                        label: "Docs",
                        to: "/docs/overview",
                    },
                    {
                        label: "Github",
                        href: "https://github.com/D-James-GH/cached_query/tree/main/packages/cached_query",
                    },
                ],
                copyright: `Copyright © ${new Date().getFullYear()} Cached Query, Inc. Built with Docusaurus.`,
            },
            prism: {
                theme: lightCodeTheme,
                darkTheme: darkCodeTheme,
                additionalLanguages: ["dart"],
            },
        }),
};

module.exports = config;
