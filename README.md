# Docker Image for Graphite & Statsd

## Get Graphite & Statsd running instantly

Graphite & Statsd can be complex to setup.
This image will have you running & collecting stats in just a few minutes.

## Differences from original image hopsoft/docker-graphite-statsd

* no ngnix/django/carbon log
* no carbon stats
* change storage schema Default : 60s:30d, + 10sec, 1min, 10 min, 1 day
* storage aggregation optimised to match statsd gauge
* graphite timezone to Paris
 
## Quick Start

```sh
sudo docker run -d \
  --name graphite \
  -p 80:80 \
  -p 2003:2003 \
  -p 8125:8125/udp \
  clodio/docker-graphite-statsd
```

This starts a Docker container named: **graphite**

That's it, you're done ... almost.

### Includes the following components

* [Nginx](http://nginx.org/) - reverse proxies the graphite dashboard
* [Graphite](http://graphite.readthedocs.org/en/latest/) - front-end dashboard
* [Carbon](http://graphite.readthedocs.org/en/latest/carbon-daemons.html) - back-end
* [Statsd](https://github.com/etsy/statsd/wiki) - UDP based back-end proxy

### Mapped Ports

| Host | Container | Service |
| ---- | --------- | ------- |
|   80 |        80 | nginx   |
| 2003 |      2003 | carbon  |
| 8125 |      8125 | statsd  |

### Mounted Volumes

| Host              | Container                  | Notes                           |
| ----------------- | -------------------------- | ------------------------------- |
| DOCKER ASSIGNED   | /opt/graphite              | graphite config & stats storage |
| DOCKER ASSIGNED   | /etc/nginx                 | nginx config                    |
| DOCKER ASSIGNED   | /opt/statsd                | statsd config                   |
| DOCKER ASSIGNED   | /etc/logrotate.d           | logrotate config                |
| DOCKER ASSIGNED   | /var/log                   | log files                       |

### Base Image

Built using [Phusion's base image](https://github.com/phusion/baseimage-docker).

* All Graphite related processes are run as daemons & monitored with [runit](http://smarden.org/runit/).
* Includes additional services such as logrotate.

## Start Using Graphite & Statsd

### Send Some Stats

Let's fake some stats with a random counter to prove things are working.

```sh
while true
do
  echo -n "example.statsd.counter.changed:$(((RANDOM % 10) + 1))|c" | nc -w 1 -u localhost 8125
done
<CTL-C>
```

### Visualize the Data

Open Graphite in a browser at [http://localhost/dashboard](http://localhost/dashboard).

## Secure the Django Admin

Update the default Django admin user account. _The default is insecure._

  * username: root
  * password: root
  * email: root.graphite@mailinator.com

First login at: [http://localhost/account/login](http://localhost/account/login)
Then update the root user's profile at: [http://localhost/admin/auth/user/1/](http://localhost/admin/auth/user/1/)

## Change the Configuration

Read up on Graphite's [post-install tasks](https://graphite.readthedocs.org/en/latest/install.html#post-install-tasks).
Focus on the [storage-schemas.conf](https://graphite.readthedocs.org/en/latest/config-carbon.html#storage-schemas-conf)

1. Stop the container `docker stop graphite`.
1. Find the configuration files on the host by inspecting the container `docker inspect graphite`.
1. Update the desired config files.
1. Restart the container `docker start graphite`.

**Note**: If you change settings in `/opt/graphite/conf/storage-schemas.conf`
be sure to delete the old whisper files under `/opt/graphite/storage/whisper/`.

---

**Important:** Ensure your Statsd flush interval is at least as long as the highest-resolution retention.
For example, if `/opt/statsd/config.js` looks like this.

```
flushInterval: 10000
```

Ensure that `storage-schemas.conf` retentions are no finer grained than 10 seconds.

```
[all]
pattern = .*
retentions = 5s:12h # WRONG
retentions = 10s:12h # OK
retentions = 60s:12h # OK
```

## A Note on Disk Space

If running this image on cloud infrastructure such as AWS,
you should consider mounting `/opt/graphite` & `/var/log` on a larger volume.

1. Configure the host to mount a large EBS volume.
1. Specify the volume mounts when starting the container.

    ```
    sudo docker run -d \
      --name graphite \
      -v /path/to/ebs/graphite:/opt/graphite \
      -v /path/to/ebs/log:/var/log \
      -p 80:80 \
      -p 2003:2003 \
      -p 8125:8125/udp \
      clodio/docker-graphite-statsd
    ```

## Additional Reading

* [Introduction to Docker](http://docs.docker.io/#introduction)
* [Official Statsd Documentation](https://github.com/etsy/statsd/)
* [Practical Guide to StatsD/Graphite Monitoring](http://matt.aimonetti.net/posts/2013/06/26/practical-guide-to-graphite-monitoring/)
* [Configuring Graphite for StatsD](https://github.com/etsy/statsd/blob/master/docs/graphite.md)

