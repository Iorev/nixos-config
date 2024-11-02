local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

-- Some LaTeX-specific conditional expansion functions (requires VimTeX)

local tex_utils = {}
tex_utils.in_mathzone = function()  -- math context detection
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex_utils.in_text = function()
  return not tex_utils.in_mathzone()
end
tex_utils.in_comment = function()  -- comment detection
  return vim.fn['vimtex#syntax#in_comment']() == 1
end
tex_utils.in_env = function(name)  -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
tex_utils.in_equation = function()  -- equation environment detection
    return tex_utils.in_env('equation')
end
tex_utils.in_itemize = function()  -- itemize environment detection
    return tex_utils.in_env('itemize')
end
tex_utils.in_tikz = function()  -- TikZ picture environment detection
    return tex_utils.in_env('tikzpicture')
end

return {

	s({trig="ux",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("{u_x}"),}
	),
	s({trig="uy",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("{u_y}"),}
	),
	s({trig="uz",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("{u_z}"),}
	),
	s({trig="ui",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("{u_i}"),}
	),
	s({trig="uj",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("{u_j}"),}
	),
	s({trig="xi",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("{x_i}"),}
	),
	s({trig="xj",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("{x_j}"),}
	),

	s({trig="tij",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("\\tau_{ij}"),}
	),
	s({trig="dij",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("\\delta_{ij}"),}
	),
	s({trig="sij",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("\\sigma_{ij}"),}
	),
	s({trig="eijk",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	 {t("\\varepsilon_{ijk}"),}
	),
}
