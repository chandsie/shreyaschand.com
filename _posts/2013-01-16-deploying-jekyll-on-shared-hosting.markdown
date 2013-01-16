---
layout: post
title: Deploying Jekyll on Shared Hosting
---
Yesterday, I finally finished porting my website and blog to make use of the wonderful static site generator, [Jekyll](http://jekyllrb.com/).

Here's how to install all the prerequisites on your shared hosting space:

rvm 1.17.9

{% highlight bash %}
laptop:~$ ssh user@website.com
server:~$ \curl -L https://get.rvm.io | bash -s stable --ruby
  ...
server:~$ gem install jekyll
  ...
server:~$ gem install pygmentize
  ...
{% endhighlight %}

You need to have a bare git repository on your server which will accept, process and then deploy your site content. Here's how to set it up:

{% highlight bash %}
server:~$ mkdir git
server:~$ cd git
server:~$ git --bare init website.git
  ...
server:~$ vim website.git/hooks/post-receive // Or use your favorite text editor
{% endhighlight %}

In the post-receive file insert the following: 

{% highlight bash %}
#!/bin/sh

GIT_REPO=$HOME/git/website.git
TMP_GIT_CLONE=$HOME/tmp/website
PUBLIC_WWW=$HOME/public

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

// Assuming you installed rvm in the default location
source $HOME/.rvm/environments/ruby-1.9.3-p362 

if [ -d "$TMP_GIT_CLONE" ]; then
    rm -rf $TMP_GIT_CLONE
fi

git clone $GIT_REPO $TMP_GIT_CLONE
cd $TMP_GIT_CLONE
jekyll --no-auto $TMP_GIT_CLONE $PUBLIC_WWW

exit
{% endhighlight %}

{% highlight bash %}
laptop:~$ git remote add deploy user@website.com:~/git/website.git
{% endhighlight %}

{% highlight bash %}
laptop:~$ git push deploy master
{% endhighlight %}

