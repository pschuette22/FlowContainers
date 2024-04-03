swift package --allow-writing-to-directory ./docs \                  
    generate-documentation --target FlowContainers \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path https://pschuette22.github.io/FlowContainers \ 
    --output-path ./docs/ 
