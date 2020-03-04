#!/bin/sh
set -e

script=$(basename $0)
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

usage="usage: $script [-h|-r|-s]
    -h| --help          this help
    -e| --env           env
    -t| --tag           image tag
    -p| --project-id    project id
    -s| --service-repo  service repo"

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -h|--help)
        echo "$usage"
        exit 1
        ;;
       -e|--env)
        ENV="$2"
        shift
        ;;
        -p|--project-id)
        PROJECT_ID="$2"
        shift
        ;;
        -f|--from-repo)
        FROM_REPO="$2"
        shift
        ;;
        -t|--to-repo)
        TO_REPO="$2"
        shift
        ;;
        *)
        # Unknown option
        ;;
    esac
    shift # past argument or value
done

if [ -z $ENV ] || [ -z $PROJECT_ID ] || [ -z $FROM_REPO ] || [ -z $TO_REPO ]; then
  echo "$usage"
  exit 1
fi


copyImageTagBetweenRepos() {
  TAG=$1
  echo $TAG
  #Uncomment to actually copy image between repos
#  gcloud container images add-tag \
#  gcr.io/$PROJECT_ID/$FROM_REPO:$TAG \
#  gcr.io/$PROJECT_ID/$TO_REPO:$TAG
}

setEnvironmentVariables() {
}

main() {
  tags=$(gcloud container images list-tags gcr.io/$PROJECT_ID/$FROM_REPO --format="value(tags[0])" | grep "\S")

  while IFS= read -r tag; do
      copyImageTagBetweenRepos $tag
  done <<< "$tags"
}

#Uncomment to run
#main




