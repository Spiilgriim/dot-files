# Defined in - @ line 1
function dotfile --wraps='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME' --description 'alias dotfile=/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
  /usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME $argv;
end