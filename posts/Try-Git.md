---
title: Try Git!
date: 2017-07-29 14:17:58
categories:
tags:
  - Git
description:
  Github的互动式git教程
---


<!-- truncate -->

# 初始化git
`git init` To initialize a Git repository here

`/.git/` is a hidden directory where Git operates.


`git status`

**Staging Area:**
A place where we can group files together before we "commit" them to Git.

  - **staged:**
  Files are ready to be committed.
  - **unstaged:**
  Files with changes that have not been prepared to be committed.
  - **untracked:**
  Files aren't tracked by Git yet. This usually indicates a newly created file.
  - **deleted:**
  File has been deleted and is waiting to be removed from Git.

`git add [new file]` To tell Git to start tracking changes made to new file

`git add -A `. where the dot stands for the current directory, so everything in and beneath it is added.

You can use `git reset <filename>` to remove a file or files from the staging area.


`git commit -m "Add cute octocat story"`
A "commit" is a snapshot of our repository.

`git add '*.txt'`
we can add all the new files

`git add *.txt` [没有单引号，shell只会搜索当前路径下的文件]
Without quotes our shell will only execute the wildcard search within the current directory. Git will receive the list of files the shell found instead of the wildcard and it will not be able to add the files inside of the octofamily directory.

Use `git log --summary` to see more information for each commit

`git remote add origin https://github.com/try-git/try_git.git`
To push our local repo to the GitHub server we'll need to add a remote repository.

Git doesn't care what you name your remotes, but it's typical to name your main one origin.

`git push -u origin master`
The push command tells Git where to put our commits when we're ready.
The `-u`tells Git to *remember the parameters*, so that next time we can simply run `git push` .

**Cool Stuff:**
When you start to get the hang of git you can do some really cool things with `hooks` when you push.
- [Git - Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)

`git stash` to stash your changes, and `git stash apply` to re-apply your changes after your pull.
ref:
- [Git - 储藏（Stashing）](https://git-scm.com/book/zh/v1/Git-%E5%B7%A5%E5%85%B7-%E5%82%A8%E8%97%8F%EF%BC%88Stashing%EF%BC%89)

`git diff` with the `--staged` option to see the changes you just staged

`git checkout -- <target>`. Go ahead and get rid of all the changes since the last commit for octocat.txt

  It's simply promising the command line that there are no more options after the `--`. This way if you happen to have a branch named `octocat.txt`, it will still revert the file, instead of switching to the branch of the same name.

You can switch branches using the `git checkout <branch>` command.

# git 删除

`git rm -r folder_of_cats`
This will recursively remove all *folders* and files from the given directory.

If you happen to delete a file without using `git rm` you'll find that you still have to `git rm` the deleted files from the working tree.
You can save this step by using the `-a` option on `git commit`, which auto removes deleted files with the commit.
`git commit -am "Delete stuff"`


`git merge clean_up`
tell Git to merge the clean_up branch into it.
when you have to merge your changes from the `clean_up` branch into the `master` branch

Merge Conflicts can occur when changes are made to a file at the same time.  if you're interested in reading more, take a look the section of the Pro
[Git - Book](https://git-scm.com/book/en/v2)
 on
[Git - git-merge Documentation](https://git-scm.com/docs/git-merge#_how_conflicts_are_presented)

use `git branch -d <branch name>` to delete a branch

Somtimes, You'll notice that `git branch -d bad_feature` doesn't work.
This is because `-d` won't let you delete something that *hasn't been merged.*
You can either add the `--force (-f)` option or use `-D` which combines -d -f together into one command.
