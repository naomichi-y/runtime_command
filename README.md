# RuntimeCommand

[![Gem Version](https://badge.fury.io/rb/runtime_command.svg)](https://badge.fury.io/rb/runtime_command)
[![Test Coverage](https://codeclimate.com/github/naomichi-y/runtime_command/badges/coverage.svg)](https://codeclimate.com/github/naomichi-y/runtime_command/coverage)
[![Code Climate](https://codeclimate.com/github/naomichi-y/runtime_command/badges/gpa.svg)](https://codeclimate.com/github/naomichi-y/runtime_command)
[![CircleCI](https://circleci.com/gh/naomichi-y/runtime_command/tree/master.svg?style=shield)](https://circleci.com/gh/naomichi-y/runtime_command/tree/master)

# Description

Execute external command and retrive STDIN/STDOUT in real time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'runtime_command'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install runtime_command
```

## Usage

### command execution

```
require 'runtime_command'

command = RuntimeCommand::Builder.new
command.exec('echo wait; sleep 3; echo hello')
```

### Write command result to file

```
logger = Logger.new('result.log')
command = RuntimeCommand::Builder.new(logger: logger)
command.exec('whoami')
```

### Retrive result

```
logger = command.exec('whoami', output: false)

puts logger.buffered_stdout
puts logger.buffered_stderr
```

### Change output color

```
colors = { stdout: HighLine::Style.rgb(255, 0, 0) }
command = RuntimeCommand::Builder.new(colors: colors)
logger = command.exec('whoami')
```
