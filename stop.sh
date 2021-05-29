
#!/bin/bash

for i in 1 2 3 4 
do
    docker kill static$i 
    docker rm static$i

    docker kill dynamic$i
    docker rm dynamic$i

done

docker stop apache_rp
docker rm apache_rp
