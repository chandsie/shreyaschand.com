---
layout: post
title: Show Git Branch Status in Bash Prompt
---
[Akihiro Matsukawa](http://amatsukawa.com/) in his post ["Git Tip - Show branch name and status in command line"](http://amatsukawa.com/git-branch-command-line.html) shares how to customize your PS1 environment variable to show the name of a git repo's current branch and status of the branch (changed, commited and ahead of remote, clean). I really liked the idea but wanted to make some modifications. Here's my version:

{% highlight bash %}
parse_git_branch ()
{
    local GITDIR=`git rev-parse --show-toplevel 2>&1` # Get root directory of git repo
    if [[ "$GITDIR" != '/Users/shreyas' ]] # Don't show status of home directory repo
    then
        # Figure out the current branch, wrap in brackets and return it
        local BRANCH=`git branch 2>/dev/null | sed -n '/^\*/s/^\* //p'`
        if [ -n "$BRANCH" ]; then
            echo -e "[$BRANCH]"
        fi
    else
        echo ""
    fi
}

function git_color ()
{
    # Get the status of the repo and chose a color accordingly
    local STATUS=`git status 2>&1`
    if [[ "$STATUS" == *'Not a git repository'* ]]
    then
        echo ""
    else
        if [[ "$STATUS" != *'working directory clean'* ]]
        then
            # red if need to commit
            echo -e '\033[0;31m'
        else
            if [[ "$STATUS" == *'Your branch is ahead'* ]]
            then
                # yellow if need to push
                echo -e '\033[0;33m'
            else
                # else cyan
                echo -e '\033[0;36m'
            fi
        fi
    fi
}

# Call the above functions inside the PS1 declaration
export PS1='\[$(git_color)\]$(parse_git_branch)\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ '
{% endhighlight %}

I added an extra check to `parse_git_branch()` so that the status doesn't show up if I'm in my home directory. This is because I have my dotfiles in a git repo in my home folder and I normally don't care about knowing their branch status. I also modified Aki's version of the prompt itself to not include the current time, but include my username and hostname. I also replaced the `>>` from his PS1 to the more classic `$`.

Here is what all the possible prompts look like:

[![All Possible Prompts](/img/blog/show-git-branch-status-in-bash-prompt/all-prompts.png)](/img/blog/show-git-branch-status-in-bash-prompt/all-prompts.png)
{: .center }


Thanks Aki!
