{ lib, config, ... }:
let
  mk = key: fn: desc: {
    mode = "n";
    inherit key;
    action.__raw = "function() ${fn} end";
    options = {
      silent = true;
      inherit desc;
    };
  };
in
{
  options = {
    snacks-picker-keys.enable = lib.mkEnableOption "Enable snacks.picker keymaps";
  };
  config = lib.mkIf config.snacks-picker-keys.enable {
    keymaps = [
      # Files & search
      (mk "<leader>ff" "Snacks.picker.files()"               "Find files")
      (mk "<leader>fr" "Snacks.picker.recent()"              "Recent files")
      (mk "<leader>fb" "Snacks.picker.buffers()"             "Buffers")
      (mk "<leader>ft" "Snacks.picker.grep()"                "Grep (root)")
      (mk "<leader>fa" "Snacks.picker.grep()"                "Grep (with args)")
      (mk "<C-p>"      "Snacks.picker.git_files()"           "Git files")
      (mk "<leader>:"  "Snacks.picker.command_history()"     "Command history")

      # Git
      (mk "<leader>gc" "Snacks.picker.git_log()"             "Git commits")
      (mk "<leader>gs" "Snacks.picker.git_status()"          "Git status")

      # Search (s-prefix)
      (mk "<leader>sa" "Snacks.picker.autocmds()"            "Autocommands")
      (mk "<leader>sb" "Snacks.picker.lines()"               "Buffer lines")
      (mk "<leader>sc" "Snacks.picker.command_history()"     "Command history")
      (mk "<leader>sC" "Snacks.picker.commands()"            "Commands")
      (mk "<leader>sD" "Snacks.picker.diagnostics()"         "Workspace diagnostics")
      (mk "<leader>sd" "Snacks.picker.diagnostics_buffer()"  "Document diagnostics")
      (mk "<leader>sh" "Snacks.picker.help()"                "Help pages")
      (mk "<leader>sH" "Snacks.picker.highlights()"          "Highlight groups")
      (mk "<leader>sk" "Snacks.picker.keymaps()"             "Keymaps")
      (mk "<leader>sM" "Snacks.picker.man()"                 "Man pages")
      (mk "<leader>sm" "Snacks.picker.marks()"               "Marks")
      (mk "<leader>sR" "Snacks.picker.resume()"              "Resume picker")
      (mk "<leader>st"
          "Snacks.picker.grep({ search = [[\\b(TODO|FIXME|HACK|NOTE|WARNING|PERF|TEST|XXX)\\b]], regex = true })"
          "Todos")

      # UI
      (mk "<leader>uC" "Snacks.picker.colorschemes()"        "Colorscheme preview")
    ];
  };
}
