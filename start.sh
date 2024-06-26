#!/bin/bash

readonly root_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

function update() {
    local bot_subpath="${1}"
    cd "${bot_subpath}"
    echo "Updating [${bot_subpath}]..."

    git fetch
    git pull

    . venv/bin/activate
    pip3 install -qr requirements.txt

    echo "Updated!"
    cd "${root_path}"
}

function prefixed_output() {
    script -feqc "${1}" /dev/null | sed "s/^/[${2}] /"
}

function start() {
    local bot_subpath="${1}"
    cd "${bot_subpath}"

    local custom_env_dir="${root_path}/config/${bot_subpath}"
    prefixed_output "echo \"Looking for the .env file in [${custom_env_dir=}]...\"" "${bot_subpath}"
    local custom_env_filepath="${custom_env_dir}/.env"
    if [ ! -f "${custom_env_filepath}" ]; then
        prefixed_output 'echo "Custom .env file is not found!"' "${bot_subpath}"
        if [ ! -f ".env" ]; then
            prefixed_output 'echo "Copying from the .env-example..."' "${bot_subpath}"
            cp -f .env-example .env
        else
            prefixed_output 'echo "Anyway, the .env-file is already configured, there is nothing to do."' "${bot_subpath}"
        fi
    else
        prefixed_output 'echo "Copying custom .env file..."' "${bot_subpath}"
        cp -f "${custom_env_filepath}" .env
    fi

    . venv/bin/activate
    prefixed_output 'python3 main.py -a 2' "${bot_subpath}"
}

update HamsterKombatBot
update MemeFiBot
update PocketFiBot
update TapSwapBot
update WormSlapBot

start HamsterKombatBot &
start MemeFiBot &
start PocketFiBot &
start TapSwapBot &
start WormSlapBot &

wait
