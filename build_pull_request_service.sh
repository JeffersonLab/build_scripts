#!/bin/bash
set +e
branch=$1
comment_url=$2
echo build_pull_request_service.sh: building branch $branch
report_file=report_${branch}.txt
export BUILD_SCRIPTS=/home/gluex/build_scripts
echo build_pull_request_service.sh: using BUILD_SCRIPTS = $BUILD_SCRIPTS
command="$BUILD_SCRIPTS/build_pull_request.sh $branch"
echo build_pull_request_service.sh: executing $command
$command
if [ $? -eq 0 ]
then
    status="SUCCESS"
else
    status="FAILURE"
fi
build_dir=/u/scratch/$USER/pull_request_test/sim-recon^$branch
pushd $build_dir
rm -f $report_file
echo build_pull_request_service.sh: create $report_file
$BUILD_SCRIPTS/build_pull_request_report.sh make_${branch}.log > $report_file
# create build status
read -r -d '' comment << EOM
Build status for this pull request: $status\n \
\n \
Build log: $build_dir/make_${branch}.log\n \
Build report: $build_dir/$report_file\n \
Location of build: $build_dir\n \
EOM
# leave comment on github
export PYTHONPATH=/home/gluex/lib/python2.7/site-packages
$BUILD_SCRIPTS/leave_pull_request_comment.py $HOME/.build_scripts/comment_login $comment_url "$comment"
