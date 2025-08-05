# vim:fileencoding=utf-8:foldmethod=marker


def setup(c, flavour):
    palette = {
        "primary": "#b1d18a",
        "surface_tint": "#b1d18a",
        "on_primary": "#1f3701",
        "primary_container": "#354e16",
        "on_primary_container": "#cdeda3",
        "secondary": "#bfcbad",
        "on_secondary": "#2a331e",
        "secondary_container": "#404a33",
        "on_secondary_container": "#dce7c8",
        "tertiary": "#a0d0cb",
        "on_tertiary": "#003735",
        "tertiary_container": "#1f4e4b",
        "on_tertiary_container": "#bcece7",
        "error": "#ffb4ab",
        "on_error": "#690005",
        "error_container": "#93000a",
        "on_error_container": "#ffdad6",
        "background": "#12140e",
        "on_background": "#e2e3d8",
        "surface": "#12140e",
        "on_surface": "#e2e3d8",
        "surface_variant": "#44483d",
        "on_surface_variant": "#c5c8ba",
        "outline": "#8f9285",
        "outline_variant": "#44483d",
        "shadow": "#000000",
        "scrim": "#000000",
        "inverse_surface": "#e2e3d8",
        "inverse_on_surface": "#2f312a",
        "inverse_primary": "#4c662b",
        "primary_fixed": "#cdeda3",
        "on_primary_fixed": "#102000",
        "primary_fixed_dim": "#b1d18a",
        "on_primary_fixed_variant": "#354e16",
        "secondary_fixed": "#dce7c8",
        "on_secondary_fixed": "#151e0b",
        "secondary_fixed_dim": "#bfcbad",
        "on_secondary_fixed_variant": "#404a33",
        "tertiary_fixed": "#bcece7",
        "on_tertiary_fixed": "#00201e",
        "tertiary_fixed_dim": "#a0d0cb",
        "on_tertiary_fixed_variant": "#1f4e4b",
        "surface_dim": "#12140e",
        "surface_bright": "#383a32",
        "surface_container_lowest": "#0c0f09",
        "surface_container_low": "#1a1c16",
        "surface_container": "#1e201a",
        "surface_container_high": "#282b24",
        "surface_container_highest": "#33362e",
        "warning_color": "#d9c76f",
        "warning_on_color": "#393000",
        "warning_color_container": "#524700",
        "warning_on_color_container": "#f6e388",
    }

    # completion {{{
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
    # }}}

    # downloads {{{
    c.colors.downloads.bar.bg = palette["background"]
    c.colors.downloads.error.bg = palette["background"]
    c.colors.downloads.start.bg = palette["background"]
    c.colors.downloads.stop.bg = palette["background"]

    c.colors.downloads.error.fg = palette["error"]
    c.colors.downloads.start.fg = palette["primary"]
    c.colors.downloads.stop.fg = palette["primary"]
    c.colors.downloads.system.fg = "none"
    c.colors.downloads.system.bg = "none"
    # }}}

    # hints {{{
    c.colors.hints.bg = palette["primary_container"]
    c.colors.hints.fg = palette["on_primary_container"]

    c.hints.border = "1px solid " + palette["outline"]

    c.colors.hints.match.fg = palette["primary"]
    # }}}

    # keyhints {{{
    c.colors.keyhint.bg = palette["surface_container"]
    c.colors.keyhint.fg = palette["on_surface"]

    c.colors.keyhint.suffix.fg = palette["on_surface_variant"]
    # }}}

    # messages {{{
    c.colors.messages.error.bg = palette["error_container"]
    c.colors.messages.info.bg = palette["surface_container"]
    c.colors.messages.warning.bg = palette["warning_color_container"]

    c.colors.messages.error.border = palette["error_container"]
    c.colors.messages.info.border = palette["surface_container"]
    c.colors.messages.warning.border = palette["warning_color_container"]

    c.colors.messages.error.fg = palette["on_error_container"]
    c.colors.messages.info.fg = palette["on_surface"]
    c.colors.messages.warning.fg = palette["warning_on_color_container"]
    # }}}

    # prompts {{{
    c.colors.prompts.bg = palette["surface_container"]
    c.colors.prompts.border = "1px solid " + palette["outline"]
    c.colors.prompts.fg = palette["on_surface"]

    c.colors.prompts.selected.bg = palette["surface_container_high"]
    c.colors.prompts.selected.fg = palette["primary"]
    # }}}

    # statusbar {{{
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

    c.colors.statusbar.url.warn.fg = palette["warning_color"]

    c.colors.statusbar.private.bg = palette["surface_container"]
    c.colors.statusbar.private.fg = palette["on_surface_variant"]
    c.colors.statusbar.command.private.bg = palette["surface_container"]
    c.colors.statusbar.command.private.fg = palette["on_surface_variant"]

    # }}}

    # tabs {{{
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
    # }}}

    # context menus {{{
    c.colors.contextmenu.menu.bg = palette["surface_container"]
    c.colors.contextmenu.menu.fg = palette["on_surface"]

    c.colors.contextmenu.disabled.bg = palette["surface_container_low"]
    c.colors.contextmenu.disabled.fg = palette["on_surface_variant"]

    c.colors.contextmenu.selected.bg = palette["surface_container_high"]
    c.colors.contextmenu.selected.fg = palette["primary"]
    # }}}
