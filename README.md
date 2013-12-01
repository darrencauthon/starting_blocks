# Starting Blocks

[![Build Status](https://travis-ci.org/darrencauthon/starting_blocks.png?branch=master)](https://travis-ci.org/darrencauthon/starting_blocks)

## Why?

The purpose of this gem is to run my Minitest specs, with no hassle. No Rakefile updates, no Gemfile/gemspec installs, and no regex Guard files.

Just. Run. The. Tests.

Install the gem. Type "sb" in your command line.  All of the tests in your current directory are run. 

## What tests, though?

Starting Blocks runs all files that have a "test" or "spec" prefix or suffix.  Like:

* spec_apple.rb
* apple_spec.rb
* test_orange.rb
* orange_test.rb

It also looks for matches between "non-test" files and spec files.  So if "apple.rb" is updated and "apple_spec.rb" exists, Starting Blocks will run the "apple_spec.rb" tests.


## Usage

Run all of your Minitest tests and specs in your current directory and all child directories:

````
sb
````

Run the tests in any test or spec file after it is saved. Will also run the specs for any file that has a matching test or spec file:

````
sb --watch
````

Turn your [blinky light](https://github.com/perryn/blinky) red/yellow/green based on the results of your test run:

````
sb --blinky
````

Pop a growl message based on the test results:

````
sb --growl
````

Run the tests with all of the options listed above:

````
sb --growl --blinky --watch
````

## Installation

Install it yourself with:

    $ gem install starting_blocks

If you would like to use a [blinky light](https://github.com/perryn/blinky) to show the results of your tests:

    $ gem install starting_blocks-blinky

If you would like growl results of your tests:

    $ gem install starting_blocks-growl
