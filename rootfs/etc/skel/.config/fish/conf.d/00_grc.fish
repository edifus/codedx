#!/usr/bin/env fish
#
# To load in ~/.config/fish/fish.conf or a new file in
# ~/.config/fish/conf.d add:
# source /etc/grc.fish (path may depend on install method)
#
# See also the plugin at https://github.com/oh-my-fish/plugin-grc

set -U grc_plugin_execs \
    blkid cat cvs df diff dig dnf docker docker-compose docker-machine du \
    env fdisk findmnt free g++ gcc getfacl getsebool id ifconfig iostat ip \
    journalctl kubectl last lsattr lsblk lsmod lsof lspci make mount mtr \
    netstat nmap ping ps sar semanage showmount sockstat ss stat sysctl \
    systemctl tail tcpdump traceroute tune2fs ulimit uptime vmstat w wdiff who

for executable in $grc_plugin_execs
    if type -q $executable
        function $executable --inherit-variable executable --wraps=$executable
            if isatty 1
                grc $executable $argv
            else
                eval command $executable $argv
            end
        end
    end
end

# function df --wraps df --description 'alias df=grc dh -Thx tmpfs -x devtmpfs'
#     set -l executable df
#         if isatty 1
#             grc $executable -Thx tmpfs -x devtmpfs $argv
#         else
#             eval command $executable -Thx tmpfs -x devtmpfs $argv
#         end
# end

# function make --wraps make --description 'alias make=grc make -j$(nproc)'
#     set -l executable make
#         if isatty 1
#             grc $executable -j$(nproc) $argv
#         else
#             eval command $executable -j$(nproc) $argv
#         end
# end
