#!/bin/bash
repo=$1
branch_git=$2
comment_url=$3
branch=$(echo $branch_git | sed -r 's/\//_/g')
if [[ ! -z "$4" ]]; then
    export REPO_URL=$4
fi
#
# set up the environment
export BUILD_SCRIPTS=/group/halld/Software/build_scripts
bms_osname=$($BUILD_SCRIPTS/osrelease.pl)
test_dir=/work/halld/pull_request_test
cd $test_dir
version_file="version_${repo}_${branch}.xml"
rm -f $version_file
perl $BUILD_SCRIPTS/pull_request/pull_request_test_version.pl $repo $branch $bms_osname
source $BUILD_SCRIPTS/gluex_env_boot_jlab.sh
gxenv $version_file
#
echo build_pull_request_service.sh: building branch $branch
report_file=report_${branch}.txt
echo build_pull_request_service.sh: using BUILD_SCRIPTS = $BUILD_SCRIPTS
command="$BUILD_SCRIPTS/pull_request/build_pull_request.sh $repo $branch_git"
echo build_pull_request_service.sh: executing $command
$command
if [[ $? -eq 0 ]]; then
    status="SUCCESS"
else
    status="FAILURE"
fi
build_dir=$test_dir/$repo^$branch
web_dir=/work/halld2/pull_request_test/$repo^$branch
rm -rf $web_dir && mkdir -p $web_dir
cd $build_dir
rm -f $report_file
echo build_pull_request_service.sh: create $report_file
$BUILD_SCRIPTS/pull_request/build_pull_request_report.sh make_${branch}.log > $report_file
if [[ $status == "SUCCESS" ]]; then
    # Test for runtime errors and form overall status
    command="$BUILD_SCRIPTS/pull_request/test_pull_request.sh $repo $branch"
    echo build_pull_request_service.sh: executing $command
    $command
    echo "Failure list" > $build_dir/tests/failures.txt
    # Record individual plugin test failures but don't include them in overall status
    grep 'plugin failed' $build_dir/tests/summary.txt >> $build_dir/tests/failures.txt
    # Check for failure of the multiple plugins test and use result in overall status
    grep 'plugins test failed' $build_dir/tests/summary.txt >> $build_dir/tests/failures.txt
    # note that grep returns non-zero on failure (usually "1")
    # we are checking to see if we find any failures, so 0 is actually bad - we want this grep command to fail
    code=$?
    echo ==return code $code==
    # Check if the hdgeant test failed and use in overall status
    grep 'hdgeant failed' $build_dir/tests/summary.txt >> $build_dir/tests/failures.txt
    # same comments as above
    code2=$?
    echo ==return code2 $code2==
    # if the first set of checks were passed, decide success/failure based on second set of checks
    if [[ $code -ne 0 ]]; then
        code=$code2
    fi
    # remember we are grepping to see if it failed, so if the test passed, grep will return 1
    if [[ $code -ne 0 ]]; then
        test_status="SUCCESS"
        failure_comment=""
    else
        test_status="FAILURE"
        failure_comment="Failures: [$build_dir/tests/failures.txt](https://halldweb.jlab.org/pull_request_test/$repo^$branch/tests-failures.txt)\n"
    fi
    # save files to web accessible directory
    cp -v $build_dir/make_${branch}.log $web_dir/make_${branch}.log
    cp -v $build_dir/$report_file $web_dir/$report_file
    cp -v $build_dir/tests/summary.txt $web_dir/tests-summary.txt
    cp -v $build_dir/tests/failures.txt $web_dir/tests-failures.txt
    cp -av $build_dir/tests/log $web_dir/tests-logs
    # create test status comment
    read -r -d '' comment << EOM
Test status for this pull request: ${test_status}\n \
\n $failure_comment \
Summary: [$build_dir/tests/summary.txt](https://halldweb.jlab.org/pull_request_test/$repo^$branch/tests-summary.txt)\n \
Logs: [$build_dir/tests/log](https://halldweb.jlab.org/pull_request_test/$repo^$branch/tests-logs)\n \
\n \
Build log: [$build_dir/make_${branch}.log](https://halldweb.jlab.org/pull_request_test/$repo^$branch/make_${branch}.log)\n \
Build report: [$build_dir/$report_file](https://halldweb.jlab.org/pull_request_test/$repo^$branch/$report_file)\n \
Location of build: $build_dir\n
EOM
else
    # save files to web accessible directory
    cp -v $build_dir/make_${branch}.log $web_dir/make_${branch}.log
    cp -v $build_dir/$report_file $web_dir/$report_file
    # create build status comment
    read -r -d '' comment << EOM
Build status for this pull request: ${status}\n \
\n \
Build log: [$build_dir/make_${branch}.log](https://halldweb.jlab.org/pull_request_test/$repo^$branch/make_${branch}.log)\n \
Build report: [$build_dir/$report_file](https://halldweb.jlab.org/pull_request_test/$repo^$branch/$report_file)\n \
Location of build: $build_dir\n
EOM
fi
# leave comment on github
export PYTHONPATH=/home/gluex/lib/python2.7/site-packages
$BUILD_SCRIPTS/pull_request/leave_pull_request_comment.py $HOME/.build_scripts/comment_login $comment_url "$comment"
