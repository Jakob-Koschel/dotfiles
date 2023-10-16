#!/usr/bin/env bash

FOCUS_TITLE=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true).name')

echo "FOCUS_TITLE: $FOCUS_TITLE"

if [[ "$FOCUS_TITLE" == "\"foot-scratchpad\"" ]]; then
	swaymsg 'scratchpad show'	
else
	swaymsg 'scratchpad show, fullscreen enable'	
fi



