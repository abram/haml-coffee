path = require 'path'

module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    regarde:
      jasmine_node:
        files: [
          'src/**/*.coffee'
          'spec/*.coffee'
          'spec/**/*.json'
          'spec/**/*.haml'
          'spec/**/*.html'
        ]
        tasks: ['jasmine_node']
        spawn: true
    jasmine_node:
      specNameMatcher: '_spec'
      extensions: 'coffee'
      projectRoot: '.'
    replace:
      version:
        src: ['dist/compiler/hamlcoffee.js']
        dest: 'dist/compiler/hamlcoffee.js'
        replacements: [
          {
            from: "require('../package.json').version"
            to: "'<%= pkg.version %>'"
          }
        ]
      changelog:
        src: ['CHANGELOG.md']
        dest: 'CHANGELOG.md'
        replacements: [
          {
          from: "## Master"
          to: "## Version <%= pkg.version %>, <%= grunt.template.today('mmmm dd, yyyy') %>"
          }
        ]
    uglify:
      dist:
        files:
          'dist/compiler/hamlcoffee.min.js': ['dist/compiler/hamlcoffee.js']
    shell:
      commit:
        command: "git commit package.json CHANGELOG.md dist/compiler/hamlcoffee.js dist/compiler/hamlcoffee.min.js -m 'Release <%= pkg.version %>'"
      tag:
        command: "git tag v<%= pkg.version %>"
      push:
        command: "git push --tags origin master"
      publish:
        command: "npm publish"

    browserify:
      dist:
        files:
          'dist/compiler/hamlcoffee.js': ['src/haml-coffee.coffee', 'src/hamlc.coffee'],
        options:
          transform: ['coffeeify']

  grunt.registerTask 'watch', [
    'regarde'
  ]

  grunt.registerTask 'test', [
    'jasmine_node'
  ]

  grunt.registerTask 'dist', 'Create the browser distribution', [
    'browserify'
    'replace:version'
    'uglify:dist'
  ]

  grunt.registerTask 'publish', 'Publish a new version', [
    'jasmine_node'
    'dist'
    'replace:changelog'
    'shell:commit'
    'shell:tag'
    'shell:push'
    'shell:publish'
  ]

  grunt.registerTask 'default', ['watch']
