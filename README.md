# Overview
Here is a little gem that will give you a more informative shell prompt
as well as give you some ideas about how you can tweak your shell.

The prompt shows you a cool looking path, along with your current GiT
branch.

![Clean Branch](https://raw.github.com/wballard/promptula/master/screenshot.png)

...and is even nice enough to show you when you have a dirty branch,
along with a nice little ✳ for when there are untracked files that might
need to be added...

![Dirty Branch](https://raw.github.com/wballard/promptula/master/screenshot_dirty.png)


# Usage
~~~
gem install promptula
promptula --install
~~~

Then source either your .bashrc or your .bash_profile, as appropriate
~~~
source ~/.bashrc
source ~/.bash_profile
~~~

...and that's it.
