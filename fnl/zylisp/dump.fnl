(module zylisp.dump)

(defn dump [...]
  (print
    (unpack
      (vim.tbl_map vim.inspect [...]))))

(set _G.lispdump dump)
