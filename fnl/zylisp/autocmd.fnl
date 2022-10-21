(module zylisp.autocmd
  {autoload {nvim aniseed.nvim
             a    aniseed.core
             env  aniseed.env
             cs   ts_context_commentstring.internal}})

(def- group (nvim.create_augroup :K {:clear true}))

(defn- autocmd [name opts]
  (nvim.create_autocmd name (a.merge! {:group group} opts)))

(autocmd :BufWritePost
         {:pattern "*.fnl"
          :callback (lambda []
                      (env.init nvim.g.aniseed#env))})
