---
layout: post
title: Escaping Command Line Instructions
---

On my recent escapade to try and install Ruby/RubyGems/Jekyll on my shared hosting, I opted to use RVM as my method of installation. Here is the command provided in the instructions to install RVM:

{% highlight bash %}
$ \curl -L https://get.rvm.io | bash -s stable --ruby
{% endhighlight %}

When looking at this, I initially thought they made a typo and accidentally included the backslash. But then it struck me! It was not a mistake at all, it was very intentional and quite clever.

Putting a slash in front of a command essentially escapes it from any processing by your shell. So for instance, if you had an alias for `curl` to mangle its default behavior, running the command with the leading backslash will ignore those aliases and run the bare command without any options.

When providing any instructions that require the user to run commands on the command line, it is imperative to use the leading backslash to make sure the command produce the effects you actually intended.

