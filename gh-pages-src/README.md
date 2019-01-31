## GitHub Pages source directory

<div align="center">

•TODOs•

<div>

The contents of this directory

```conf
./KegCop/gh-pages-src
```

contain the source the below website.

```conf
https://ipatch.github.io/KegCop
```

The site is rather primitive right now, but uses webpack to generate a bundle and inject the bundle into a div contained in the **index.html**.

<a id="todos"></a>

## TODOs

- [ ] remove Google Analytics from **./src/index.html** and into its own js module that can be _required_ or _imported_ into **index.js**
- [ ] setup a webpack loader for generating favicons
- [ ] add a bundle analyzer for measuring performance of different bundles and webpack settings.
- [ ] setup a **development** and **production** configuration files for Webpack
- [ ] figure out how to properly add a div to the DOM without hijacking the global **img** tag for the document.
