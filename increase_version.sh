# Find and increment the version number.
perl -i -pe 's/^(version:\s+\d+\.\d+\.)(\d+)(\+)(\d+)$/$1.($2+1).$3.($4+1)/e' pubspec.yaml
# Commit and tag this change.
version=`grep 'version: ' pubspec.yaml | sed 's/version: //'`
message = git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:"%s"  
git log --pretty=format:%s `git tag --sort=-committerdate | head -1`...`git tag --sort=-committerdate | head -2 | awk '{split($0, tags, "\n")} END {print tags[1]}'` > change_log.txt
git add .
git commit -m "Bump version to $version" -m "$message"
git tag $version
git push