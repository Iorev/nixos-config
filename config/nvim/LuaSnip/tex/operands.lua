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
	s({trig="@.",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\cdot}"),}
	),

	-- Snippet
	s({trig="xx",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\times}"),}
	),

	-- Snippet
	s({trig=";.",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("{\\cdot}"),}
	),

	-- Snippet
	s({trig=";>",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("\\rightarrow"),}
	),

	-- Snippet
	s({trig=";<",snippetType="autosnippet",condition=tex_utils.in_mathzone},
	{t("\\leftarrow"),}
	),

	-- Snippet
	s({trig="ss",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	{t("^*"),}
	),


	-- Snippet
	s({trig="'",snippetType="snippet",condition = tex_utils.in_mathzone},
	{t("^{\\prime}"),}
	),
	s({trig="2'",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	{t("^{\\prime\\prime}"),}
	),
	s({trig="3'",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	{t("^{\\prime\\prime\\prime}"),}
	),

	-- Snippet
	s({trig="^",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "^{<>}",
	{
		i(1),
	}
	)
	),

	-- Snippet
	s({trig="_",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "_{<>}",
	{
		i(1),
	}
	)
	),

	-- snippet
	s({trig="'u",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "\\underline{<>}",
	{
		d(1,get_visual),
	}
	)
	),

	-- snippet
	s({trig=";u",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "\\underline{<>}",
	{
		i(1),
	}
	)
	),

	-- snippet
	s({trig="'t",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "\\text{<>}",
	{
		d(1,get_visual),
	}
	)
	),

	-- snippet
	s({trig="tilde",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "\\tilde{<>}",
	{
		i(1),
	}
	)
	),

	-- snippet
	s({trig="'o",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "\\overline{<>}",
	{
		d(1,get_visual),
	}
	)
	),

	-- snippet
	s({trig=";o",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "\\overline{<>}",
	{
		i(1),
	}
	)
	),

	-- snippet
	s({trig="'c",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "\\cancel{<>}",
	{
		d(1,get_visual),
	}
	)
	),

	-- snippet
	s({trig="cc",condition = tex_utils.in_mathzone},
	fmta( "\\cancel{<>}",
	{
		i(1),
	}
	)
	),

	-- Snippet
	s({trig="ff",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "\\frac{<>}{<>}",
	{
		i(1),
		i(2),
	}
	)
	),

	s({trig = "fi",condtion=tex_utils.in_mathzone},
	fmta("\\frac{<>}{<>}",
	{
		d(1, get_visual),
		i(2),
	}
	)
	),

	-- Snippet
	s({trig="df",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	fmta( "\\frac{\\diff <>}{\\diff <>}",
	{
		i(1),
		i(2),
	}
	)
	),

	s({trig = "DD",snippetType='autosnippet',condtion=tex_utils.in_mathzone},
	fmta("\\dermat{<>}{t}",
	{
		i(1),
	}
	)
	),

	s({trig = "dd",snippetType='autosnippet',condtion=tex_utils.in_mathzone},
	{t("{\\diff}"),}
	),

	s({trig = "pp",snippetType='autosnippet',condtion=tex_utils.in_mathzone},
	fmta("\\pdev{<>}{<>}",
	{
		i(1),
		i(2),
	}
	)
	),

	s({trig = "dpp",snippetType='autosnippet',condtion=tex_utils.in_mathzone},
	fmta("\\pdev{^2<>}{<>^2}",
	{
		i(1),
		i(2),
	}
	)
	),

	s({trig = "sq",snippetType='autosnippet',condtion=tex_utils.in_mathzone},
	fmta("\\sqrt{<>}",
	{
		i(1),
	}
	)
	),

	s({trig = "'q",snippetType='autosnippet',condtion=tex_utils.in_mathzone},
	fmta("\\sqrt{<>}",
	{
		d(1,get_visual),
	}
	)
	),

	s({trig = "in",snippetType='snippet',condtion=tex_utils.in_mathzone},
	fmta("\\integral{<>}{<>}{<>}{<>}",
	{
		i(1),
		i(2),
		i(3),
		i(4),
	}
	)
	),

	s({trig = "sum",snippetType='snippet',condtion=tex_utils.in_mathzone},
	fmta("\\sum_{<>}^{<>}",
	{
		i(1),
		i(2),
	}
	)
	),

	s({trig = "cos",snippetType='snippet',condtion=tex_utils.in_mathzone},
	fmta("\\cos {<>}",
	{
		i(1),
	}
	)
	),
	s({trig = "sin",snippetType='autosnippet',condtion=tex_utils.in_mathzone},
	fmta("\\sin {<>}",
	{
		i(1),
	}
	)
	),

	s({trig = "nrmm",snippetType='autosnippet',condtion=tex_utils.in_mathzone},
	fmta("\\| <> \\|",
	{
		i(1),
	}
	)
	),

	s({trig = "dot",snippetType='autosnippet',condtion=tex_utils.in_mathzone},
	fmta("\\dot{<>}",
	{
		i(1),
	}
	)
	),


}
