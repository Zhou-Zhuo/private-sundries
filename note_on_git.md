##reset

`git reset HEAD -- <paths>` :  Just discard changes made by `git add <paths>`. Make no change to staged zone or ref.

3 changes might be made by git reset:

```
1. Point ref to new commit. (e.g. point master to HEAD~1)
2. Overwrite files in stage zone.
3. Overwrite files in work directory.
```

`git reset --hard <commit>` : Execute 1, 2, 3.

`git reset --soft <commit>` : Execute 1.

`git reset [--mixed] <commit>` : Execute 1, 2.

You can use `git reflog` to get back your lost commit.

* `git commit --amend` is equal to:

```
$ git reset --soft HEAD^
$ git commit -e -F .git/COMMIT_EDITMSG
```

##checkout

`git checkout` moves HEAD, not touch ref.

Sometimes your will see you are in a "detached HEAD" state, this actually means HEAD is not pointing to a ref, but a specific commit ID.

`git checkout [--] <paths>` : Overwrite files in work directory with files in staged zone. Will not change HEAD.

`git checkout <commit> [--] <paths>` : Overwrite files in work directory and staged zone with files in specific `<commit>`. Will not change HEAD.

* `--` is to distinguish file name from ref name or commit name.

##merge

Don't want to add history commits in your topic branch to your master branch when merge? Try this:

```
$ git merge --squash topic
$ git commit -m "merged from topic"
```

Hmm... maybe `git cherry-pick` works better for this.
