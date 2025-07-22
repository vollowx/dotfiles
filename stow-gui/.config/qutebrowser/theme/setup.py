# vim:fileencoding=utf-8:foldmethod=marker


def setup(c, flavour):
    palette = {}

    # flavours {{{
    if flavour == "oxocarbon-dark":
        palette = {
            "rosewater": "#ff8389",
            "flamingo": "#ff8389",
            "red": "#ff8389",
            "maroon": "#ff8389",
            "pink": "#ff7eb6",
            "mauve": "#be95ff",
            "peach": "#d44a1c",
            "yellow": "#ab8600",
            "green": "#08bdba",
            "teal": "#33b1ff",
            "sky": "#33b1ff",
            "sapphire": "#33b1ff",
            "blue": "#78a9ff",
            "lavender": "#78a9ff",
            "text": "#ffffff",
            "subtext1": "#f4f4f4",
            "subtext0": "#e0e0e0",
            "overlay2": "#adadad",
            "overlay1": "#949494",
            "overlay0": "#7a7a7a",
            "surface2": "#4f4f4f",
            "surface1": "#383838",
            "surface0": "#2e2e2e",
            "base": "#161616",
            "mantle": "#0d0d0d",
            "crust": "#000000",
        }
    elif flavour == "catppuccin-latte":
        palette = {
            "rosewater": "#dc8a78",
            "flamingo": "#dd7878",
            "pink": "#ea76cb",
            "mauve": "#8839ef",
            "red": "#d20f39",
            "maroon": "#e64553",
            "peach": "#fe640b",
            "yellow": "#df8e1d",
            "green": "#40a02b",
            "teal": "#179299",
            "sky": "#04a5e5",
            "sapphire": "#209fb5",
            "blue": "#1e66f5",
            "lavender": "#7287fd",
            "text": "#4c4f69",
            "subtext1": "#5c5f77",
            "subtext0": "#6c6f85",
            "overlay2": "#7c7f93",
            "overlay1": "#8c8fa1",
            "overlay0": "#9ca0b0",
            "surface2": "#acb0be",
            "surface1": "#bcc0cc",
            "surface0": "#ccd0da",
            "base": "#eff1f5",
            "mantle": "#e6e9ef",
            "crust": "#dce0e8",
        }
    elif flavour == "catppuccin-frappe":
        palette = {
            "rosewater": "#f2d5cf",
            "flamingo": "#eebebe",
            "pink": "#f4b8e4",
            "mauve": "#ca9ee6",
            "red": "#e78284",
            "maroon": "#ea999c",
            "peach": "#ef9f76",
            "yellow": "#e5c890",
            "green": "#a6d189",
            "teal": "#81c8be",
            "sky": "#99d1db",
            "sapphire": "#85c1dc",
            "blue": "#8caaee",
            "lavender": "#babbf1",
            "text": "#c6d0f5",
            "subtext1": "#b5bfe2",
            "subtext0": "#a5adce",
            "overlay2": "#949cbb",
            "overlay1": "#838ba7",
            "overlay0": "#737994",
            "surface2": "#626880",
            "surface1": "#51576d",
            "surface0": "#414559",
            "base": "#303446",
            "mantle": "#292c3c",
            "crust": "#232634",
        }
    elif flavour == "catppuccin-macchiato":
        palette = {
            "rosewater": "#f4dbd6",
            "flamingo": "#f0c6c6",
            "pink": "#f5bde6",
            "mauve": "#c6a0f6",
            "red": "#ed8796",
            "maroon": "#ee99a0",
            "peach": "#f5a97f",
            "yellow": "#eed49f",
            "green": "#a6da95",
            "teal": "#8bd5ca",
            "sky": "#91d7e3",
            "sapphire": "#7dc4e4",
            "blue": "#8aadf4",
            "lavender": "#b7bdf8",
            "text": "#cad3f5",
            "subtext1": "#b8c0e0",
            "subtext0": "#a5adcb",
            "overlay2": "#939ab7",
            "overlay1": "#8087a2",
            "overlay0": "#6e738d",
            "surface2": "#5b6078",
            "surface1": "#494d64",
            "surface0": "#363a4f",
            "base": "#24273a",
            "mantle": "#1e2030",
            "crust": "#181926",
        }
    elif flavour == "catppuccin-latte":
        palette = {
            "rosewater": "#f5e0dc",
            "flamingo": "#f2cdcd",
            "pink": "#f5c2e7",
            "mauve": "#cba6f7",
            "red": "#f38ba8",
            "maroon": "#eba0ac",
            "peach": "#fab387",
            "yellow": "#f9e2af",
            "green": "#a6e3a1",
            "teal": "#94e2d5",
            "sky": "#89dceb",
            "sapphire": "#74c7ec",
            "blue": "#89b4fa",
            "lavender": "#b4befe",
            "text": "#cdd6f4",
            "subtext1": "#bac2de",
            "subtext0": "#a6adc8",
            "overlay2": "#9399b2",
            "overlay1": "#7f849c",
            "overlay0": "#6c7086",
            "surface2": "#585b70",
            "surface1": "#45475a",
            "surface0": "#313244",
            "base": "#1e1e2e",
            "mantle": "#181825",
            "crust": "#11111b",
        }
    # }}}

    # completion {{{
    c.colors.completion.category.bg = palette["base"]
    c.colors.completion.category.border.bottom = palette["mantle"]
    c.colors.completion.category.border.top = palette["surface2"]
    c.colors.completion.category.fg = palette["lavender"]
    c.colors.completion.even.bg = palette["mantle"]
    c.colors.completion.odd.bg = c.colors.completion.even.bg
    c.colors.completion.fg = palette["subtext0"]

    c.colors.completion.item.selected.bg = palette["surface2"]
    c.colors.completion.item.selected.border.bottom = palette["surface2"]
    c.colors.completion.item.selected.border.top = palette["surface2"]
    c.colors.completion.item.selected.fg = palette["subtext0"]
    c.colors.completion.item.selected.match.fg = palette["text"]
    c.colors.completion.match.fg = palette["text"]

    c.colors.completion.scrollbar.bg = palette["crust"]
    c.colors.completion.scrollbar.fg = palette["surface2"]
    # }}}

    # downloads {{{
    c.colors.downloads.bar.bg = palette["base"]
    c.colors.downloads.error.bg = palette["base"]
    c.colors.downloads.start.bg = palette["base"]
    c.colors.downloads.stop.bg = palette["base"]

    c.colors.downloads.error.fg = palette["red"]
    c.colors.downloads.start.fg = palette["blue"]
    c.colors.downloads.stop.fg = palette["green"]
    c.colors.downloads.system.fg = "none"
    c.colors.downloads.system.bg = "none"
    # }}}

    # hints {{{
    c.colors.hints.bg = palette["peach"]
    c.colors.hints.fg = palette["mantle"]

    c.hints.border = "1px solid " + palette["mantle"]

    c.colors.hints.match.fg = palette["subtext1"]
    # }}}

    # keyhints {{{
    c.colors.keyhint.bg = palette["mantle"]
    c.colors.keyhint.fg = palette["text"]

    c.colors.keyhint.suffix.fg = palette["subtext1"]
    # }}}

    # messages {{{
    c.colors.messages.error.bg = palette["overlay0"]
    c.colors.messages.info.bg = palette["overlay0"]
    c.colors.messages.warning.bg = palette["overlay0"]

    c.colors.messages.error.border = palette["mantle"]
    c.colors.messages.info.border = palette["mantle"]
    c.colors.messages.warning.border = palette["mantle"]

    c.colors.messages.error.fg = palette["red"]
    c.colors.messages.info.fg = palette["text"]
    c.colors.messages.warning.fg = palette["peach"]
    # }}}

    # prompts {{{
    c.colors.prompts.bg = palette["mantle"]
    c.colors.prompts.border = "1px solid " + palette["overlay0"]
    c.colors.prompts.fg = palette["text"]

    c.colors.prompts.selected.bg = palette["surface2"]
    c.colors.prompts.selected.fg = palette["rosewater"]
    # }}}

    # statusbar {{{
    c.colors.statusbar.normal.bg = palette["mantle"]
    c.colors.statusbar.insert.bg = palette["mantle"]
    c.colors.statusbar.command.bg = palette["mantle"]
    c.colors.statusbar.caret.bg = palette["mantle"]
    c.colors.statusbar.caret.selection.bg = palette["mantle"]

    c.colors.statusbar.progress.bg = palette["base"]
    c.colors.statusbar.passthrough.bg = palette["base"]

    c.colors.statusbar.normal.fg = palette["text"]
    c.colors.statusbar.insert.fg = palette["rosewater"]
    c.colors.statusbar.command.fg = palette["text"]
    c.colors.statusbar.passthrough.fg = palette["peach"]
    c.colors.statusbar.caret.fg = palette["peach"]
    c.colors.statusbar.caret.selection.fg = palette["peach"]

    c.colors.statusbar.url.error.fg = palette["red"]

    c.colors.statusbar.url.fg = palette["text"]

    c.colors.statusbar.url.hover.fg = palette["sky"]

    c.colors.statusbar.url.success.http.fg = palette["teal"]
    c.colors.statusbar.url.success.https.fg = palette["green"]

    c.colors.statusbar.url.warn.fg = palette["yellow"]

    c.colors.statusbar.private.bg = palette["mantle"]
    c.colors.statusbar.private.fg = palette["subtext1"]
    c.colors.statusbar.command.private.bg = palette["base"]
    c.colors.statusbar.command.private.fg = palette["subtext1"]

    # }}}

    # tabs {{{
    c.colors.tabs.bar.bg = palette["crust"]
    c.colors.tabs.even.bg = palette["crust"]
    c.colors.tabs.odd.bg = palette["crust"]

    c.colors.tabs.even.fg = palette["subtext0"]
    c.colors.tabs.odd.fg = palette["subtext0"]

    c.colors.tabs.indicator.error = palette["red"]
    c.colors.tabs.indicator.start = palette["blue"]
    c.colors.tabs.indicator.stop = palette["green"]
    c.colors.tabs.indicator.system = "none"

    c.colors.tabs.selected.even.bg = palette["base"]
    c.colors.tabs.selected.odd.bg = palette["base"]

    c.colors.tabs.selected.even.fg = palette["text"]
    c.colors.tabs.selected.odd.fg = palette["text"]

    c.colors.tabs.pinned.even.bg = palette["crust"]
    c.colors.tabs.pinned.odd.bg = palette["crust"]

    c.colors.tabs.pinned.even.fg = palette["subtext0"]
    c.colors.tabs.pinned.odd.fg = palette["subtext0"]

    c.colors.tabs.pinned.selected.even.bg = palette["base"]
    c.colors.tabs.pinned.selected.odd.bg = palette["base"]

    c.colors.tabs.pinned.selected.even.fg = palette["text"]
    c.colors.tabs.pinned.selected.odd.fg = palette["text"]
    # }}}

    # context menus {{{
    c.colors.contextmenu.menu.bg = palette["base"]
    c.colors.contextmenu.menu.fg = palette["text"]

    c.colors.contextmenu.disabled.bg = palette["mantle"]
    c.colors.contextmenu.disabled.fg = palette["overlay0"]

    c.colors.contextmenu.selected.bg = palette["overlay0"]
    c.colors.contextmenu.selected.fg = palette["rosewater"]
    # }}}
