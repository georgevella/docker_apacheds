@echo off

docker run --rm -it -p 10389:10389 -e INSTANCE_ID=test -e PARTITION_ID=test -e BASE_DN=dc=test,dc=local -e KERBEROS_PRIMARY_REALM=TEST.LOCAL georgevella/apacheds
rem docker run --rm -it -p 10389:10389 -e INSTANCE_ID=test -e PARTITION_ID=test -e BASE_DN=dc=test,dc=local -e KERBEROS_PRIMARY_REALM=TEST.LOCAL georgevella/apacheds
REM docker run --rm -it -p 10389:10389 georgevella/apacheds