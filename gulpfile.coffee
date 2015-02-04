path = require 'path'

gulp = require 'gulp'
plumber = require 'gulp-plumber'
mocha = require 'gulp-mocha'
istanbul = require 'gulp-istanbul'
coveralls = require 'gulp-coveralls'


gulp.task 'test', (cb) ->
  mochaErr = null
  
  gulp.src ['index.js', 'lib/**/*.js']
    .pipe istanbul( includeUntested: true )
    .pipe istanbul.hookRequire()
    .on 'finish', ->
      gulp.src 'test/**/*.js'
        .pipe plumber()
        .pipe mocha( reporter: 'spec' )
        .on 'error', (err) ->
          mochaErr = err
        .pipe istanbul.writeReports()
        .on 'end', ->
          console.log 'end'
          cb(mochaErr)
  
  undefined


gulp.task 'coveralls', ['test'], ->
  if process.env.CI
    gulp.src path.join(__dirname, 'coverage/lcov.info')
      .pipe coveralls()


gulp.task 'default', ['test', 'coveralls']