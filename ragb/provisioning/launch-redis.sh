pushd "$(dirname "$0")" || exit 3
mkdir -p ../redis-tmp
install ./redis-test.conf ../redis-tmp
pushd ../redis-tmp || (echo "No redis-tmp folder"; exit 2)
redis-server ./redis-test.conf
popd || (echo "Unexpected error"; exit 4)
rm -r ../redis-tmp
popd || (echo "Unexpected error"; exit 5)
