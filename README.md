# RuntimeCommand

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

Command results are show in real time on STDOUT.

```
require 'runtime_command'

command = RuntimeCommand::Builder.new
command.exec('echo wait; sleep 3; echo hello')
```

Output contents can be get as character string.

```
command.output = false
logger = command.exec('echo wait; sleep 3; echo hello')

puts logger.buffered_log
puts logger.buffered_stdout
puts logger.buffered_stderr
```

Change STDOUT color.

```
command.colors[:stdout] = HighLine::Style.rgb(255, 0, 0)
logger = command.exec('ls -la')
```
