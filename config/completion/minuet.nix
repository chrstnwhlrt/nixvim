{ lib, config, ... }:
{
  options = {
    minuet.enable = lib.mkEnableOption "Enable minuet AI completion";
  };
  config = lib.mkIf config.minuet.enable {
    plugins.minuet = {
      enable = true;
      settings = {
        provider = "openai_fim_compatible";
        n_completions = 1;
        context_window = 512;
        auto_trigger_chars = []; # Disable auto-trigger
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM";
            name = "Ollama";
            end_point = "http://localhost:11434/v1/completions";
            model = "qwen2.5-coder:latest";
            optional = {
              max_tokens = 56;
              top_p = 0.9;
            };
          };
        };
      };
    };
    
    # Manual trigger keybindings for minuet
    keymaps = [
      {
        mode = "i";
        key = "<C-g>";
        action.__raw = "function() require('minuet').make_completion_and_show() end";
        options = {
          silent = true;
          desc = "Trigger Minuet AI completion";
        };
      }
      {
        mode = "i";
        key = "<C-y>";
        action.__raw = "function() require('minuet').accept_completion() end";
        options = {
          silent = true;
          desc = "Accept Minuet completion";
        };
      }
      {
        mode = "i";
        key = "<C-Right>";
        action.__raw = "function() require('minuet').cycle_completions_next() end";
        options = {
          silent = true;
          desc = "Next Minuet completion";
        };
      }
      {
        mode = "i";
        key = "<C-Left>";
        action.__raw = "function() require('minuet').cycle_completions_prev() end";
        options = {
          silent = true;
          desc = "Previous Minuet completion";
        };
      }
      {
        mode = "i";
        key = "<C-x>";
        action.__raw = "function() require('minuet').clear_completions() end";
        options = {
          silent = true;
          desc = "Clear Minuet completions";
        };
      }
    ];
  };
}
