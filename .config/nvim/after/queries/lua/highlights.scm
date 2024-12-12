;; extends

((identifier) @namespace.builtin
  (#eq? @namespace.builtin "vim"))

;((identifier) @namespace.builtin
;              (#eq? @namespace.builtin "vim"))
;
;((dot_index_expression) @_dot_index_expression
;                        (#match? @_dot_index_expression "^vim.cmd.*")
;                        (identifier) @lua.function.cmd)
;
;((identifier) @lua.parameter.self
;              (#match? @lua.parameter.self "^(self|this)$"))
;
;((function_call
;   (arguments
;     (identifier) @function.pcall.lua
;     (#match? @function.pcall.lua "^require$"))))
