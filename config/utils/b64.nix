{ lib, config, ... }:
{
  options = {
    b64.enable = lib.mkEnableOption "Enable base64 module";
  };
  config = lib.mkIf config.b64.enable {
    # Thin wrapper around vim.base64 (native since Neovim 0.10). Encodes
    # or decodes the current visual selection in place. Handles replacing
    # the selected range via nvim_buf_set_text so we don't touch paste
    # mode or pollute registers.
    extraConfigLua = ''
      b64 = {}

      local function transform_selection(op)
        local s = vim.fn.getpos([['<]])
        local e = vim.fn.getpos([['>]])
        local s_row, s_col = s[2] - 1, s[3] - 1
        local e_row = e[2] - 1
        -- Clamp end column: linewise visual yields MAXCOL for e[3].
        local line = vim.api.nvim_buf_get_lines(0, e_row, e_row + 1, false)[1] or ""
        local e_col = math.min(e[3], #line)
        if s_row > e_row or (s_row == e_row and s_col >= e_col) then return end
        local lines = vim.api.nvim_buf_get_text(0, s_row, s_col, e_row, e_col, {})
        local ok, out = pcall(op, table.concat(lines, "\n"))
        if not ok or not out then
          vim.notify("base64: " .. tostring(out), vim.log.levels.ERROR)
          return
        end
        vim.api.nvim_buf_set_text(0, s_row, s_col, e_row, e_col, vim.split(out, "\n", { plain = true }))
      end

      function b64.encode() transform_selection(vim.base64.encode) end
      function b64.decode() transform_selection(vim.base64.decode) end
    '';
    keymaps = [
      {
        mode = "v";
        key = "<leader>be";
        action = ":lua b64.encode()<cr>";
        options = {
          desc = "Encode selected text to base64";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>bd";
        action = ":lua b64.decode()<cr>";
        options = {
          desc = "Decode selected text from base64";
          silent = true;
        };
      }
    ];
  };
}
