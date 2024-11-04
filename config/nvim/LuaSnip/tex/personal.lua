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
    	s({trig="sii", snippetType="autosnippet"},
      	fmta(
        	[[\si{<>}]],
        	{
        	  i(1),
        	}
      )
    ),
    s({trig="SI"},
      fmta(
        [[\SI{<>}{<>}]],
        {
          i(1),
          i(2)
        }
      )
    ),
    s({trig="udd"},
      fmta(
        [[\underline{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- VSPACE
    s({trig="vs"},
      fmta(
        [[\vspace{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- SECTION
    s({trig="h1", snippetType="autosnippet"},
      fmta(
        [[\section{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- SUBSECTION
    s({trig="h2", snippetType="autosnippet"},
      fmta(
        [[\subsection{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- SUBSUBSECTION
    s({trig="h3", snippetType="autosnippet"},
      fmta(
        [[\subsubsection{<>}]],
        {
          d(1, get_visual),
        }
      )
    ),
	-- Forall
	s({trig= "pogn",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	{t("\\forall"),}
	),
	-- norm
    	s({trig="norm", snippetType="autosnippet",condition = tex_utils.in_mathzone},
     	 fmta(
           [[||<>||]],
           {
	     d(1, get_visual),
     	   }
	   )
	),
	-- checkamrk
	s({trig= "check",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	{t("\\checkmark"),}
	),
	-- sim
	s({trig="~",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	{t("\\sim"),}
	),

	-- costante
	s({trig="cst",snippetType="autosnippet",condition = tex_utils.in_mathzone},
	{t("\\costante"),}
	),

	-- squareroot
	s({trig="sr",snippetType="autosnippet"},
	{t("^2"),}
	),

	-- Snippet
	s({trig="@8",snippetType="autosnippet",condtion=tex_utils.in_mathzone},
	{t("\\infty"),}
	),

	-- Snippet
	s({trig="ittt",snippetType="autosnippet",condtion=tex_utils.in_itemize},
	{t("\\item"),}
	),

	-- Snippet
	s({trig="benum", dscr="A LaTeX enumerate environment",snippetType="autosnippet"},
	fmt(
	[[
	\begin{enumerate}
		\item <>
	\end{enumerate}
	]],
	-- The insert node is placed in the <> angle brackets
	{ i(1) },
	-- This is where I specify that angle brackets are used as node positions.
	{ delimiters = "<>" }
	)
	),
	-- Snippet
	s({trig="bitem", dscr="A LaTeX itemize environment",snippetType="autosnippet"},
	fmt(
	[[
	\begin{itemize}
		\item <>
	\end{itemize}
	]],
	-- The insert node is placed in the <> angle brackets
	{ i(1) },
	-- This is where I specify that angle brackets are used as node positions.
	{ delimiters = "<>" }
	)
	),

	-- Snippet
	s({trig="beq", dscr="A LaTeX equation environment",snippetType="autosnippet"},
	fmt( -- The snippet code actually looks like the equation environment it produces.
	[[
	\begin{equation}
	  <>
	\end{equation}
	]],
	-- The insert node is placed in the <> angle brackets
	{ i(1) },
	-- This is where I specify that angle brackets are used as node positions.
	{ delimiters = "<>" }
	)
	),

	-- Snippet
	s({trig="gt", snippetType="autosnippet"},
	fmta(
	[[
	\begin{gather*}
	  <>
	\end{gather*}
	]],
	{
		i(1),
	}
	)
	),

	-- Snippet
	s({trig="env", snippetType="autosnippet"},
	fmta(
	[[
	\begin{<>}
	  <>
	\end{<>}
	]],
	{
		i(1),
		i(2),
		rep(1),  -- this node repeats insert node i(1)
	}
	)
	),

	-- Snippet
	s({trig = "tbb", dscr = "Expands 'tbb' into LaTeX's textit{} command.",snippetType="autosnippet"},
	fmta("\\textbf{<>}",
	{
		d(1, get_visual),
	}
	)
	),

	-- Snippet
	s({trig = "tii", dscr = "Expands 'tii' into LaTeX's textit{} command.",snippetType="autosnippet"},
	fmta("\\textit{<>}",
	{
		d(1, get_visual),
	}
	)
	),

	-- Snippet
	s({trig = "enf", dscr = "Expands 'enf' into LaTeX's emph{} command.",snippetType="autosnippet"},
	fmta("\\emph{<>}",
	{
		d(1, get_visual),
	}
	)
	),

	-- Snippet
	s({trig= "mk",snippetType="autosnippet"},
	fmta("$ <> $ ",
	{
		i(1)
	}
	)
	),

	-- Snippet
	s({trig= "dm",snippetType="autosnippet"},
	fmta(
	[[
	\[
	  <>
	\]
	]]
	,
	{
		i(1)
	}
	)
	),


	-- Snippet
	s({trig="new", dscr="A generic new environmennt"},
	fmta(
	[[
	\begin{<>}
	  <>
	\end{<>}
	]],
	{
		i(1),
		i(2),
		rep(1),
	}
	),
	{condition = line_begin}
	),
}
