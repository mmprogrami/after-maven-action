JOB_ENV=${JOB_ENV:=job.env}
source ${JOB_ENV}

if [ $MAVEN_TESTS_ERROR -gt 0 ] ; then
  echo  "Some ($MAVEN_TESTS_ERROR) tests had errors. Exit 1." 1>&2
  exit 1
elif [ $MAVEN_TESTS_FAILED -gt 0 ]; then
  echo  "Some ($MAVEN_TESTS_ERROR) tests had failures. Exit 2" 1>&2
  exit 2
elif [ $MAVEN_TESTS_RUN -eq 0 ]; then
  echo  "Everything seems ok, but now tests run. Exit 0" 1>&2
  exit 0
else
  echo  "All tests passed. Exit 0"
  exit 0
fi
