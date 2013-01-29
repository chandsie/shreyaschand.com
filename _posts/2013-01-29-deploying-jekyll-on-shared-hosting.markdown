---
layout: post
title: Deploying Jekyll on Shared Hosting
---
Last week, I finally finished porting my website and blog to make use of the wonderful static site generator, [Jekyll](http://jekyllrb.com/).

In order to get my whole writing/editing/deploying workflow fully automated I installed jekyll, along with its dependencies, and also setup a [git post-receive hook](http://git-scm.com/book/en/Customizing-Git-Git-Hooks) (based on the official [docs](https://github.com/mojombo/jekyll/wiki/Deployment) on github) to automatically build the site.

Since I have a shared hosting plan, however, I don't have admin rights to install any pieces of software. Here are the steps I took, and you can too, in order to get around the restrictions to install everything and setup the automation.

First, install [Ruby Version Manager](https://rvm.io/)(RVM) to get a local copy of Ruby in your home folder. Be sure to follow all the install instructions to ensure that your `$PATH` environment variable is correctly setup. To verify, call `which ruby` and make sure the output is within the RVM install location in your home folder.

Finally, you are ready to install the jekyll without needing root privileges. Also required is the [pygments](http://pygments.org/) python library to provide code highlighting. I decided to install the [pygmentize](https://rubygems.org/gems/pygmentize) Ruby gem, which sources the python library, to avoid having to jump through more hoops to get `pip` to work without root.

Here's all that text on the command line:
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

Next, I setup the git repository to be able to receive my code. Follow the following steps to setup the directory structure and repository location I used: 

{% highlight bash %}
server:~$ ls
htdocs/
server:~$ mkdir tmp
server:~$ mkdir git
server:~$ cd git
server:~/git$ git --bare init website.git
  ...
sever:~/git$ ls
website.git/
sever:~/git$ cd ~
server:~$ ls
git/   htdocs/    tmp/
{% endhighlight %}

The bare git repository is the one where you will push up changes to your site. Then, the `tmp` directory is where a temporary copy of your code will get checked out for processing by jekyll. And of course, the folder `htdocs` (or whatever it is called for your particular hosting service) is the public directory that will hold your site's live contents.

To setup the automatic checkout-generation-deployment-cleanup flow, you will need to use a post-receive hook for the bare git repository. To create the script, you need to edit the `~/git/website.git/hooks/post-receive` file. In the file paste in the following script:

{% highlight bash %}
#!/bin/sh

# Directory locations
GIT_REPO=$HOME/git/website.git
TMP_GIT_CLONE=$HOME/tmp/website
PUBLIC_WWW=$HOME/htdocs

# Make sure character encodings are set to avoid any issues with accented letters and the like
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Assuming you installed rvm in the default location
# Setup the environment to be able to find the required gems
source $HOME/.rvm/environments/ruby-1.9.3-p362

# Cleanup old checked out version if it's still there
if [ -d "$TMP_GIT_CLONE" ]; then
    rm -rf $TMP_GIT_CLONE
fi


git clone $GIT_REPO $TMP_GIT_CLONE
# Change into checkout directory to avoid issues with plugins not running
cd $TMP_GIT_CLONE
# Generate the site and output the files into the final destination
jekyll --no-auto $TMP_GIT_CLONE $PUBLIC_WWW

exit
{% endhighlight %}

If you changed or want to change any of the locations, such as those for the temporary checkout or the final public folder, feel free to make those changes. Just remember to come back and update your post-receive hook to do the right thing.

Finally, on your local machine link up your development/writing git repo to your deployment server by adding a deploy remote:

{% highlight bash %}
laptop:~$ git remote add deploy user@website.com:~/git/website.git
{% endhighlight %}

And then whenever you want to update your website, just call the following command:

{% highlight bash %}
laptop:~$ git push deploy master
{% endhighlight %}

Tada! Now you have a fully automated workflow for your jekyll powered website.


