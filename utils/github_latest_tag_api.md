# Github API to get latest tag

# robo3t

curl --silent "https://api.github.com/repos/Studio3T/robomongo/releases/latest"
curl --silent "https://api.github.com/repos/Studio3T/robomongo/releases/latest" |grep browser_download_url
curl --silent "https://api.github.com/repos/Studio3T/robomongo/releases/latest" |grep browser_download_url | grep tar.gz |grep -Po '"browser_download_url": "\K.*?(?=")'`
