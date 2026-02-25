" Name:         memories
" Description:  A very minimal 4-bit colorscheme.
" Author:       Nace Zavrtanik <zavrtaniknace@gmail.com>
" Website:      https://www.github.com/nacezavrtanik/dotfiles
" License:      MIT

" The 4-bit ANSI colors, as well as the backround color, are inherited from
" the terminal theme. Note that since `memories` uses black (ANSI 0) as an
" actual color, this will render certain highlight groups invisible for
" terminal themes that do not distingish black from the background.

" Loosely based on the `lunaperche` Vim colorscheme.


set background=dark

hi clear
let g:colors_name = 'memories'


hi! link helpVim Title
hi! link helpHeader Title
hi! link helpHyperTextJump Underlined
hi! link fugitiveSymbolicRef PreProc
hi! link fugitiveHeading Statement
hi! link fugitiveStagedHeading Statement
hi! link fugitiveUnstagedHeading Statement
hi! link fugitiveUntrackedHeading Statement
hi! link fugitiveStagedModifier PreProc
hi! link fugitiveUnstagedModifier PreProc
hi! link fugitiveHash Constant
hi! link diffFile PreProc
hi! link markdownHeadingDelimiter Special
hi! link rstSectionDelimiter Statement
hi! link rstDirective PreProc
hi! link rstHyperlinkReference Special
hi! link rstFieldName Constant
hi! link rstDelimiter Special
hi! link rstInterpretedText Special
hi! link rstCodeBlock Normal
hi! link rstLiteralBlock rstCodeBlock
hi! link markdownUrl String
hi! link colortemplateKey Statement
hi! link xmlTagName Statement
hi! link javaScriptFunction Statement
hi! link javaScriptIdentifier Statement
hi! link sqlKeyword Statement
hi! link yamlBlockMappingKey Statement
hi! link rubyMacro Statement
hi! link rubyDefine Statement
hi! link vimGroup Normal
hi! link vimVar Normal
hi! link vimOper Normal
hi! link vimSep Normal
hi! link vimParenSep Normal
hi! link vimOption Normal
hi! link vimCommentString Comment
hi! link pythonInclude Statement
hi! link shQuote Constant
hi! link shNoQuote Normal
hi! link shTestOpr Normal
hi! link shOperator Normal
hi! link shSetOption Normal
hi! link shOption Normal
hi! link shCommandSub Normal
hi! link shDerefPattern shQuote
hi! link shDerefOp Special
hi! link phpStorageClass Statement
hi! link phpStructure Statement
hi! link phpInclude Statement
hi! link phpDefine Statement
hi! link phpSpecialFunction Normal
hi! link phpParent Normal
hi! link phpComparison Normal
hi! link phpOperator Normal
hi! link phpVarSelector Special
hi! link phpMemberSelector Special
hi! link phpDocCustomTags phpDocTags
hi! link javaExternal Statement
hi! link javaType Statement
hi! link javaScopeDecl Statement
hi! link javaClassDecl Statement
hi! link javaStorageClass Statement
hi! link javaDocParam PreProc
hi! link csStorage Statement
hi! link csAccessModifier Statement
hi! link csClass Statement
hi! link csModifier Statement
hi! link csAsyncModifier Statement
hi! link csLogicSymbols Normal
hi! link csClassType Normal
hi! link csType Statement
hi! link Terminal Normal
hi! link StatuslineTerm Statusline
hi! link StatuslineTermNC StatuslineNC
hi! link LineNrAbove LineNr
hi! link LineNrBelow LineNr
hi! link MessageWindow PMenu
hi! link PopupNotification Todo
hi! link markdownRule markdownListMarker
hi! link markdownCode String
hi! link markdownCodeBlock String
hi! link PmenuKind PmenuInfo
hi! link PmenuExtra PmenuInfo
hi! link PmenuKindSel PmenuInfoSel
hi! link PmenuExtraSel PmenuInfoSel
hi! link VisualNOS Visual
hi! link lCursor Cursor
hi! link TermCursor Cursor
hi! link VertSplit WinSeparator
hi! link Special Constant


hi! link debugPC                   Normal
hi! link debugBreakpoint           Normal
hi! link SpellBad                  Normal
hi! link SpellCap                  Normal
hi! link SpellLocal                Normal
hi! link SpellRare                 Normal
hi! link SignColumn                Normal
hi! link diffAdded                 Normal
hi! link diffRemoved               Normal
hi! link diffSubname               Normal
hi! link dirType                   Normal
hi! link dirPermissionUser         Normal
hi! link dirPermissionGroup        Normal
hi! link dirPermissionOther        Normal
hi! link dirOwner                  Normal
hi! link dirGroup                  Normal
hi! link dirTime                   Normal
hi! link dirSize                   Normal
hi! link dirSizeMod                Normal
hi! link FilterMenuDirectorySubtle Normal
hi! link dirFilterMenuBookmarkPath Normal
hi! link dirFilterMenuHistoryPath  Normal
hi! link FilterMenuLineNr          Normal
hi! link CocSearch                 Normal
hi! link Ignore                    Normal
hi! link Conceal                   Normal
hi! link Type                      Normal
hi! link PreProc                   Normal


" MARKDOWN
" Analogous markdown highlights are linked to these groups.
hi htmlBold                ctermfg=none ctermbg=none cterm=bold
hi htmlItalic              ctermfg=none ctermbg=none cterm=italic
hi htmlUnderline           ctermfg=none ctermbg=none cterm=underline
hi htmlBoldItalic          ctermfg=none ctermbg=none cterm=bold,italic
hi htmlBoldUnderline       ctermfg=none ctermbg=none cterm=bold,underline
hi htmlItalicUnderline     ctermfg=none ctermbg=none cterm=italic,underline
hi htmlBoldItalicUnderline ctermfg=none ctermbg=none cterm=bold,italic,underline
" Treesitter highlights.
hi! link @markup.heading.1             GreenOnNoneBold
hi! link @markup.heading.2             GreenOnNoneBold
hi! link @markup.heading.3             MagentaOnNoneBold
hi! link @markup.heading.4             MagentaOnNoneItalic
hi! link @markup.heading.5             MagentaOnNoneItalic
hi! link @markup.heading.6             MagentaOnNoneItalic
hi! link @markup.link                  GreenOnNone
hi! link @markup.link.label            GreenOnNone
hi! link @markup.link.url              BlackOnNoneItalicUnderline
hi! link @markup.list                  MagentaOnNone
hi! link @markup.list.checked          MagentaOnNone
hi! link @markup.list.unchecked        CyanOnNone
hi! link @markup.raw                   CyanOnNone
hi! link @markup.quote                 WhiteOnNoneItalic
hi! link @markup.math                  CyanOnNone
hi! link @label.markdown               BlackOnNone
hi! link @punctuation.special.markdown BlackOnNone

hi! link Normal        WhiteOnNone
hi! link StatuslineNC  WhiteOnNone
hi! link TabLine       WhiteOnNone
hi! link WildMenu      WhiteOnNoneBold
hi! link Title         WhiteOnNoneBold
hi! link Identifier    WhiteOnNoneBold
hi! link Function      WhiteOnNoneBold
hi! link QuickFixLine  WhiteOnBlack
hi! link Pmenu         WhiteOnBlack
hi! link PmenuInfo     WhiteOnBlackItalic
hi! link PmenuThumb    WhiteOnWhite
hi! link TabLineFill   BlackOnNone
hi! link WinSeparator  BlackOnNone
hi! link FoldColumn    BlackOnNone
hi! link NonText       BlackOnNoneItalic
hi! link SpecialKey    BlackOnNoneItalic
hi! link EndOfBuffer   BlackOnNoneItalic
hi! link Comment       BrightBlackOnNoneItalic
hi! link Folded        BrightBlackOnNoneItalic
hi! link PmenuSel      BlackOnWhite
hi! link ComplMatchIns BlackOnWhite
hi! link PreInsert     BlackOnWhite
hi! link Statusline    BlackOnWhiteBold
hi! link TabLineSel    BlackOnWhiteBold
hi! link PmenuInfoSel  BlackOnWhiteItalic
hi! link PmenuSbar     BlackOnBlack
hi! link ColorColumn   NoneOnBlack
hi! link CursorColumn  NoneOnBlack
hi! link CursorLine    NoneOnBlack

hi! link Search       YellowOnNone
hi! link CursorLineNr YellowOnNoneBold
hi! link MatchParen   YellowOnNoneBold
hi! link CurSearch    YellowOnBlueBold
hi! link LineNr       BlueOnNone
hi! link IncSearch    BlackOnYellow
hi! link Cursor       BlackOnYellow
hi! link Visual       BlackOnYellow

hi! link ModeMsg    RedOnNoneBoldReverse
hi! link ErrorMsg   RedOnNoneBold
hi! link WarningMsg RedOnNone
hi! link Error      RedOnNone
hi! link Todo       RedOnNoneItalic
hi! link OkMsg      GreenOnNone
hi! link MoreMsg    BlueOnNoneItalic
hi! link Question   BlueOnNoneItalic
hi! link Directory  BlueOnNoneBold

hi! link Statement GreenOnNone
hi! link Constant  MagentaOnNone
hi! link String    CyanOnNone

hi! link DiffAdd    WhiteOnBrightGreen
hi! link DiffText   WhiteOnBrightBlue
hi! link DiffChange NoneOnBlack
hi! link DiffDelete BlackOnNone

hi NoneOnBlack                ctermfg=none ctermbg=0    cterm=none
hi BlackOnNone                ctermfg=0    ctermbg=none cterm=none
hi BlackOnNoneItalic          ctermfg=0    ctermbg=none cterm=italic
hi BlackOnNoneItalicUnderline ctermfg=0    ctermbg=none cterm=italic,underline
hi BlackOnBlack               ctermfg=0    ctermbg=0    cterm=none
hi BlackOnYellow              ctermfg=0    ctermbg=3    cterm=none
hi BlackOnWhite               ctermfg=0    ctermbg=7    cterm=none
hi BlackOnWhiteBold           ctermfg=0    ctermbg=7    cterm=bold
hi BlackOnWhiteItalic         ctermfg=0    ctermbg=7    cterm=italic
hi RedOnNone                  ctermfg=1    ctermbg=none cterm=none
hi RedOnNoneBold              ctermfg=1    ctermbg=none cterm=bold
hi RedOnNoneBoldReverse       ctermfg=1    ctermbg=none cterm=bold,reverse
hi RedOnNoneItalic            ctermfg=1    ctermbg=none cterm=italic
hi GreenOnNone                ctermfg=2    ctermbg=none cterm=none
hi GreenOnNoneBold            ctermfg=2    ctermbg=none cterm=bold
hi YellowOnNone               ctermfg=3    ctermbg=none cterm=none
hi YellowOnNoneBold           ctermfg=3    ctermbg=none cterm=bold
hi YellowOnBlueBold           ctermfg=3    ctermbg=4    cterm=bold
hi BlueOnNone                 ctermfg=4    ctermbg=none cterm=none
hi BlueOnNoneBold             ctermfg=4    ctermbg=none cterm=bold
hi BlueOnNoneItalic           ctermfg=4    ctermbg=none cterm=italic
hi MagentaOnNone              ctermfg=5    ctermbg=none cterm=none
hi MagentaOnNoneBold          ctermfg=5    ctermbg=none cterm=bold
hi MagentaOnNoneItalic        ctermfg=5    ctermbg=none cterm=italic
hi CyanOnNone                 ctermfg=6    ctermbg=none cterm=none
hi WhiteOnNone                ctermfg=7    ctermbg=none cterm=none
hi WhiteOnNoneBold            ctermfg=7    ctermbg=none cterm=bold
hi WhiteOnNoneItalic          ctermfg=7    ctermbg=none cterm=italic
hi WhiteOnBlack               ctermfg=7    ctermbg=0    cterm=none
hi WhiteOnBlackItalic         ctermfg=7    ctermbg=0    cterm=italic
hi WhiteOnWhite               ctermfg=7    ctermbg=7    cterm=none
hi WhiteOnBrightGreen         ctermfg=7    ctermbg=10   cterm=none
hi WhiteOnBrightBlue          ctermfg=7    ctermbg=12   cterm=none
hi BrightBlackOnNoneItalic    ctermfg=8    ctermbg=none cterm=italic
