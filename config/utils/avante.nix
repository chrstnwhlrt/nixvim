{ lib, config, ... }:
{
  options = {
    avante.enable = lib.mkEnableOption "Enable avante AI assistant";
  };
  config = lib.mkIf config.avante.enable {
    plugins.avante = {
      enable = true;
      settings = {
        provider = "ollama";
        providers = {
          ollama = {
            endpoint = "http://127.0.0.1:11434"; # Note: No /v1 at the end
            model = "qwen3-coder"; # Using qwen3-coder as requested
            extra_request_body = {
              options = {
                temperature = 0.75;
                num_ctx = 20480;
                keep_alive = "5m";
              };
            };
          };
        };
        windows = {
          position = "right";
          width = 30;
          sidebar_header = {
            align = "center";
            rounded = true;
          };
        };
        highlights = {
          diff = {
            current = "DiffText";
            incoming = "DiffAdd";
          };
        };
        hints = {
          enabled = true;
        };
        diff = {
          autojump = true;
          list_opener = "copen";
        };
      };
    };
  };
}
