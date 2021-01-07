#! /usr/bin/env bash

function log_color()
{
  case $1 in
    red) echo -e "\033[31m$2 \033[0m"
  ;;
    green) echo -e "\033[32m$2 \033[0m"
  ;;
    yellow) echo -e "\033[33m$2 \033[0m"
  ;;
    blue) echo -e "\033[34m$2 \033[0m"
  ;;
    black) echo -e "\033[30m$2 \033[0m"
  ;;
    purple) echo -e "\033[35m$2 \033[0m"
  ;;
    lightblue) echo -e "\033[36m$2 \033[0m"
  ;;
    white) echo -e "\033[37m$2 \033[0m"
  ;;
 esac
}

function log_red()
{
  log_color red "$1"
}

function log_green()
{
  log_color green "$1"
}

function log_yellow()
{
  log_color yellow "$1"
}

function log_blue()
{
  log_color blue "$1"
}

