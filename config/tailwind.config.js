module.exports = {
  content: [
    './app/views/**/*.{erb,html,html.erb,turbo_stream.erb}',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.{js,ts,jsx,tsx}',
  ],
  theme: { extend: { colors: { base:'#F9FAFB', main:'#1D4E89', accent:'#2563EB' } } },
  plugins: [],
}
