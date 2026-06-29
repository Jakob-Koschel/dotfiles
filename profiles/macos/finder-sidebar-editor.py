#!/usr/bin/python3

import os
from finder_sidebar_editor import FinderSidebar

sidebar = FinderSidebar()

home = os.environ['HOME']

sidebar.remove("All My Files")
sidebar.remove("Recents")
sidebar.add("{}/Developer".format(home))
sidebar.add(home)
sidebar.move("Developer", "Desktop")
