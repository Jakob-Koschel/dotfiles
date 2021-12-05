#!/usr/bin/python3

from finder_sidebar_editor import FinderSidebar

sidebar = FinderSidebar()

sidebar.remove("All My Files")
sidebar.add("/Users/jkl/Developer")
sidebar.add("/Users/jkl")
sidebar.move("Developer", "Desktop")
