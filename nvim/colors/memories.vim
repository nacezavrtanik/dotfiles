" Name:         memories
" Description:  A dark colorscheme for 4-bit terminals.
" Author:       Nace Zavrtanik <zavrtaniknace@gmail.com>
" Website:      https://www.github.com/nacezavrtanik/dotfiles
" License:      MIT

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

" Unused groups, configure if required.
hi! link debugPC Normal
hi! link debugBreakpoint Normal
hi! link SpellBad Normal
hi! link SpellCap Normal
hi! link SpellLocal Normal
hi! link SpellRare Normal
hi! link SignColumn Normal
hi! link diffAdded Normal
hi! link diffRemoved Normal
hi! link diffSubname Normal
hi! link dirType Normal
hi! link dirPermissionUser Normal
hi! link dirPermissionGroup Normal
hi! link dirPermissionOther Normal
hi! link dirOwner Normal
hi! link dirGroup Normal
hi! link dirTime Normal
hi! link dirSize Normal
hi! link dirSizeMod Normal
hi! link FilterMenuDirectorySubtle Normal
hi! link dirFilterMenuBookmarkPath Normal
hi! link dirFilterMenuHistoryPath Normal
hi! link FilterMenuLineNr Normal
hi! link CocSearch Normal
hi! link Ignore Normal
hi! link Conceal Normal
hi! link Type Normal
hi! link PreProc Normal

" Custom links and highlight groups.
hi! link markdownRule markdownListMarker
hi! link markdownCode String
hi! link markdownCodeBlock String
hi! link Special Constant
hi! link Statusline SelectedItem
hi! link TabLineSel SelectedItem
hi! link VertSplit TextlessBorder
hi! link WinSeparator TextlessBorder
hi! link TabLineFill TextlessBorder
hi! link StatuslineNC TextfulBorder
hi! link Comment GreyedOut
hi! link NonText GreyedOut
hi! link FoldColumn GreyedOut
hi! link SpecialKey GreyedOut
hi! link EndOfBuffer GreyedOut
hi! link TabLine TextfulBorder
hi! link CursorLineNr BoldCursor
hi! link MatchParen BoldCursor
hi! link Search NormalCursor
hi! link CurSearch InverseCursor
hi! link IncSearch InverseCursor
hi! link Visual InverseCursor
hi! link VisualNOS InverseCursor
hi! link Title BoldBright
hi! link Identifier BoldBright
hi! link Function BoldBright
hi! link PmenuKind PmenuInfo
hi! link PmenuExtra PmenuInfo
hi! link PmenuKindSel PmenuInfoSel
hi! link PmenuExtraSel PmenuInfoSel

hi Normal ctermfg=251 ctermbg=16

hi SelectedItem ctermfg=8 ctermbg=7 cterm=bold
hi WildMenu ctermfg=8 ctermbg=7 cterm=bold,reverse
hi QuickFixLine ctermfg=7 ctermbg=234 cterm=NONE
hi Pmenu ctermfg=240 ctermbg=235 cterm=NONE
hi PmenuInfo ctermfg=240 ctermbg=235 cterm=italic
hi PmenuSel ctermfg=7 ctermbg=234 cterm=NONE
hi PmenuInfoSel ctermfg=7 ctermbg=234 cterm=italic
hi PmenuSbar ctermfg=234 ctermbg=234 cterm=NONE
hi PmenuThumb ctermfg=7 ctermbg=7 cterm=NONE
hi TextlessBorder ctermfg=235 ctermbg=235 cterm=NONE
hi TextfulBorder ctermfg=240 ctermbg=235 cterm=NONE
hi GreyedOut ctermfg=239 ctermbg=NONE cterm=italic
hi Folded ctermfg=239 ctermbg=234 cterm=NONE
hi ColorColumn ctermfg=NONE ctermbg=234 cterm=NONE
hi CursorColumn ctermfg=NONE ctermbg=234 cterm=NONE
hi CursorLine ctermfg=NONE ctermbg=234 cterm=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline
hi BoldBright ctermfg=254 ctermbg=NONE cterm=bold

hi BoldCursor ctermfg=3 ctermbg=NONE cterm=bold
hi NormalCursor ctermfg=3 ctermbg=NONE cterm=NONE
hi InverseCursor ctermfg=3 ctermbg=16 cterm=reverse
hi LineNr ctermfg=4 ctermbg=NONE cterm=NONE

hi ModeMsg ctermfg=1 ctermbg=NONE cterm=bold,reverse
hi ErrorMsg ctermfg=1 ctermbg=NONE cterm=bold
hi WarningMsg ctermfg=1 ctermbg=NONE cterm=NONE
hi Error ctermfg=1 ctermbg=NONE cterm=NONE
hi Todo ctermfg=1 ctermbg=NONE cterm=italic

hi MoreMsg ctermfg=6 ctermbg=NONE cterm=italic
hi Question ctermfg=6 ctermbg=NONE cterm=italic
hi Directory ctermfg=6 ctermbg=NONE cterm=bold

hi String ctermfg=7 ctermbg=NONE cterm=NONE
hi Constant ctermfg=5 ctermbg=NONE cterm=NONE
hi Statement ctermfg=2 ctermbg=NONE cterm=NONE

hi DiffAdd ctermfg=49 ctermbg=23 cterm=NONE
hi DiffChange ctermfg=NONE ctermbg=234 cterm=NONE
hi DiffText ctermfg=51 ctermbg=25 cterm=NONE
hi DiffDelete ctermfg=16 ctermbg=16 cterm=NONE

" Analogous markdown highlights are linked to these groups.
hi htmlBold ctermfg=NONE ctermbg=NONE cterm=bold
hi htmlItalic ctermfg=NONE ctermbg=NONE cterm=italic
hi htmlUnderline ctermfg=NONE ctermbg=NONE cterm=underline
hi htmlBoldItalic ctermfg=NONE ctermbg=NONE cterm=bold,italic
hi htmlBoldUnderline ctermfg=NONE ctermbg=NONE cterm=bold,underline
hi htmlItalicUnderline ctermfg=NONE ctermbg=NONE cterm=italic,underline
hi htmlBoldItalicUnderline ctermfg=NONE ctermbg=NONE cterm=bold,italic,underline
