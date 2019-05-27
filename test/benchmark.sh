#!/bin/bash

echo "1. Creating npm link to the current working tree"
npm link

cd "$(dirname "$0")"

echo "2. Initializing package.json and tsconfig.json"
yarn init -y
cp ../tsconfig.json ./tsconfig.json

echo "3. Linking ts-prune from step 1"
npm link ts-prune

echo "4. Generating files in the src..."
rm -rf src
mkdir src
cp 0.template src/0.ts

for n in {1..499}
do
  let REFER_TO=n-1
  cat testFileContent.template | sed "s/__n__/$REFER_TO/g" > "src/$n.ts"
done

echo "5. Run ts-prune"
TIME_START=`date +%s`
ts-prune
TIME_END=`date +%s`
COMPLETED_ON=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
HOSTNAME=`hostname`

echo "$HOSTNAME $COMPLETED_ON $((TIME_END-TIME_START))" >> ./benchmark_history.txt

tail -1 ./benchmark_history.txt