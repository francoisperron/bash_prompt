# YABP (yet another bash prompt)
I grabbed a couple of bash prompts on the web and make one for my need.
It looks like this: 

		user@host:last_dir → git_branch : unclean_files + ahead - behind $
		On master, 2 files not commited, and 1 commit ahead of HEAD

I hope this bash_prompt code is a little cleaner and more easier to modify.
My bash skill is kinda rusty, so feel free to modify it. I'll love to see it improved!

## to run the tests
* Initiatize submodule: git submodule init && git submodule update
* Install bats: https://github.com/sstephenson/bats
* Run: bats bash_prompt_test.bats

## todo
* it would be nice to grab the real output of the prompt and title instead of only inspecting PS1
* test ahead and behind