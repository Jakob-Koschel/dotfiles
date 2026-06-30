#!/usr/bin/env python3
"""Configure the Finder sidebar Favorites.

Self-contained: talks to the (deprecated but still functional) LSSharedFileList
API directly via pyobjc, so the only dependency is ``pyobjc`` -- no
finder-sidebar-editor package, which is unmaintained and mis-detects macOS 11+
(its ``mac_ver()[0].split('.')[1]`` reads the minor version and takes the wrong
code path on modern macOS).
"""

import os

from Cocoa import NSURL
from CoreFoundation import CFPreferencesAppSynchronize, kCFAllocatorDefault
from Foundation import NSBundle
from LaunchServices import kLSSharedFileListFavoriteItems
from objc import loadBundleFunctions

# Load the SharedFileList C functions we need. macOS 11+ no longer exposes these
# through the LaunchServices Python module, so pull them from the framework
# bundle directly (the modern code path the old wrapper failed to reach).
_SFL_BUNDLE = NSBundle.bundleWithIdentifier_("com.apple.coreservices.SharedFileList")
_FUNCTIONS = [
    ("LSSharedFileListCreate",
     b"^{OpaqueLSSharedFileListRef=}^{__CFAllocator=}^{__CFString=}@"),
    ("LSSharedFileListCopySnapshot",
     b"^{__CFArray=}^{OpaqueLSSharedFileListRef=}o^I"),
    ("LSSharedFileListItemCopyDisplayName",
     b"^{__CFString=}^{OpaqueLSSharedFileListItemRef=}"),
    ("LSSharedFileListItemMove",
     b"i^{OpaqueLSSharedFileListRef=}^{OpaqueLSSharedFileListItemRef=}^{OpaqueLSSharedFileListItemRef=}"),
    ("LSSharedFileListItemRemove",
     b"i^{OpaqueLSSharedFileListRef=}^{OpaqueLSSharedFileListItemRef=}"),
    ("LSSharedFileListInsertItemURL",
     b"^{OpaqueLSSharedFileListItemRef=}^{OpaqueLSSharedFileListRef=}^{OpaqueLSSharedFileListItemRef=}^{__CFString=}^{OpaqueIconRef=}^{__CFURL=}^{__CFDictionary=}^{__CFArray=}"),
    ("kLSSharedFileListItemBeforeFirst",
     b"^{OpaqueLSSharedFileListItemRef=}"),
]
loadBundleFunctions(_SFL_BUNDLE, globals(), _FUNCTIONS)


class FinderSidebar:
    """Minimal editor for the logged-in user's Finder Favorites list."""

    def __init__(self):
        self.ref = LSSharedFileListCreate(
            kCFAllocatorDefault, kLSSharedFileListFavoriteItems, None
        )
        self._snapshot()

    def _snapshot(self):
        self.items = LSSharedFileListCopySnapshot(self.ref, None)[0]
        self.names = [LSSharedFileListItemCopyDisplayName(i) for i in self.items]

    @staticmethod
    def _sync():
        CFPreferencesAppSynchronize("com.apple.sidebarlists")

    def _item(self, name):
        for item in self.items:
            if LSSharedFileListItemCopyDisplayName(item) == name:
                return item
        return None

    def remove(self, name):
        """Remove every favorite whose display name matches (case-insensitive)."""
        for item in self.items:
            if LSSharedFileListItemCopyDisplayName(item).upper() == name.upper():
                LSSharedFileListItemRemove(self.ref, item)
        self._sync()
        self._snapshot()

    def add(self, path):
        """Add a local path to the top of the Favorites list."""
        url = NSURL.alloc().initFileURLWithPath_(path)
        LSSharedFileListInsertItemURL(
            self.ref, kLSSharedFileListItemBeforeFirst, None, None, url, None, None
        )
        self._sync()
        self._snapshot()

    def move(self, name, after):
        """Move favorite ``name`` to immediately after favorite ``after``."""
        if name == after or name not in self.names or after not in self.names:
            return
        LSSharedFileListItemMove(self.ref, self._item(name), self._item(after))
        self._sync()
        self._snapshot()


def main():
    home = os.environ["HOME"]
    sidebar = FinderSidebar()
    sidebar.remove("All My Files")
    sidebar.remove("Recents")
    sidebar.add("{}/Developer".format(home))
    sidebar.add(home)
    sidebar.move("Developer", "Desktop")


if __name__ == "__main__":
    main()
