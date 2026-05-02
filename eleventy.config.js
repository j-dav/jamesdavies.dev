module.exports = (eleventyConfig) => {
	eleventyConfig.amendLibrary('md', (mdLib) => mdLib.set({ breaks: true }));

	// Passthrough copy for static assets
	eleventyConfig.addPassthroughCopy({ public: '/' });
	eleventyConfig.addWatchTarget('./src/styles/global.css');
	eleventyConfig.addPassthroughCopy({ 'src/styles': 'styles' });

	return {
		dir: {
			input: 'src',
			includes: '_includes',
			layouts: '_layouts',
			data: '_data',
			output: 'dist',
		},
		templateFormats: ['njk', 'md', 'html'],
		markdownTemplateEngine: 'njk',
		htmlTemplateEngine: 'njk',
	};
};
