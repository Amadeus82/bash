# git aliases
alias gs='git status'
alias gl='git log --pretty=one'
alias ga='git add -A'
alias gc='git commit -m "$@"'
alias gp='git push'

# conda aliases
alias ccf='conda env create -f environment.yml'
alias ccn='conda create -n $1'
alias cel='conda env list'
alias ca='conda activate $1'
alias cs='conda search $1'
alias csf='conda search -c conda-forge $1'
alias ci='conda install $1'
alias cif='conda install -c conda-forge $1'
alias cl='conda list | grep $1'

function __conda_ident {
    # declare local params as references
    local -n __env_name=$1
    local -n __env_path=$2

    echo -n "> detect environment ... "

    # exit prematurely if no environment.yaml file was
    # located in the current directory
    if [[ ! -f "environment.yaml" ]]
    then
        echo "failed: no environment.yaml available"
        return 1
    fi

    # try to identify the project conda environment
    __env_name=$(cat environment.yaml | sed -nE "s/^name: ([a-zA-Z]+)/\1/p")
    __env_path=$(conda env list | sed -nE "s/^$__env_name +([a-zA-Z]+)/\1/p")

    # exit prematurely if the name of the
    # environment could not be identified
    if [[ -z $__env_name ]]
    then
        echo "failed: environment.yaml seems to be corrupted"
        return 1
    fi

    # print the project conda environment status
    echo -n "identified :: $__env_name :: "
    [[ -n $__env_path ]] && echo "located at $__env_path" || echo "not existing"
}


function ccy {
    # declare local params
    local env_name
    local env_path

    # try to identify the conda project environment
    # and exit prematurely in case of a failure
    __conda_ident env_name env_path
    [[ $? -gt 0 ]] && return $?

    # if the environment already exists, we do nothing
    if [[ -z $env_path ]]
    then
        echo "> create environment $env_name"
        conda env create -f environment.yaml
    else
        echo "> abort as environment already exists"
    fi
}


function cry {
    # declare local params
    local env_name
    local env_path

    # try to identify the conda project environment
    # and exit prematurely in case of a failure
    __conda_ident env_name env_path
    [[ $? -gt 0 ]] && return $?

    # if the environment doesn't even exist we do nothing
    if [[ -n $env_path ]]
    then
        echo "> delete environment: $env_name"
        conda env remove -n $env_name

        echo "> delete folder: $env_path"
        rm -r $env_path
    else
        echo "> abort as no such environment exists"
    fi
}



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