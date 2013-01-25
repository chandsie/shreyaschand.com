---
layout: post
title: Deploying Jekyll on Shared Hosting
---
Last week, I finally finished porting my website and blog to make use of the wonderful static site generator, [Jekyll](http://jekyllrb.com/).

In order to get my whole writing/editing/deploying workflow fully automated I installed jekyll, along with its dependencies, and also setup a git post-receive hook to automatically build the site.

Since I have a shared hosting plan, however, I don't have admin rights to install any pieces of software. Here are the steps I took, and you can too, in order to get around the restrictions to install everything and setup the automation.

First, install [Ruby Version Manager](https://rvm.io/)(RVM) to get a local copy of Ruby in your home folder. Be sure to follow all the install instructions to ensure that your `$PATH` environment variable is correctly setup. To verify, call `which ruby` and make sure the output is within the RVM install location in your home folder. Finally, you are ready to actually install jekyll, which is easy because you now don't require root privileges. Also required is pygmentize to provide code highlighting. I decided to just install the pygmentize Ruby Gem because it sources the actualy python library, and now I don't have to jump through more hoops to get local copies of all dependencies on to my

{% highlight bash %}
laptop:~$ ssh user@website.com
server:~$ \curl -L https://get.rvm.io | bash -s stable --ruby
  ...
server:~$ which ruby
/path/to/home/directory/.rvm/rubies/ruby-1.9.3-p362/bin/ruby
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

