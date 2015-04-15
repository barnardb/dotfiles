export JAVA_HOME
JAVA_HOME="$(/usr/libexec/java_home --failfast)"
[ $? -eq 0 ] || echo "ERROR while trying to set JAVA_HOME" >&2
