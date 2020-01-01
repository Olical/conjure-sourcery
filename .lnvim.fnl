;; Add the project directory to rtp for development.
(vim.api.nvim_set_option
  :runtimepath
  (.. (vim.api.nvim_get_option :runtimepath)
      ","
      (vim.api.nvim_call_function :getcwd [])))

;; Initialise the plugin.
(vim.api.nvim_command "source plugin/conjure.vim")
