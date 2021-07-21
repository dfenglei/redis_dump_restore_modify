#!/bin/bash


src_ip=1.2.3.62

src_port=7963


dest_ip=1.4.3.6

dest_port=7963


key_prefix=1:b4cfea8406e4456d:


i=1

redis-cli -h $src_ip -p $src_port -a Redis~123 -n 1  keys "${key_prefix}*" | while read key
do
    redis-cli -h $dest_ip -p $dest_port -a Redis~123 -n 1 del ${key/b4cfea8406e4456d/93775b9324a34c08}
    echo "$i migrate key $key"
    redis-cli -h $src_ip -p $src_port -a Redis~123 -n 1 --raw dump $key | perl -pe 'chomp if eof'|redis-cli -h $dest_ip -p $dest_port -a Redis~123 -n 1 -x restore ${key/b4cfea8406e4456d/93775b9324a34c08} 0
    
    echo "$modify key $key"
    redis-cli -h $dest_ip -p $dest_port -a Redis~123 -n 1 hgetall ${key/b4cfea8406e4456d/93775b9324a34c08} |sed 's/b4cfea8406e4456d/93775b9324a34c08/' | tr '\n' ' ' |xargs  redis-cli -h $dest_ip -p $dest_port -a Redis~123 -n 1 hmset ${key/b4cfea8406e4456d/93775b9324a34c08}
    ((i++))
done
