{ pkgs, ... }: {

  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # --- Core CLI ---
    bat
    bottom
    eza
    fd
    fzf
    jq
    ripgrep
    wget
    yazi
    lazydocker

    # --- Git (required by nix flakes, minimal) ---
    git

    # --- Editor ---
    neovim

    # --- Terminal ---
    fish
    starship
    zoxide
    atuin
  ];

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;

    shellInit = ''
      set -x XDG_CONFIG_HOME ~/.config
      set -x EDITOR nvim

      starship init fish | source
      zoxide init fish | source
      atuin init fish | source
      fzf --fish | source
    '';

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -la --icons";
      cat = "bat --plain";
      ld = "lazydocker";
    };

    functions = {
      vim = ''
        if test (count $argv) -eq 0
          nvim .
        else
          nvim $argv
        end
      '';
    };
  };


  programs.starship = {
    enable = true;
    enableFishIntegration = false; # manually sourced in fish shellInit
    settings = {
      format = builtins.concatStringsSep "" [
        "[](red)"
        "$os"
        "$username"
        "[](bg:peach fg:red)"
        "$directory"
        "[](bg:yellow fg:peach)"
        "$git_branch"
        "$git_status"
        "[](fg:yellow bg:green)"
        "$golang"
        "$nodejs"
        "$python"
        "$rust"
        "[](fg:green bg:lavender)"
        "$time"
        "[ ](fg:lavender)"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      palette = "catppuccin_mocha";
      os = { disabled = false; style = "bg:red fg:crust"; };
      "os.symbols" = { Debian = "󰣚"; Linux = "󰌽"; Ubuntu = "󰕈"; };
      username = { show_always = true; style_user = "bg:red fg:crust"; style_root = "bg:red fg:crust"; format = "[ $user]($style)"; };
      directory = { style = "bg:peach fg:crust"; format = "[ $path ]($style)"; truncation_length = 3; truncation_symbol = "…/"; };
      git_branch = { symbol = ""; style = "bg:yellow"; format = "[[ $symbol $branch ](fg:crust bg:yellow)]($style)"; };
      git_status = { style = "bg:yellow"; format = "[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style)"; };
      golang = { symbol = ""; style = "bg:green"; format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)"; };
      nodejs = { symbol = ""; style = "bg:green"; format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)"; };
      python = { symbol = ""; style = "bg:green"; format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)"; };
      rust = { symbol = ""; style = "bg:green"; format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)"; };
      time = { disabled = false; time_format = "%R"; style = "bg:lavender"; format = "[[  $time ](fg:crust bg:lavender)]($style)"; };
      line_break = { disabled = true; };
      character = { success_symbol = "[❯](bold fg:green)"; error_symbol = "[❯](bold fg:red)"; };
      cmd_duration = { show_milliseconds = true; format = " in $duration "; disabled = false; };
      "palettes.catppuccin_mocha" = {
        rosewater = "#f5e0dc"; flamingo = "#f2cdcd"; pink = "#f5c2e7"; mauve = "#cba6f7";
        red = "#f38ba8"; maroon = "#eba0ac"; peach = "#fab387"; yellow = "#f9e2af";
        green = "#a6e3a1"; teal = "#94e2d5"; sky = "#89dceb"; sapphire = "#74c7ec";
        blue = "#89b4fa"; lavender = "#b4befe"; text = "#cdd6f4"; subtext1 = "#bac2de";
        subtext0 = "#a6adc8"; overlay2 = "#9399b2"; overlay1 = "#7f849c"; overlay0 = "#6c7086";
        surface2 = "#585b70"; surface1 = "#45475a"; surface0 = "#313244";
        base = "#1e1e2e"; mantle = "#181825"; crust = "#11111b";
      };
    };
  };

  # --- Dotfiles (raw config symlinks) ---
  xdg.configFile = {
    "atuin" = { source = ./dotfiles/atuin; recursive = true; };
    "bat" = { source = ./dotfiles/bat; recursive = true; };
    "yazi" = { source = ./dotfiles/yazi; recursive = true; };
    "lazydocker" = { source = ./dotfiles/lazydocker; recursive = true; };
    "nvim" = { source = ./dotfiles/nvim; recursive = true; };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
