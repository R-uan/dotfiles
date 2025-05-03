export PATH=$PATH:/home/ruan/.nvm/versions/node/v22.13.0/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
# Starship
eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
export PATH="$PATH:$HOME/.dotnet/tools"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

fastfetch
