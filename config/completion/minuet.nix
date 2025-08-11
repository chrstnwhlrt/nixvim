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
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM";
            name = "Ollama";
            end_point = "http://localhost:11434/v1/completions";
            model = "qwen3-coder";
            optional = {
              max_tokens = 56;
              top_p = 0.9;
            };
          };
        };
      };
    };
  };
}
