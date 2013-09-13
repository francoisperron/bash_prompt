##  Clean Code - Bash prompt for git and hg
I grabbed a couple of bash prompts on the web and make one for my need.
It looks like this in a git or hg repo dir: 

```
user@host:last_dir → git_branch : unclean_files + ahead - behind $
```

I hope this bash_prompt code is a little cleaner and more easier to modify.

## To run the tests
* Initiatize submodule: git submodule init && git submodule update
* Install bats: https://github.com/sstephenson/bats
* Run: bats bash_prompt_test.bats

## Todo
* it would be nice to grab the real output of the prompt and title instead of only inspecting PS1
* test ahead and behind