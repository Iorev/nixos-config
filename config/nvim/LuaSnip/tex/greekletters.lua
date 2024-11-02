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
	-- Snippet
	s({
		trig = "@a",
		dscr = "Alpha Greek Letter",
		regTrig=false,
		priority=100,
		snippetType="autosnippet",
		condition=tex_utils.in_mathzone

	},
	{
		t("{\\alpha}"),
	}
	),

	-- Snippet
	s({trig="@b",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\beta}"),}
	),

	-- Snippet
	s({trig="@q",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\theta}"),}
	),

	-- Snippet
	s({trig="@g",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\gamma}"),}
	),

	-- Snippet
	s({trig="@G",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\Gamma}"),}
	),

	-- Snippet
	s({trig="@s",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\sigma}"),}
	),

	s({trig="@S",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\Sigma}"),}
	),

	-- Snippet
	s({trig="@p",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\pi}"),}
	),
	-- Snippet
	s({trig="@P",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\Pi}"),}
	),

	-- Snippet
	s({trig="@h",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\eta}"),}
	),

	-- Snippet
	s({trig="@r",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\rho}"),}
	),

	-- Snippet
	s({trig="@D",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\Delta}"),}
	),

	-- Snippet
	s({trig="@d",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\delta}"),}
	),

	-- Snippet
	s({trig="@t",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\tau}"),}
	),

	-- Snippet
	s({trig="@v",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\nu}"),}
	),

	-- Snippet
	s({trig="@w",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\psi}"),}
	),

	-- Snippet
	s({trig="@o",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\omega}"),}
	),

	-- Snippet
	s({trig="@O",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\Omega}"),}
	),

	-- Snippet
	s({trig="@e",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\varepsilon}"),}
	),

	-- Snippet
	s({trig="@f",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\phi}"),}
	),

	-- Snippet
	s({trig="@x",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\xi}"),}
	),

	-- Snippet
	s({trig="@c",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\chi}"),}
	),

	-- Snippet
	s({trig="@l",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\lambda}"),}
	),

	-- Snippet
	s({trig="@m",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\mu}"),}
	),

	-- Snippet
	s({trig="nab",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\nabla}"),}
	),

	-- Snippet
	s({trig="grad",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("\\underline{\\nabla}"),}
	),

}
