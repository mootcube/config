#!/bin/bash
#HOME="/tmp/tmp"

cd ~
#$HOME
mkdir -p ~/usr
cd ~/usr
rm -rf \
cope \
dfc \


git_repos=$(cat .git_repositories)

for i in $git_repos;do
    git clone https://mootcube@github.com/mootcube/$i.git
done


#cd cope
#bash setup.sh

#cd ../dfc
#bash setup.sh

cd ~
chown $USER:$USER -R usr

