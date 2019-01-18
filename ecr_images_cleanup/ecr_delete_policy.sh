#!/bin/bash

#VARS
DAYS_AGO=14
REPOS=yourepo # If you have more than one repo prefix you can use repo1|repo2|repo3
TAG=tags_to_delete #accept regex and multiple tags(separate with | )
# You can also select all the tags that does NOT follow this pattern, for example:
# [0-9]*\.[0-9]*\.[0-9]*\" this tag represents only major releases 1.0.0, 1.0.2, 3.10.5 and so on
# if you want to use this script toto clean ALL tags without the major releases add a -v in the egrep "$TAG" section
# egrep -v "$TAG"

#Dependencies
# - jq
# - perl
# - aws cli

#Verify dependencies

# jq
type jq >/dev/null 2>&1 || { echo >&2 "É necessário o utilitário jq para que este script rode."; exit 1; }

# aws
type aws >/dev/null 2>&1 || { echo >&2 "É necessário o utilitário aws para que este script rode."; exit 1; }

# perl
type perl >/dev/null 2>&1 || { echo >&2 "É necessário o utilitário perl para que este script rode."; exit 1; }

#Refine your $REPOS
AWS_REPOS=`aws ecr describe-repositories |grep repositoryName |egrep "$REPOS" |awk '{print $2 }' |sed -e 's/\,//g' |sed -e 's/\"//g'`

#Define images older than $DAYS_AGO
for aws_repo_list in $AWS_REPOS; do
aws ecr describe-images --repository-name $aws_repo_list --output json | jq '.[]' |jq '.[]' | jq "select (.imagePushedAt < `date +%s  --date="$DAYS_AGO days ago"`)" >> /tmp/ecr_files.json
done

#Filter all images and send to list
#SHA
perl -0777 -pe 's/\n\s*\"//g' /tmp/ecr_files.json | egrep  "imageTags|imageDigest" |egrep "$TAG" |awk '{print $3}' |grep "sha256:" | awk -F'"' '$0=$2' > /tmp/ecr_sha
#REPOS
perl -0777 -pe 's/\n\s*\"//g' /tmp/ecr_files.json |perl -0777 -pe 's/\n\s*\]//g' | egrep  "imageTags|imageDigest" |egrep -v "[0-9]*\.[0-9]*\.[0-9]*\"" |awk '{print $6}' |egrep $REPOS |awk -F'"' '$0=$2' > /tmp/ecr_repos

#Make script to run
paste <(cat /tmp/ecr_repos) <(cat /tmp/ecr_sha) | while read e u; do echo aws ecr batch-delete-image --repository-name $e --image-ids imageDigest=$u >> /tmp/remove_old_images.sh ; done

#Remove images
bash /tmp/remove_old_images.sh > /tmp/remove_old_images.log

#mv list files
mkdir /tmp/ecr_files && mv /tmp/123_* /tmp/ecr_files
