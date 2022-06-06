local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
	return
end

harpoon.setup({ global_settings = { enter_on_sendcmd = true } })
