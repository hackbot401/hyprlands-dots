-- ============================================================================
-- 🧰 setup {{{
local lualine_ok, lualine = pcall(require, "lualine")
if not lualine_ok then
	vim.api.nvim_echo({
        {
            "Error: lualine plugin not found... skipping relevant setup()",
            "Error"
        }
    }, true, {})
	return
end

local additional_colors_ok, p = pcall(require, "vagari.palette")
if not additional_colors_ok then
	vim.api.nvim_echo({
        {
            "Error: lualine config has impored vagari.nvim that are not found, skipping setup",
            "Error"
        }
    }, true, {})
	return
end
-- }}}
-- ============================================================================

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local branch = {
	"branch",
	icon = "",
}

-- see lualine.nvim/lua/lualine/utils/mode.lua for mode names
local modes = {
	["NORMAL"] = "",
	["O-PENDING"] = "",
	["INSERT"] = "",
	["VISUAL"] = "",
	["SELECT"] = "",
	["V-LINE"] = "",
	["V-BLOCK"] = "",
	["COMMAND"] = "",
	["REPLACE"] = "",
}

local mode = {
	"mode",
	fmt = function(str)
		if modes[str] then
			return modes[str]
		end
		return str
	end,
}

local lsp_diagnostics = {
	"diagnostics",

	sources = { "nvim_diagnostic" },
	sections = { "error", "warn", "hint", "info" },
	symbols = { error = " ", warn = " ", hint = " ", info = " " },
	colored = false,
	update_in_insert = false,
	padding = { left = 1, right = 1 },
	cond = hide_in_width,
}

local diff = {
	"diff",
	colored = true,
	symbols = {
		added = " ",
		modified = "🞊 ",
		removed = " ",
	},
	cond = hide_in_width,
}

local filetype = {
	"filetype",
	colored = false,
	icon_only = false,
	padding = { left = 0, right = 1 },
}

local filename = {
	"filename",
	file_status = true,
	path = 0,
	icon = "",
	symbols = {
		modified = "🞊",
		readonly = "",
		unnamed = "名前?",
	},
	color = function()
		local mode_color = {
			n = p.blu_4,
			i = p.grn_4,
			v = p.prp_4,
			V = p.prp_4,
			c = p.orn_4,
			R = p.emr_4,
			s = p.cyn_4,
			S = p.cyn_4,
			[""] = p.prp_4,
		}
		return { fg = mode_color[vim.fn.mode()] }
	end,
}

local lsp_progress = {
	"lsp_progress",
	display_components = {
		"lsp_client_name",
		"spinner",
	},
	timer = {
		progress_enddelay = 100,
		spinner = 100,
		lsp_client_name_enddelay = 3000,
	},
	message = {
		commenced = "󱞇 ",
		completed = "󱞈 ",
	},
	separators = {
		component = " ",
		progress = "",
		message = { pre = "", post = " " },
		percentage = { pre = "", post = "%% " },
		title = { pre = "", post = "" },
		lsp_client_name = { pre = " ", post = "" },
		spinner = { pre = "", post = "" },
	},
	spinner_symbols = { " ", " ", " ", " ", " ", " " },
}

local search = {
	function()
		local last_search = vim.fn.getreg("/")
		if not last_search or last_search == "" then
			return ""
		end
		local searchcount = vim.fn.searchcount({ maxcount = 9999 })
		if searchcount.total == 0 then
			vim.cmd([[ :call setreg("/", [''])<CR> ]])
		end
		return " " .. last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
	end,
	color = { fg = p.orn_2 },
}

local function icon()
	return [[ ]]
end

local lazy = {
	require("lazy.status").updates,
	cond = require("lazy.status").has_updates,
	color = { fg = p.glc_4 },
}

lualine.setup({
	options = {
		theme = "vagari",
		section_separators = { left = "", right = "" },
		component_separators = { left = "⊸", right = "⟜" },
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { branch, filename },
		lualine_c = { diff, lsp_diagnostics },
		lualine_x = { lazy, lsp_progress, search },
		lualine_y = { filetype },
		lualine_z = { icon },
	},
	inactive_sections = {},
	tabline = {},
})
