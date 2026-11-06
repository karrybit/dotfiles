-- Tab 1 is the conversation view: it reveals each file another process
-- publishes with `ya pub-to <id> topic --str <path>` and shows only the
-- preview. Other tabs are ordinary file views that topics never touch.

local files_ratio = { rt.mgr.ratio[1], rt.mgr.ratio[2], rt.mgr.ratio[3] }
local in_conversation = true

local function apply_layout()
	local conversation = cx.tabs.idx == 1
	if conversation == in_conversation then
		return
	end
	if conversation then
		local r = rt.mgr.ratio
		files_ratio = { r[1], r[2], r[3] }
		rt.mgr.ratio = { 0, 0, 1 }
	else
		rt.mgr.ratio = files_ratio
	end
	in_conversation = conversation
	ya.emit("app:resize", {})
end

rt.mgr.ratio = { 0, 0, 1 }
ya.emit("tab_rename", { "conversation" })
ya.emit("tab_create", { current = true })
ya.emit("tab_rename", { "files" })
ya.emit("tab_switch", { 0 })

ps.sub("tab", apply_layout)

ps.sub_remote("topic", function(path)
	ya.emit("reveal", { path, tab = cx.tabs[1].id, no_dummy = true })
end)
