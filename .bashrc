# git aliases
alias gs='git status'
alias gl='git log --pretty=one'
alias ga='git add -A'
alias gc='git commit -m "$@"'
alias gp='git push'

# docker aliases
alias dcl='docker container ls -a'

function dcr {
  docker container stop $@ && docker container rm $@
}

function dcra {
	local ids=$(docker container ls -a | cut -d ' ' -f 1 | tr '\n' ' ' | cut -d ' ' -f2-)
	docker container stop $ids
	docker container rm $ids
}

function dp {
  docker container prune -f
  docker image prune -af
}

function dpa {
  docker container prune -f
  docker image prune -af
  docker builder prune -af
}