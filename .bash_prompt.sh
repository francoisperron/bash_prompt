#!/bin/bash

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Avoid name collision
prompt_constants() {
  color_profile
  cat << __END 
    local arrow=' → '
    local user='\u'
    local host='\h'
    local dir='\w'

    local title_start="\[\033]2;"
    local title_end="\007\]"
__END
}

color_profile() {
  if [ "${disable_color_prompt-}" ]; then
    cat << ____END 
      local reset=''
      local bold=''

      local red=''
      local light_red=''
      local green=''
      local light_green=''
      local yellow=''
      local blue=''
      local light_blue=''
      local purple=''
      local light_purple=''
      local cyan=''
      local light_cyan=''
      local dark_gray=''
      local light_gray=''
      local white=''
____END
  else
    cat << ____END 
      local reset='\[\e[00m\]'
      local bold='\[\e[01m\]'

      local red='\[\e[0;31m\]'
      local light_red='\[\e[1;31m\]'
      local green='\[\e[0;32m\]'
      local light_green='\[\e[1;32m\]'
      local yellow='\[\e[1;33m\]'
      local blue='\[\e[0;34m\]'
      local light_blue='\[\e[1;34m\]'
      local purple='\[\e[0;35m\]'
      local light_purple='\[\e[1;35m\]'
      local cyan='\[\e[0;36m\]'
      local light_cyan='\[\e[1;36m\]'
      local dark_gray='\[\e[1;30m\]'
      local light_gray='\[\e[0;37m\]'
      local white='\[\e[1;37m\]'
____END
  fi
}

is_git_dir() {
  if git rev-parse --show-toplevel >/dev/null 2>/dev/null; then
    return 0
  else
    return 1
  fi
}

git_branch_prompt() {
  eval "$(prompt_constants)"
  local git_branch=$(git branch | grep "*" | awk '{print $2}')
  if [ $? -eq 0 ]; then
      echo -n "${yellow}${arrow}${git_branch}"  
  fi
}

git_files_changed_prompt() {
  eval "$(prompt_constants)"
  local nb_files=$(git status -s | wc -l | tr -d ' ')
  if [ $nb_files -ne 0 ]; then
    echo -n "$yellow : $nb_files"
  fi
}

git_ahead_and_behind_prompt(){
  eval "$(prompt_constants)"
  local ahead=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l)
  local behind=$(git rev-list HEAD..@{u} 2>/dev/null | wc -l)
  if [ $ahead -ne 0 -a $behind -eq 0 ]; then
      local ahead_behind="$red +$ahead"
  elif [ $behind -ne 0 -a $ahead -eq 0 ]; then
      local ahead_behind="$red -$behind"
  elif [ $ahead -eq 0 -a $behind -eq 0 ]; then
      local ahead_behind=""
  else
      local ahead_behind="$red +$ahead -$behind"
  fi

  echo -n $ahead_behind
}

default_prompt() {
  eval "$(prompt_constants)"
  echo -n "${light_gray}${user}@${host}:${light_red}${dir}"
}

git_prompt() {
  if is_git_dir; then
      local branch=$(git_branch_prompt)
      local nb_files=$(git_files_changed_prompt)
      local ahead_behind=$(git_ahead_and_behind_prompt)
      echo -n "${branch}${nb_files}${ahead_behind}"
  fi
}

is_xterm() {
  case "$TERM" in
    xterm*|rxvt*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

terminal_title() {
  if is_xterm; then
    disable_color_prompt=yes
    eval "$(prompt_constants)"
    echo -n "${title_start}$(default_prompt)$(git_prompt)${title_end}"
    unset disable_color_prompt
  fi
}

prompt() {
  unset disable_color_prompt
  eval "$(prompt_constants)"
  local prompt_data="$(terminal_title)$(default_prompt)$(git_prompt)"
  PS1="${prompt_data}${reset} \$ "
}
 
unset PS1
PROMPT_COMMAND=prompt
