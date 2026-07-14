# Github API to get latest tag

# robo3t

curl --silent "https://api.github.com/repos/Studio3T/robomongo/releases/latest"
curl --silent "https://api.github.com/repos/Studio3T/robomongo/releases/latest" |grep browser_download_url
curl --silent "https://api.github.com/repos/Studio3T/robomongo/releases/latest" |grep browser_download_url | grep tar.gz |grep -Po '"browser_download_url": "\K.*?(?=")'`

# Catppuccin gtk theme
wget `curl --silent "https://api.github.com/repos/catppuccin/gtk/releases/latest" |grep browser_download_url | grep Catppuccin-dark-compact.zip |grep -Po '"browser_download_url": "\K.*?(?=")'` -O ~/tmp/Catppuccin-dark-compact.zip

# Font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/`curl --silent "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" |grep tag_name |awk '{print $2}' |sed 's/\"//g; s/\,//g'`/Agave.zip -O ~/.local/share/fonts/Agave.zip
