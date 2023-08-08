#!/bin/sh

# Creates a criss-cross merge.

set -e 

git clone git@github.com:mernst/repo-with-criss-cross-merge.git
cd repo-with-criss-cross-merge

## Make `./gradlew test` succeed in the repository.
usejdk11 && \
gradle init && \
usejdk8 && \
echo "apply plugin: 'java'" > build.gradle && \
rm -f settings.gradle && \
./gradlew wrapper --gradle-version 8.1.1 && \
./gradlew --version && \
./gradlew test && \
git add build.gradle gradle/ gradlew gradlew.bat

cp -p ../create.sh .
echo "This repository contains a criss-cross merge." > README.md
echo "test:" >> Makefile
echo "	true" >> Makefile
git add create.sh README.md Makefile
git commit -m "Script to create criss-cross merge"

cp -pr ../repo-with-criss-cross-merge ../repo-with-criss-cross-merge-branch-branch1
cd ../repo-with-criss-cross-merge-branch-branch1 || exit 1
git checkout -b branch1
echo "edit on branch 1" > file1.txt
git add file1.txt
git commit -m "edit on branch 1"
commit1=$(git rev-parse HEAD)
echo "commit1=$commit1"
cd ../repo-with-criss-cross-merge || exit 1

cp -pr ../repo-with-criss-cross-merge ../repo-with-criss-cross-merge-branch-branch2
cd ../repo-with-criss-cross-merge-branch-branch2 || exit 1
git checkout -b branch2
echo "edit on branch 2" > file2.txt
git add file2.txt
git commit -m "edit on branch 2"
commit2=$(git rev-parse HEAD)
echo "commit2=$commit2"
cd ../repo-with-criss-cross-merge || exit 1

cp -pr ../repo-with-criss-cross-merge-branch-branch1 ../repo-with-criss-cross-merge-branch-merge1
cd ../repo-with-criss-cross-merge-branch-merge1
git pull ../repo-with-criss-cross-merge-branch-branch2

cp -pr ../repo-with-criss-cross-merge-branch-branch2 ../repo-with-criss-cross-merge-branch-merge2
cd ../repo-with-criss-cross-merge-branch-merge2
git pull ../repo-with-criss-cross-merge-branch-branch1

cd ../repo-with-criss-cross-merge || exit 1
git pull ../repo-with-criss-cross-merge-branch-merge1
git pull ../repo-with-criss-cross-merge-branch-merge2
