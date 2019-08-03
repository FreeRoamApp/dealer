gulp = require 'gulp'
spawn = require('child_process').spawn

paths =
  serverBin: './bin/server.coffee'
  coffee: [
    './**/*.coffee'
    '!./node_modules/**/*'
  ]


gulp.task 'default', ['dev']

gulp.task 'dev', ['watch:dev']

gulp.task 'watch', ->
  gulp.watch paths.coffee, ['watch:test']

gulp.task 'watch:dev', ['dev:server'], ->
  gulp.watch paths.coffee, ['dev:server']

gulp.task 'dev:server', do ->
  devServer = null
  process.on 'exit', -> devServer?.kill()
  ->
    devServer?.kill()
    devServer = spawn 'coffee', [paths.serverBin], {stdio: 'inherit'}
    devServer.on 'close', (code) ->
      if code is 8
        gulp.log 'Error detected, waiting for changes'
