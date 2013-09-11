# Starting Blocks

## Installation

Install it yourself with:

    $ gem install starting_blocks

If you would like to use a blinky light to show the results of your test:

    $ gem install starting_blocks-blinky

If you would like growl results of your tests:

    $ gem install starting_blocks-growl

## Usage

Current command-line options:

````
sb
````

Will run all MiniTest specs in your current directory and all child directories.

````
sb --watch
````

Will run all MiniTest specs if they or similarly named files are edited.

````
sb --blinky
````

Will turn your blinky light red/yellow/green based on the results of your test run.

````
sb --growl
````

Will pop a growl message based on the test results.


