import catppuccin

catppuccin.setup(c, "oxocarbon-dark", False)
config.load_autoconfig(False)

c.auto_save.session = True
c.colors.webpage.preferred_color_scheme = "dark"
c.scrolling.smooth = True
c.statusbar.padding = {"top": 4, "bottom": 4, "left": 4, "right": 4}
c.tabs.show = "switching"
