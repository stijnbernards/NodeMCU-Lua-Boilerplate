const gulp = require("gulp");
const luacheck = require("gulp-luacheck");
const prettier = require('gulp-prettier');

const source = 'src/**/*.lua';

gulp.task('format', () => {
    return gulp.src(source)
        .pipe(prettier())
        .pipe(gulp.dest('./src'));
});

gulp.task('luacheck', function() {
    return gulp
        .src(source)
        .pipe(luacheck())
        .pipe(luacheck.reporter('stylish'))
});

gulp.task('validate', () => {
    return gulp.src(source)
        .pipe(prettier.check());
});

