module.exports = function(grunt) {

    require('load-grunt-tasks')(grunt, {pattern: 'grunt-*'});

    require('time-grunt')(grunt);

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        coffee: {
            options: {
                sourceMap: true,
                sourceMapDir: 'src/'
            },
            compile: {
                files: {
                    'src/main.js': ['src/coffee/**/*.coffee']
                }
            },
        },
        less: {
            development: {
                options: {
                    paths: ["src/less"]
                },
                files: {
                    "src/main.css": "src/less/main.less"
                }
            }
        },
        watch: {
            files: ['src/less/**/*', 'src/coffee/**/*.coffee'],
            tasks: ['less', 'coffee'],
            options: {
                nospawn: true,
                livereload: true,
                atBegin: true
            }
        }
    });

    // Default task(s).
    grunt.registerTask('default', ['coffee', 'less']);
    grunt.registerTask('track', ['watch']);
};