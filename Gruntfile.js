module.exports = function(grunt) {

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

    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    
    // Default task(s).
    grunt.registerTask('default', ['watch']);
};