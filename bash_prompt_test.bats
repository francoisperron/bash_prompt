#!/usr/bin/env bats

@test "prompt is set to 'user@host:dir $' in a normal dir" {  
  source .bash_prompt.sh
  
  cd ~
  
  set_ps1
  expected="\[\033]2;\u@\h:\W\007\]\[\e[0;37m\]\u\[\e[0;37m\]@\h\[\e[1;31m\]:\W\[\e[00m\] $ "
  result=$PS1
  
  cd -
  
  assertResultEqualsExpected
}

@test "prompt is set to 'user@host:dir → master : files +ahead -behind' in a git dir" {
  source .bash_prompt.sh
  
  mkdir git_test
  cd git_test
  
  git init
  git commit --allow-empty -m "initial commit"
  touch a_file

  set_ps1
  expected="\[\033]2;\u@\h:\W → master : 1\007\]\[\e[0;37m\]\u\[\e[0;37m\]@\h\[\e[1;31m\]:\W\[\e[1;33m\] → master\[\e[1;33m\] : 1\[\e[00m\] $ "
  result=$PS1
  
  cd - 
  rm -rf git_test

  assertResultEqualsExpected
}

assertResultEqualsExpected(){
  echo "Result  : $result"
  echo "Expected: $expected"
  [ "$result" == "$expected" ]
}

