versions=(v0.1.0 v0.1.1 v0.2.0)

for v in "${versions[@]}"
do
  echo
  for entry in $v/*.proto
  do
    i=$(basename -s .proto $entry)
    echo "Processing $v-$i"

    docker run --rm \
      -v $(pwd):/out \
      -v $(pwd)/$v:/protos \
      pseudomuto/protoc-gen-doc \
      --doc_opt=json,proto-doc.json $i.proto

    mkdir -p ../interfaces/srlinux/$i/$v
    mv proto-doc.json ../interfaces/srlinux/$i/$v/
  done
done