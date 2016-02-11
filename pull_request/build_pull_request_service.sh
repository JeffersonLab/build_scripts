#!/bin/bash
branch=$1
comment_url=$2
echo build_pull_request_service.sh: building branch $branch
report_file=report_${branch}.txt
export BUILD_SCRIPTS=/home/gluex/build_scripts
echo build_pull_request_service.sh: using BUILD_SCRIPTS = $BUILD_SCRIPTS
command="$BUILD_SCRIPTS/pull_request/build_pull_request.sh $branch"
echo build_pull_request_service.sh: executing $command
$command
if [ $? -eq 0 ]
then
    status="SUCCESS"
else
    status="FAILURE"
fi
build_dir=/work/halld/pull_request_test/sim-recon^$branch
pushd $build_dir
cd $build_dir
rm -f $report_file
echo build_pull_request_service.sh: create $report_file
$BUILD_SCRIPTS/pull_request/build_pull_request_report.sh make_${branch}.log > $report_file
if [ $status == "SUCCESS" ]; then
    # test for runtime errors and get overall status
    command="bash $BUILD_SCRIPTS/pull_request/test_pull_request.sh $branch"
    echo build_pull_request_service.sh: executing $command
    $command >& $build_dir/tests/summary.txt
    echo "Failure list" > $build_dir/tests/failures.txt
    grep -i 'failed' $build_dir/tests/summary.txt >> $build_dir/tests/failures.txt
    if [ $? -ne 0 ]
    then
        test_status="SUCCESS"
    else
        test_status="FAILURE"
    fi
    # create test status comment
    read -r -d '' comment << EOM
    Test status for this pull request: ${test_status}\n \
    \n \
    Failures: [$build_dir/tests/failures.txt](https://halldweb.jlab.org/pull_request_test/sim-recon^$branch/tests/failures.txt)\n \
    Summary: [$build_dir/tests/summary.txt](https://halldweb.jlab.org/pull_request_test/sim-recon^$branch/tests/summary.txt)\n \
    Logs: [$build_dir/tests/log](https://halldweb.jlab.org/pull_request_test/sim-recon^$branch/tests/log)\n
    \n \
    Build log: [$build_dir/make_${branch}.log](https://halldweb.jlab.org/pull_request_test/sim-recon^$branch/make_${branch}.log)\n \
    Build report: [$build_dir/$report_file](https://halldweb.jlab.org/pull_request_test/sim-recon^$branch/$report_file)\n \
    Location of build: $build_dir\n
    EOM
else
    # create build status comment
    read -r -d '' comment << EOM
    Build status for this pull request: ${status}\n \
    \n \
    Build log: [$build_dir/make_${branch}.log](https://halldweb.jlab.org/pull_request_test/sim-recon^$branch/make_${branch}.log)\n \
    Build report: [$build_dir/$report_file](https://halldweb.jlab.org/pull_request_test/sim-recon^$branch/$report_file)\n \
    Location of build: $build_dir\n
    EOM
fi
# leave comment on github
export PYTHONPATH=/home/gluex/lib/python2.7/site-packages
$BUILD_SCRIPTS/pull_request/leave_pull_request_comment.py $HOME/.build_scripts/comment_login $comment_url "$comment"
