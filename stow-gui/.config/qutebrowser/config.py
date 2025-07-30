import theme

config.load_autoconfig(False)

theme.setup(c, "oxocarbon-dark")

c.auto_save.session = True
c.colors.webpage.preferred_color_scheme = "dark"
c.content.blocking.enabled = True
c.content.fullscreen.window = True
c.downloads.position = "bottom"
c.editor.command = ["foot", "--app-id", "gterm", "nvim", "{file}"]
c.statusbar.padding = {"top": 4, "bottom": 4, "left": 4, "right": 4}
c.tabs.show = "never"

c.content.canvas_reading = False
c.content.geolocation = False
c.content.webrtc_ip_handling_policy = "default-public-interface-only"

config.bind("si", "hint images download")

config.bind("<Ctrl+p>", "completion-item-focus prev", mode="command")
config.bind("<Ctrl+n>", "completion-item-focus next", mode="command")

config.set("content.javascript.clipboard", "access-paste", "https://music.apple.com")
