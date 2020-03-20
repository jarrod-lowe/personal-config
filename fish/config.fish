for file in ~/.config/fish/theme-bobthefish/functions/*.fish
  source $file
end
for file in ~/.config/fish/theme-bobthefish/*.fish
  source $file
end

[ -x /usr/bin/vim ] ; and set -x EDITOR /usr/bin/vim
reagent
