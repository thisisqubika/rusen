#!/bin/bash

# tarFileName='ruy-page.tar'

rm -rf build
# rm $tarFileName

mkdir build

grunt precompile
jade views/home/index.jade --out ./build/ --pretty

cp -r public/* build/


rm -rf ../data ../dist ../fonts ../images ../index.html

cp -r build/* ../

cd ../

git add . --all
git commit -m 'Deploy new build.'
git push origin gh-pages

# tar czf $tarFileName ./build