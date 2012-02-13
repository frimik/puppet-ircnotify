# Perform IRC notifications via a simple irc bot.
#
# == Parameters
#
# [*channel*]
# Default IRC channel to send notifications
#
# [*host*]
# Default host where irc bot is listening.
# 
# [*port*]
# Default port where irc bot is listening.
#
# == Examples
#
#   class {'ircnotify':
#     channel => '#puppet',
#     host    => 'ircbot.example.com',
#     port    => 5050
#   }
#
#   ircnotify::privmsg { "foo bar baz":
#     channel => "#puppet",
#   }
#
# == Authors
#
# Mikael Fridh <mfridh@marinsoftware.com>
#
# == Copyright
#
# Copyright 2012 Marin Software Inc, unless otherwise noted.
#
class ircnotify (
  $channel  = $ircnotify::params::channel,
  $host     = $ircnotify::params::channel,
  $port     = $ircnotify::params::channel
) inherits ircnotify::params {

  include ircnotify::packages

  # Definition: privmsg
  #
  # == Parameters
  #
  # $message - the message string
  # $channel - the channel string
  #
  # [*message*]
  #   You can skip the message parameter if you like, in which case the message
  #   is taken from the namevar by default.
  #
  #
  # [*channel*]
  #   This parameter sets the channel for which the message is intended.
  #
  # == Examples
  #
  #   ircnotify::privmsg {
  #     "foo":
  #       channel => "#bar",
  #   }
  #
  # This sends the message "foo" to the channel #bar, relying on the namevar.
  #
  #   ircnotify::privmsg { "foo-bar-notification":
  #     message => "foo",
  #     channel => "#bar",
  #   }
  #
  # This sends the same message, "foo" to the #bar channel, but sets an explicit
  # resource title and by using the message parameter.
  #
  define privmsg (
    $message = $name,
    $channel = $ircnotify::params::channel,
    $host    = $ircnotify::params::host,
    $port    = $ircnotify::params::port
  ) {

    # Combine the channel and message into an array of message parts.
    $msgparts = [$channel, $message]
    # Convert these array parts into a safely quoted string.
    $mymsg = shellquote($msgparts)

    # TODO Create a simply ruby function to do this?
    exec { "notify-irc/${channel}/${name}":
      # Pass the message through netcat to the remote irc bot.
      command     => "echo -e $mymsg | nc -w 2 $host $port",
      user        => "nobody",
    }

  }

}
