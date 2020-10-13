# SSH autocompletion
# ssh, scp, ping, host
# https://github.com/tehmaze/maze.io/blob/master/maze/_post/2008/08-03-remote-tabcompletion-using-openssh-and-zsh.md
zstyle ':completion:*:scp:*' tag-order 'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:scp:*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order users 'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp):*:hosts-host' ignored-patterns '*.*' loopback localhost
zstyle ':completion:*:(ssh|scp):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^*.*' '*@*'
zstyle ':completion:*:(ssh|scp):*:hosts-ipaddr' ignored-patterns '^<->.<->.<->.<->' '127.0.0.<->'
zstyle ':completion:*:(ssh|scp):*:users' ignored-patterns adm bin daemon halt lp named shutdown sync
zstyle -e ':completion:*:(ssh|scp):*' hosts 'reply=(
      ${=${${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) \
                      /dev/null)"}%%[# ]*}##\|*}//,/ }
      ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
      ${=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
      )'
