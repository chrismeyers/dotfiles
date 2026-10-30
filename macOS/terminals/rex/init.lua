local prefix = "ctrl+a>"
local function bind(key, action, args)
  rex.bind(prefix .. key, action, args)
end

bind("-", "pane.split.down")
bind("\\", "pane.split.right")
bind("c", "client.tab.new")
bind("z", "pane.zoom")
bind("=", "pane.balance")

bind("left", "pane.focus.left")
bind("down", "pane.focus.down")
bind("up", "pane.focus.up")
bind("right", "pane.focus.right")

bind("n", "client.tab.next")
bind("p", "client.tab.previous")
for i = 1, 9 do
  bind(tostring(i), "client.tab.goto", { index = i })
end

-- Press ctrl+a twice to send it to the terminal
bind("ctrl+a", "pane.send_key", { key = "ctrl+a" })
