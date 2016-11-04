# pydock

###### Python based utilities designed for Docker

I use Docker, and I like Python - So these utilities are based in Python (rather than Go or Ruby).

##### Main Files

* hapconf.py - generates [and saves] a configuration for haproxy (haproxy.cfg)


#### hapconf.py

This little script will inspect your running docker images and by checking the exposed ports, and the VIRTUAL_HOST enviroment variable will configure the backends automatically for all of them.

Note the caveat here of course is that you must have provided your docker run action with following information:
	
* `-P` to allow Docker to map/translate the exposed ports to the outside world.
* `-e  VIRTUAL_HOST=mysite.com` this allows us to inspect the incoming URL, otherwise how do we know.

e.g. you would have run Docker with:

`docker run -d -P -e VIRTUAL_HOST=mysite.com <IMG_ID>` with `-d` of course being damonised!

###### Usage

Run using `python3 hapconf.py` or  `./hapconf.py`
	
	usage: hapconf.py [-h] [--auto-write] destination
	
	positional arguments:
	  destination   Usually your haproxy.cfg location
	
	optional arguments:
	  -h, --help    show this help message and exit
	  --auto-write  Write file automatically (no interactive)
	  
	  
Generally speaking, if you are running this automatically in response to docker changes or periodically you'll use:
	`python3 hapconf.py --auto-write /etc/haproxy/haproxy.cfg` for example to immediately make live changes
	
If you wish to preview the changes you can use the interactive mode and/or save it somewhere temporarily
`python3 hapconf.py ./haproxy.cfg`

##### Script Permissions

The script should have permissions to do the following things:

* Execute the docker `ps` & `inspect` commands to query the state.
* Ideally read/write to the /etc/haproxy/haproxy.cfg (This will be able to inform you if there are effective changes).

The easiest way to do this would be to run it with `sudo`, as the script is trustworthy, however there's also the possibility to execute the script with a user configured for just those things.

You will need to reload your haproxy service once the config has been written for this to take effect.
In short this could be done like 

	sudo python3 hapconf.py --auto-write /etc/haproxy/haproxy.cfg && sudo service haproxy reload


#### Current Status

This is of course a fairly basic version, and I myself will improve on this script down the track (right now the options are fairly spartan).

#### Contributing

As always contributions are welcome, just make a pull request with your rationale.