---
layout: post
title: An (Incomplete) Catalogue of Things I Learned as an Intern
---

This summer I've been working at [CareZone](https://carezone.com/home). I'm working with some really amazing and talented folks, and I have learnt a LOT! This is a list of all the most notable things.

###Weak References in Java

These are a type of object that the Garbage Collector ignores when determining whether an object can be disposed or not. I saw them used in our codebase inside a central helper class to keep a reference to a wrapper around a database connection. They can also be used in caching mechanisms, but a [`SoftReference`](http://docs.oracle.com/javase/7/docs/api/java/lang/ref/SoftReference.html) might be better suited for the job (because the GC respects it if it is not low on memory). 

Further Reading:

1. [Understanding Weak References](https://weblogs.java.net/blog/2006/05/04/understanding-weak-references)
1. [`WeakReference<T>`](http://docs.oracle.com/javase/7/docs/api/java/lang/ref/WeakReference.html)
1. [`SoftReference<T>`](http://docs.oracle.com/javase/7/docs/api/java/lang/ref/SoftReference.html)
1. [`PhantomReference<T>`](http://docs.oracle.com/javase/7/docs/api/java/lang/ref/PhantomReference.html)
1. [`WeakHashMap<K, V>`](http://docs.oracle.com/javase/7/docs/api/java/util/WeakHashMap.html)


###Creating Custom Views for Android

It's HARD. 'nuff said. I want to document the process more, but for now here are my lamentations and whining:

Writing custom views is not easy if you want to make any non trivial modifications or create whole new views for Android. You are required to do screen measurements, layouts and drawing on your own. You have to deal with the complete lifecycle of your view, through rotation, pausing, content updates and more. 

Further Reading:

1. [Creating Custom Views](http://developer.android.com/training/custom-views/index.html)

###Better Code Search: [`Ag`](https://github.com/ggreer/the_silver_searcher) over [`ack`](http://beyondgrep.com/)

Use The Silver Searcher, it is sooo much faster than `ack`. Go install it now: (Now! Seriously mister.)

{% highlight bash %}
$ brew install the_silver_searcher
$ ... comparing ag and ack runtime using time ...
$ brew uninstall ack
$ brew cleanup
{% endhighlight %}

Further Reading:

1. [The Silver Searcher: Better than Ack](http://geoff.greer.fm/2011/12/27/the-silver-searcher-better-than-ack/)

###Git and Bash aliases

Fork them! Use them! Profit! My [dotfiles](https://github.com/chandsie/dotfiles) repo is publicly available on github.
