A simple Reverse Polish Notation calculator written in Ruby.

# Installation
This library requires Ruby 2.1 or greater to run.

* Clone the repository
* Run `gem build rpn_calculator.gemspec`. This will create a file called `rpn_calculator-0.0.1.gem`.
* Run `gem install rpn_calculator-0.0.1.gem`.
* You now should be able to simply run `rpn-calculator` from the command line.

## Non-gem usage
If you prefer to not install this library as a gem, you can simply clone the repository
and run `bin/rpn-calculator` from the project's root directory.

# Features
This calculator is a simple REPL that handles reverse polish notation calculations.
Currently, the `+ - * /` operators are supported.
Negative numbers and decimals are supported.

## Usage Examples

### Entering operands individually

    rpn-calculator> 2
    2
    rpn-calculator> 4
    4
    rpn-calculator> +
    6
    rpn-calculator> 2
    2
    rpn-calculator> *
    12

### Entering operands as an expression

    rpn-calculator> 2 4 8 * +
    34

### Exiting the REPL
To exit the calculator's REPL, enter either `q` or press `Ctrl-d`.

## Caveats
Decimal must be 0 prefixed.

    0.9 => Will work
     .9 => Will not work

# Running tests
* Clone the repository and run `bundle install`
* Run `rspec spec` to run all tests.
* A coverage report should be generated in `$PROJECT_ROOT/coverage/index.html`
