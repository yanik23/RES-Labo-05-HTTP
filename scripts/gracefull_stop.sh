#!/bin/bash
function usage (){
    echo "usage : $programname  [container] "
    echo "  container                : container to be stopped"
    exit 1
}

if [ $# == 0 ] ; then
    usage
fi

docker stop $1