pragma Singleton
import qs.config

import QtQuick
import Quickshell

// Window app id -> icon path. Tries Config.appIconOverrides, then the
// desktop entry heuristic, then the id itself as an icon name. Returns ""
// when nothing in the icon theme matches, so callers can show a glyph.
Singleton {
  function source(appId) {
    if (!appId) return "";
    const id = Config.appIconOverrides[appId] ?? appId;
    const entry = DesktopEntries.heuristicLookup(id);
    return Quickshell.iconPath(entry?.icon || id, true);
  }
}
