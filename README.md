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

<a id="installation"></a>

## Installation

- Clone this repo, then build for your device using Xcode.
- Load the following sketch on your Bluno, from [here](https://github.com/ipatch/KegCop/blob/master/KegCop-Bluno-sketch.c)

cheers 🍻

[@ipatch](https://github.com/ipatch)
[@truckmonth](https://twitter.com/truckmonth)<br />
