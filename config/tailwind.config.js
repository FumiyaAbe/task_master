module.exports = {
  content: [
    "./app/views/**/*.erb",
    "./app/views/**/*.turbo_stream.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {
      colors: {
        base:   "#F9FAFB",
        main:   "#1D4E89",
        accent: "#2563EB",
      },
    },
  },
  plugins: [],
}
