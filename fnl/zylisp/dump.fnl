(module zylisp.dump
  {autoload {nvim aniseed.nvim}})

(defn dump [...]
  (print
    (unpack
      (vim.tbl_map vim.inspect [...]))))

(set _G.lispdump dump)
