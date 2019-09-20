<div align="center">

## GitHub Pages source directory

</div>

<div align="center">

•[TODOs](#todos)•

</div>

The contents of [branch](https://github.com/ipatch/KegCop/tree/gh-pages) are the ~~soon to be source~~ for [ipatch.github.io/KegCop](https://ipatch.github.io/KegCop)

#### Disclaimer

❗️ The source code is branch is completely separate from the source contained within the [master](https://github.com/ipatch/KegCop/tree/master) branch, and should remain separate, ie. changes from this branch **should not** be merged into any other branch contained within this git repo, as this branch is only here to serve a [gh-pages](https://pages.github.com/) website hosted by GitHub. The compiled version of this source can be viewed at [ipatch.github.io/KegCop](https://ipatch.github.io/KegCop)

The site is rather primitive right now, but uses webpack to generate a bundle and inject the bundle into a div within the **index.html**.

The compiled / bundled production build for [ipatch.github.io/KegCop](https://ipatch.github.io/KegCop) is located within the [docs](https://github.com/ipatch/KegCop/tree/master/docs) directory of the [master](https://github.com/ipatch/KegCop/tree/master) branch.

<a id="todos"></a>

## TODOs

- [ ] add SVG graphic using an **svg tag** as opposed to using a **img tag**
- [ ] remove Google Analytics from **./src/index.html** and into its own js module that can be _required_ or _imported_ into **index.js**
- [x] ~~setup a webpack loader for generating favicons~~
- [x] ~~add a bundle analyzer for measuring performance of different bundles and webpack settings.~~
- [x] ~~setup a **development** and **production** configuration files for Webpack~~
- [ ] figure out how to properly add a div to the DOM without hijacking the global **img** tag for the document.
