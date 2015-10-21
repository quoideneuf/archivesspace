// Karma configuration
// Generated on Mon Oct 19 2015 19:48:44 GMT-0400 (EDT)

module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '../',


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine'],


    // list of files / patterns to load in the browser
    files: [
      // we need to load jquery like this since
      // ASpace gets it as a rails gem :/
      'jasmine/patches.js',
      'node_modules/jquery/dist/jquery.js',
      'node_modules/jasmine-jquery/lib/jasmine-jquery.js',
      'node_modules/jquery-ui/ui/core.js',
      'node_modules/jquery-ui/ui/widget.js',
      'node_modules/jquery-ui/ui/effect.js',
      'node_modules/jquery-ui/ui/mouse.js',
      'node_modules/jquery-ui/ui/*.js',
      'vendor/assets/javascripts/jquery.browser.js',
      'vendor/assets/javascripts/bootstrap/tooltip.js',
      'vendor/assets/javascripts/bootstrap/*.js',
      'vendor/assets/javascripts/codemirror/**/*.js',
      'vendor/assets/javascripts/*.js',
      'app/assets/javascripts/utils.js',
      'app/assets/javascripts/*.js',
      'app/assets/javascripts/*.js.erb',
      'jasmine/*.js',

      {
        pattern: 'jasmine/fixtures/*.html',
        watched: false,
        included: false,
        served: true
      },
      {
        pattern: 'jasmine/fixtures/*',
        watched: false,
        included: false,
        served: true
      },
    ],


    // list of files to exclude
    exclude: [
      'app/assets/javascripts/bootstrap_overrides.js',
      'vendor/assets/javascripts/codemirror/util/*-standalone.js',
      'app/assets/javascripts/preferences.js'
    ],


    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
    },


    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: false,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['Firefox'],
    // browsers: ['PhantomJS2'],

    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false
  })
}
