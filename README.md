# KegCop

[![Wilson demos KegCop](http://img.youtube.com/vi/1a6hxUb3zfU/0.jpg)](http://www.youtube.com/watch?v=1a6hxUb3zfU)

<!-- ![KegCop-splash](http://chrisrjones.com/pics/KegCop-git.png) -->

## Objective
The purpose of this software is to create user accounts for a kegerator, and have a root account which recieves donations from the users for the beer they drink.  To find out more information about the project check out the [wiki](https://github.com/ipatch/KegCop/wiki)

## How does it work?
An iOS device, i.e. iPhone / iPod Touch will connect to a Bluno via Bluetooth 4.0 Low Energy sending serial information to the microcontroller which will communicate with flow sensor(s) and a solenoid cut off valve.  The iOS device will be the user interface for the entire operation, storing account information along with how many credits a particular user will have.

## Build
As of 31OCT14, this project is built with Xcode 6.1 using OS X (10.9.5) with a target for iOS 7.x and greater.

## License and Copyright
All code is offered under the GPLv2 license, unless otherwise noted.  Please see LICENSE.txt for
the full license.  All code and documentation are Copyright 2012 Chris Jones, unless otherwise
noted.

## Contributing
I would love for someone to make a branch and start editing some code.  My Objective-C skills leave
a lot to be desired.  So if you have a great idea, don't hesitate to download the code and
contribute.

## Installation
A binary version of the app can be downloaded if your iDevice is jailbroken.  Add the following
repo: chrisrjones.com/repo and load the following sketch on your Bluno https://gist.github.com/ipatch/8078083
cheers
- Chris
