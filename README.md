# mongodb-backerup


This image runs mongodump to backup data using cronjob to folder `/mongo-backup`

For a prebuilt version of this Docker image, you can use mine: `firasdotcom/mongodb-backerup`

## Usage:

    docker run -d --name mongodb-backerup \
        --env MONGODB_HOST=mongodb.host \
        --env MONGODB_PORT=27017 \
        --env MONGODB_USER=admin \
        --env MONGODB_PASS=password \
        --volume host.folder:/mongo-backup
        mongodb-backerup

If you link `mongodb-backerup` to a mongodb container(e.g. `mongodb`) with an alias named mongodb, this image will try to auto load the `host`, `port`, `user`, `pass` if possible.

For example
    docker run -d -p 27017:27017 -p 28017:28017 -e MONGODB_PASS="mypass" --name mongodb mongodb
    docker run -d --link mongodb:mongodb -v host.folder:/mongo-backup mongodb-backerup

## Parameters

    MONGODB_HOST    the host/ip of your mongodb database
    MONGODB_PORT    the port number of your mongodb database
    MONGODB_USER    the username of your mongodb database. If MONGODB_USER is empty while MONGODB_PASS is not, the image will use admin as the default username
    MONGODB_PASS    the password of your mongodb database
    MONGODB_DB      the database name to dump. If not specified, it will dump all the databases
    EXTRA_OPTS      the extra options to pass to mongodump command
    CRON_TIME       the interval of cron job to run mongodump. `0 0 * * *` by default, which is every day at 00:00
    MAX_BACKUPS     the number of backups to keep. When reaching the limit, the old backup will be discarded. No limit, by default
    INIT_BACKUP     if set, create a backup when the container launched

## Restore from a backup

See the list of backups, you can run:

    docker exec mongodb-backerup ls /mongo-backup

To restore database from a certain backup, simply run:

    docker exec mongodb-backerup /restore.sh /mongo-backup/backup_name
