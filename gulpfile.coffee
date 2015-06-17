del = require 'del'
gulp = require 'gulp'
gutil = require 'gulp-util'
connect = require 'gulp-connect'
sass = require 'gulp-sass'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
filter = require 'gulp-filter'
order = require 'gulp-order'
mainBowerFiles = require 'main-bower-files'

# Config
sources =
  styles: 'src/styles/**/*.scss'
  scripts: 'src/app/**/*.coffee'
  html: 'src/index.html'
  favicon: 'src/img/favicon.png'
  img: 'src/img/**/*.png'
  data: 'src/data/**/*.csv'

destinations =
  styles: 'dist/styles'
  scripts: 'dist/scripts'
  html: 'dist'
  favicon: 'dist'
  img: 'dist/img'
  data: 'dist/data'

vendors = mainBowerFiles()

# Tasks
gulp.task 'clean', ->
  del 'dist'
  return

gulp.task 'connect', ->
  connect.server
    root: 'dist'
    livereload: true
  return

gulp.task 'favicon', ->
  gulp.src sources.favicon
  .pipe gulp.dest destinations.favicon
  return

gulp.task 'img', ->
  gulp.src sources.img
  .pipe gulp.dest destinations.img
  return

gulp.task 'data', ->
  gulp.src sources.data
  .pipe gulp.dest destinations.data
  return

gulp.task 'styles', ->
  gulp.src sources.styles
  .pipe sass {outputStyle: 'compressed', errLogToConsole: true}
  .pipe concat 'app.css'
  .pipe gulp.dest destinations.styles
  .pipe connect.reload()
  return

gulp.task 'scripts', ->
  gulp.src sources.scripts
  .pipe coffee {bare: true}
  .on 'error', gutil.log
  .pipe concat 'app.js'
  .pipe gulp.dest destinations.scripts
  .pipe connect.reload()
  return

gulp.task 'scripts:vendor', ->
  gulp.src vendors
  .pipe filter '*.js'
  .pipe order vendors
  .pipe concat 'vendor.js'
  .pipe uglify()
  .pipe gulp.dest destinations.scripts
  return

gulp.task 'html', ->
  gulp.src sources.html
  .pipe gulp.dest destinations.html
  .pipe connect.reload()
  return

gulp.task 'watch', ->
  gulp.watch sources.styles, ['styles']
  gulp.watch sources.html, ['html']
  gulp.watch sources.scripts, ['scripts']
  return

gulp.task 'build', ['styles', 'scripts', 'html']
gulp.task 'clean-build', ['clean', 'favicon', 'img', 'data', 'scripts:vendor', 'build']
gulp.task 'dev', ['build', 'watch', 'connect']
