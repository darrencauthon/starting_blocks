# Starting Blocks

## Installation

Install it yourself with:

    $ gem install starting_blocks

If you would like to use a blinky light to show the results of your tests:

    $ gem install starting_blocks-blinky

If you would like growl results of your tests:

    $ gem install starting_blocks-growl

## Usage

Run all of your Minitest tests and specs in your current directory and all child directories:

````
sb
````

Run the tests in any test or spec file after it is saved. Will also run the specs for any file that has a matching test or spec file:

````
sb --watch
````

Turn your blinky light red/yellow/green based on the results of your test run:

````
sb --blinky
````

Pop a growl message based on the test results:

````
sb --growl
````



