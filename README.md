<a id="kegcop"></a>

# KegCop [![Build Status](https://travis-ci.org/ipatch/KegCop.svg?branch=master)](https://travis-ci.org/ipatch/KegCop)

[![Wilson demos KegCop](http://img.youtube.com/vi/1a6hxUb3zfU/0.jpg)](http://www.youtube.com/watch?v=1a6hxUb3zfU)

<a id="objective"></a>

## Objective

The purpose of this software is to create user accounts for a kegerator, and have a **_root_** account which recieves donations from the users for the beer they drink.  To find out more information about the project check out the [wiki](https://github.com/ipatch/KegCop/wiki)

<a id="how-does-it-work"></a>

## How does it work

An iOS device, i.e. iPhone / iPod Touch will connect to a Bluno via Bluetooth 4.0 Low Energy sending serial information to the microcontroller which will communicate with flow sensor(s) and a solenoid cut off valve.  The iOS device will be the user interface for the entire operation, storing account information along with how many credits a particular user will have.

<a id="build"></a>

## Build

As of January 17, 2019, I'm building the **KegCop.app** with Xcode Version 10.1 (10B61) to build the app for iOS 9.3.x on an iPod Touch 5th generation model.

> The iPod Touch 5th Gen has the same screen size and specs as iPhone 5 and 5s, which is useful to know when building using the Simulator.

As of Feburary 15, 2018 iOS >= 8.0 is required in order to run KegCop and the preffered build system is Xcode 9.2.

<a id="license-and-copyright"></a>

## License and Copyright

All code is offered under the MIT license, unless otherwise noted.  Please see LICENSE.txt for
the full license.  All code and documentation are Copyright 2015 to present, Chris Jones, unless otherwise
noted.

<a id="contributing"></a>

## Contributing

I would love for someone to make a branch and start editing some code.  My Objective-C skills leave
a lot to be desired.  So if you have a great idea, don't hesitate to download the code and
contribute.  There is a guide for contributing, [here](https://github.com/ipatch/KegCop/wiki/Contribute)

### Contributing > Maintenance

<details>
<summary>Revert from nuclear 🤯 **git** changes</summary>

#### Workaround > git

god forbid‚™️ I **merge** then **push** a branch into master that I did not mean to, perform the below steps

```shell
git reset --hard [tag/branch/commit id]
echo "reset local working branch, ie. [master] to one of the specified fields"
git push [remote(s)] -f
echo "[remote] can be `origin` or `upstream`"
echo "NOTE: the above two step should revert a brach local and remote from nuclear changes"
```

</details>

## Contributing > [Website](http://ipatch.github.io/KegCop/)

```shell
http://ipatch.github.io/KegCop/
```

There is a git branch **gh-pages-src** that contains a node project to build a website using github pages for the aboe listed URL, that branch src does not correlate to the main objc src for the actual iOS app, but only serves a purpose to be the directory / src for the accompanying website.

<a id="installation"></a>

## Installation

- Clone this repo, then build for your device using Xcode.
- Load the following sketch on your Bluno, from [here](https://github.com/ipatch/KegCop/blob/master/KegCop-Bluno-sketch.c)

cheers 🍻

[@ipatch](https://github.com/ipatch)<br />
[@truckmonth](https://twitter.com/truckmonth)
