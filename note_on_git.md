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

* `git commit --amend` is equal to:

```
$ git reset --soft HEAD^
$ git commit -e -F .git/COMMIT_EDITMSG
```

##checkout
`git checkout -- .` or `git checkout -- <file>` : Overwrite file(s) in work directory with file(s) in staged zone.

`git checkout HEAD .` or `git checkout HEAD <file>` : Overwrite file(s) both in your staged zone and work directory with file(s) from the branch that HEAD point to.

* -- is to distinguish file name from ref name or commit name.

