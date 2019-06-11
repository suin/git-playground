#!/usr/bin/env bash

set -eu

function echo:green {
    echo -e "\033[32m$@\033[0m"
}

function STEP {
	echo -e "$(tput bold)$(tput setaf 4)# $@$(tput sgr0)"
}

function RUN {
	echo -e "$(tput bold)\$ $@$(tput sgr0)"
	"$@"
	echo
}

readonly TEST_DIR='git-test'

[ -d "${TEST_DIR}" ] && rm -rf ${TEST_DIR}
mkdir ${TEST_DIR} && cd ${TEST_DIR}

STEP "Gitを初期化します" && {
	RUN git init
	RUN git commit --allow-empty -m 'init'
}

STEP "1つ目のコミットを追加します" && {
	echo '改修1' >> file && git add .
	RUN git commit -m '1つ目のコミット'
}

STEP "2つ目のコミットを追加します" && {
	echo '改修2' >> file && git add .
	RUN git commit -m '2つ目のコミット'
}

STEP "3つ目のコミットを追加します" && {
	echo '改修3' >> file && git add .
	RUN git commit -m '3つ目のコミット'
}

STEP "現状のコミットツリーを確認します" && {
	RUN git log --oneline --graph --all
}

STEP "2つ目のコミットと3つ目のコミットを一旦取り消します" && {
	RUN git reset --soft @~2
}

STEP "直近2つのコミットはステージだけされた状態になります" && {
	RUN git status -s
	RUN git diff --staged
}

STEP "コミットログは1つ目のコミットだけ残った状態です" && {
	RUN git log --oneline --graph --all
}

STEP "この状態で--ammendをつけて、もう一度コミットします" && {
	RUN git commit --amend --no-edit
}

STEP "コミットログは1つ目のコミットだけ残った状態になり、これでコミットログの完成です" && {
	RUN git log --oneline --graph --all
}
