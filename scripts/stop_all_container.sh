#!/bin/bash
nbstatic=$1
nbdynamic=$2

function usage (){
    echo "usage : $programname  [nbstatic]  [nbdynamic]"
    echo "  numbers must be the same as specified in build_run.sh"
    echo "  nbstatic                : number of static servers to stop"
    echo "  dynamic                 : number of dynamic servers to stop"
    exit 1
}

if [ $# == 0 ] || [ $# == 1 ] ; then
    usage
fi

for ((i=0;i<$nbstatic;i++))
do
    docker kill static$i 
    docker rm static$i
done

for ((i=0;i<$nbdynamic;i++))
do
    docker kill dynamic$i
    docker rm dynamic$i

done

docker kill apache_rp
docker rm apache_rp
