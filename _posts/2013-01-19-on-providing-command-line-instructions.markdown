---
layout: post
title: 
---

On my recent escapade to try and install Ruby/RubyGems/Jekyll on my shared hosting, I opted to use RVM as my method of installation. Here is the command provided in the instructions to install RVM:

{% highglight bash %}
{% endhighlight %}

When looking at this, I initially thought they made a typo and accidentally included the forward slash. But then it struck me! It was not a mistake at all, it was very intentional and quite clever. Putting a slash in front of a command essentially escapes it from any processing by your shell. So for instance, if you had an alias for curl/wget to mangle its default behavior, running the command with the leading backslash will ignore those aliases and run the bare command without any options.


