module.exports = (grunt) ->
  'use strict'
  grunt.initConfig
    grunticon:
      icons:
        files: [
          expand: true,
          cwd: 'masters/icons',
          src: ['*.svg', '*.png'],
          dest: 'app/assets/icons'
        ]
        options:
          datasvgcss: "icons.data.svg.css"
          datapngcss: "icons.data.png.css"
          urlpngcss: "icons.fallback.css"
          cssprefix: '.m-icon-'
          customselectors:
           "chevron-right": [".breadcrumbs li"]
           "caret-down-0": [".box-menu .dropdown-toggle"]
           "todo-0": [".act-now a::before"]
           "search": ["#masthead-search::before"]
          cssbasepath: '/'
          # defaultWidth: '300px',
          # defaultHeight: '200px',

  grunt.loadNpmTasks('grunt-grunticon')
  grunt.registerTask('default', ['grunticon:icons'])
