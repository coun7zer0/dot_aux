# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.packages/.oh-my-zsh"

# Virtualenvwrappery
export WORKON_HOME="$HOME/.pythonenvs"
source /usr/bin/virtualenvwrapper.sh


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="obraun"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  sudo
  zsh-syntax-highlighting
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

# User configuration

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

## para que funcione NVM
source /usr/share/nvm/init-nvm.sh

# Configuración para la conección a la database
## Para que funcione en emacs tiene que ir es el archivo ~/.start/emacsenv.sh
export SQL_USER="root"
export SQL_PASSWORD="root"
export SQL_DATABASE="czlibrary"
export SQL_SERVER="localhost"

# Configuración para springboot
export SQL_URL="jdbc:mariadb://${SQL_SERVER}:3306/${SQL_DATABASE}"
export JWT_SECRET="mySuperSecretKeyThatIsLongEnough123456"

# Para arrancar emacs
emacsenv () {
    emacs
}

