(module zylisp.one.conjure
  {autoload {nvim aniseed.nvim}})

(set nvim.g.conjure#mapping#doc_word "K")
(set nvim.g.conjure#client#clojure#nrepl#eval#auto_require false)
(set nvim.g.conjure#client#clojure#nrepl#connection#auto_repl#enabled false)
(vim.cmd "let g:conjure#eval#inline_results=v:true")
(vim.cmd "let g:conjure#log#hud#enabled=v:false")
(vim.cmd "let g:conjure#highlight#enabled=v:true")
(vim.cmd "let g:conjure#highlight#group='Search'")
