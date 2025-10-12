# vim:syntax=fish
# vim:filetype=fish

# public ssh key
if not test -f $HOME/.ssh/id_ed25519.pub; and test -f $HOME/.ssh/id_ed25519
    echo "creating ssh public key.."
    ssh-keygen -f $HOME/.ssh/id_ed25519 -y >$HOME/.ssh/id_ed25519.pub
end
