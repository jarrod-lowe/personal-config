function reagent
  if test -S "$SSH_AUTH_SOCK"
    # the current socket is ok, leave it alone
  else
    if test -z "$SSH_AUTH_SOCK"
      # No ssh-agent in use, leave it alone
    else
      # Set a new SSH_AUTH_SOCK
      set -x SSH_AUTH_SOCK (find /tmp -path "*/ssh-*" -name "agent*" -uid (id -u) 2>/dev/null | tail -n1)
    end
  end
end
