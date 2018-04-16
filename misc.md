misc
====

password reset
--------------

If for some reason you forget your password, you may exec to the
container and reset it usin the MongoDB client:

    root@host:~# docker exec -ti unifi
    root@unifi:~# mongo --port 27117 ace

...

    > db.admin.find().forEach(printjson);

in the json output, look for the name of the administrator, for
example `"name" : "admin",`, then using that set a new password:

    > db.admin.update( { name: "admin" }, {$set: { x_password: "badpass" } } )
    WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
