printf 'Do you really want to purge all production data and fully reset the instance (y/n)? '
read key_result
if [ "$key_result" != "${key_result#[Yy]}" ] ;then 
    sudo rm -rf storage/mongodb/*
    sudo rm -rf storage/mcritweb/*
    sudo rm -rf logs/mcrit/*
    sudo rm -rf logs/mcritweb/*
    sudo rm -rf logs/mongodb/*
    sudo rm -rf logs/nginx/*
else
    echo "Aborting..."
fi