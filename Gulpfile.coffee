require 'coffee-script/register'

gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
gutil   = require 'gulp-util'
jasmine = require 'gulp-jasmine'
watch   = require 'gulp-watch'

browserify = require 'browserify'
uglify     = require 'gulp-uglify'
rename     = require 'gulp-rename'
streamify  = require 'gulp-streamify'
source     = require 'vinyl-source-stream'
concat     = require 'gulp-concat'

gulp.task 'build', ['spec'], ->
  b = browserify({detectGlobals: true})
  b.require('buffer')
  b.require('frisby')
  b.transform('brfs')

  return b.bundle()
    .pipe(source('index.js'))
    .pipe(rename('bundle.min.js'))
    .pipe(streamify(uglify()))
    .pipe(gulp.dest('./public/lib'))

gulp.task 'spec', ->
  gulp.src('./spec/*.coffee')
    .pipe(coffee(bare: true).on('error', gutil.log))
    .pipe(concat('spec.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./public/lib'))

gulp.task 'test', ->
  gulp.src('./spec/*.coffee').pipe(jasmine(verbose: true))
