#!/usr/bin/env bash

# Starts the services required for Madoffice development
# usage: ./madoffice.sh [build]

BLUE_BOLD="\033[1;34m"
NORMAL="\033[0m"
[[ $1 == "build" ]] && build=true || build=false

function go {
  local tag=$1
  local build_script=$2
  local run_script=$3

  if [[ $build == true ]]; then
    printf "${BLUE_BOLD}Building $tag...${NORMAL}\n"
    ./$build_script
  fi

  printf "${BLUE_BOLD}Starting $tag...${NORMAL}\n"
  ./$run_script
}

(
  cd ~/.captain/headproxy/madoffice-legacy-development/docker/legacy/development
  go "Madoffice Legacy" build.development.sh run.development.sh
)

(
  cd ~/.captain/headproxy/madoffice-api-development/docker/api
  go "Madoffice API" build.development.sh run.development.sh
)

(
  cd ~/.captain/headproxy/billing-api-development/docker/api
  go "Billing API" build.development.sh run.development.sh
)

printf "${BLUE_BOLD}Here's what docker has to say:${NORMAL}\n"
docker ps

# ASCII art taken from: https://www.asciiart.eu/mythology/dragons
printf $BLUE_BOLD
cat << "EOF"
             __                  __
            ( _)                ( _)
           / / \\              / /\_\_
          / /   \\            / / | \ \     Madoffice
         / /     \\          / /  |\ \ \    is
        /  /   ,  \ ,       / /   /|  \ \   ready!
       /  /    |\_ /|      / /   / \   \_\
      /  /  |\/ _ '_| \   / /   /   \    \\
     |  /   |/  0 \0\    / |    |    \    \\
     |    |\|      \_\_ /  /    |     \    \\
     |  | |/    \.\ o\o)  /      \     |    \\
     \    |     /\\`v-v  /        |    |     \\
      | \/    /_| \\_|  /         |    | \    \\
      | |    /__/_ `-` /   _____  |    |  \    \\
      \|    [__]  \_/  |_________  \   |   \    ()
       /    [___] (    \         \  |\ |   |   //
      |    [___]                  |\| \|   /  |/
     /|    [____]                  \  |/\ / / ||
    (  \   [____ /     ) _\      \  \    \| | ||
     \  \  [_____|    / /     __/    \   / / //
     |   \ [_____/   / /        \    |   \/ //
     |   /  '----|   /=\____   _/    |   / //
  __ /  /        |  /   ___/  _/\    \  | ||
 (/-(/-\)       /   \  (/\/\)/  |    /  | /
               (/\/\)           /   /   //
                      _________/   /    /
                     \____________/    (

EOF
printf $NORMAL
