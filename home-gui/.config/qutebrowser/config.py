import os
import json


def load_color_cache(path=None):
    if path is None:
        path = os.path.expanduser("~/.cache/md3-generated/colors.json")
    try:
        with open(path, "r", encoding="utf-8") as fp:
            data = json.load(fp)
    except FileNotFoundError:
        raise RuntimeError(f"Color cache not found at {path!r}")
    except json.JSONDecodeError as e:
        raise RuntimeError(f"Invalid JSON in color cache: {e}")

    return {k: v for k, v in data.items() if v.strip()}


def load_theme():
    palette = load_color_cache()

    # completion
    c.colors.completion.category.bg = palette["background"]
    c.colors.completion.category.border.bottom = palette["surface_container"]
    c.colors.completion.category.border.top = palette["surface_container_high"]
    c.colors.completion.category.fg = palette["primary"]
    c.colors.completion.even.bg = palette["surface_container"]
    c.colors.completion.odd.bg = c.colors.completion.even.bg
    c.colors.completion.fg = palette["on_surface"]

    c.colors.completion.item.selected.bg = palette["surface_container_high"]
    c.colors.completion.item.selected.border.bottom = palette["surface_container_high"]
    c.colors.completion.item.selected.border.top = palette["surface_container_high"]
    c.colors.completion.item.selected.fg = palette["on_surface"]
    c.colors.completion.item.selected.match.fg = palette["primary"]
    c.colors.completion.match.fg = palette["primary"]

    c.colors.completion.scrollbar.bg = palette["surface_container_lowest"]
    c.colors.completion.scrollbar.fg = palette["surface_container_high"]

    # downloads
    c.colors.downloads.bar.bg = palette["background"]
    c.colors.downloads.error.bg = palette["background"]
    c.colors.downloads.start.bg = palette["background"]
    c.colors.downloads.stop.bg = palette["background"]

    c.colors.downloads.error.fg = palette["error"]
    c.colors.downloads.start.fg = palette["primary"]
    c.colors.downloads.stop.fg = palette["primary"]
    c.colors.downloads.system.fg = "none"
    c.colors.downloads.system.bg = "none"

    # hints
    c.colors.hints.bg = palette["primary_container"]
    c.colors.hints.fg = palette["on_primary_container"]

    c.hints.border = "1px solid " + palette["outline"]

    c.colors.hints.match.fg = palette["primary"]

    # keyhints
    c.colors.keyhint.bg = palette["surface_container"]
    c.colors.keyhint.fg = palette["on_surface"]

    c.colors.keyhint.suffix.fg = palette["on_surface_variant"]

    # messages
    c.colors.messages.error.bg = palette["error_container"]
    c.colors.messages.info.bg = palette["surface_container"]
    c.colors.messages.warning.bg = palette["tertiary_container"]

    c.colors.messages.error.border = palette["error_container"]
    c.colors.messages.info.border = palette["surface_container"]
    c.colors.messages.warning.border = palette["tertiary_container"]

    c.colors.messages.error.fg = palette["on_error_container"]
    c.colors.messages.info.fg = palette["on_surface"]
    c.colors.messages.warning.fg = palette["on_tertiary_container"]

    # prompts
    c.colors.prompts.bg = palette["surface_container"]
    c.colors.prompts.border = "1px solid " + palette["outline"]
    c.colors.prompts.fg = palette["on_surface"]

    c.colors.prompts.selected.bg = palette["surface_container_high"]
    c.colors.prompts.selected.fg = palette["primary"]

    # statusbar
    c.colors.statusbar.normal.bg = palette["surface_container"]
    c.colors.statusbar.insert.bg = palette["primary_container"]
    c.colors.statusbar.command.bg = palette["surface_container"]
    c.colors.statusbar.caret.bg = palette["tertiary_container"]
    c.colors.statusbar.caret.selection.bg = palette["tertiary_container"]

    c.colors.statusbar.progress.bg = palette["background"]
    c.colors.statusbar.passthrough.bg = palette["secondary_container"]

    c.colors.statusbar.normal.fg = palette["on_surface"]
    c.colors.statusbar.insert.fg = palette["on_primary_container"]
    c.colors.statusbar.command.fg = palette["on_surface"]
    c.colors.statusbar.passthrough.fg = palette["on_secondary_container"]
    c.colors.statusbar.caret.fg = palette["on_tertiary_container"]
    c.colors.statusbar.caret.selection.fg = palette["on_tertiary_container"]

    c.colors.statusbar.url.error.fg = palette["error"]

    c.colors.statusbar.url.fg = palette["on_surface"]

    c.colors.statusbar.url.hover.fg = palette["primary"]

    c.colors.statusbar.url.success.http.fg = palette["primary"]
    c.colors.statusbar.url.success.https.fg = palette["primary"]

    # c.colors.statusbar.url.warn.fg = palette["warning_color"]

    c.colors.statusbar.private.bg = palette["surface_container"]
    c.colors.statusbar.private.fg = palette["on_surface_variant"]
    c.colors.statusbar.command.private.bg = palette["surface_container"]
    c.colors.statusbar.command.private.fg = palette["on_surface_variant"]

    # tabs
    c.colors.tabs.bar.bg = palette["surface_container_lowest"]
    c.colors.tabs.even.bg = palette["surface_container_lowest"]
    c.colors.tabs.odd.bg = palette["surface_container_lowest"]

    c.colors.tabs.even.fg = palette["on_surface_variant"]
    c.colors.tabs.odd.fg = palette["on_surface_variant"]

    c.colors.tabs.indicator.error = palette["error"]
    c.colors.tabs.indicator.start = palette["primary"]
    c.colors.tabs.indicator.stop = palette["primary"]
    c.colors.tabs.indicator.system = "none"

    c.colors.tabs.selected.even.bg = palette["background"]
    c.colors.tabs.selected.odd.bg = palette["background"]

    c.colors.tabs.selected.even.fg = palette["on_background"]
    c.colors.tabs.selected.odd.fg = palette["on_background"]

    c.colors.tabs.pinned.even.bg = palette["surface_container_lowest"]
    c.colors.tabs.pinned.odd.bg = palette["surface_container_lowest"]

    c.colors.tabs.pinned.even.fg = palette["on_surface_variant"]
    c.colors.tabs.pinned.odd.fg = palette["on_surface_variant"]

    c.colors.tabs.pinned.selected.even.bg = palette["background"]
    c.colors.tabs.pinned.selected.odd.bg = palette["background"]

    c.colors.tabs.pinned.selected.even.fg = palette["on_background"]
    c.colors.tabs.pinned.selected.odd.fg = palette["on_background"]

    # context menus
    c.colors.contextmenu.menu.bg = palette["surface_container"]
    c.colors.contextmenu.menu.fg = palette["on_surface"]

    c.colors.contextmenu.disabled.bg = palette["surface_container_low"]
    c.colors.contextmenu.disabled.fg = palette["on_surface_variant"]

    c.colors.contextmenu.selected.bg = palette["surface_container_high"]
    c.colors.contextmenu.selected.fg = palette["primary"]


config.load_autoconfig(False)

load_theme()

c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True
c.content.blocking.enabled = True
c.content.fullscreen.window = True
c.downloads.position = "bottom"
c.editor.command = ["foot", "--app-id", "gterm", "nvim", "{file}"]
c.statusbar.padding = {"top": 4, "bottom": 4, "left": 4, "right": 4}
c.tabs.show = "never"

c.content.geolocation = False
c.content.webrtc_ip_handling_policy = "default-public-interface-only"

config.bind("si", "hint images download")

config.bind("<Ctrl+p>", "completion-item-focus prev", mode="command")
config.bind("<Ctrl+n>", "completion-item-focus next", mode="command")

config.set("content.javascript.clipboard", "access-paste", "https://music.apple.com")
