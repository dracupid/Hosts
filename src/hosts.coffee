fs = require 'fs'


hostsPath = "C:/Windows/System32/drivers/etc/hosts"

isIp = (ip)->
	/^(?:(?!0)[1-9]?[0-9]|1[0-9]{2}|2(?:[0-4][0-9]|5[0-5]))(?:\.(?:[1-9]?[0-9]|1[0-9]{2}|2(?:[0-4][0-9]|5[0-5]))){3}$/g.test ip

class Hosts
	constructor: (@path)->
		@map = {}

	add: (ip, name)->
		if @map[ip]
			@map[ip].push name
		else
			@map[ip] = [name]

	show: ()->
		couter = 1
		for ip, names of @map
			console.log "[#{couter}] #{ip} ----------------------------"
			names.forEach (name)->
				console.log "\t\t#{name}"
				couter++

	showNameByIp: (ip)->
		if not @map[ip]
			console.log "Not Found"
		counter = 1
		@map[ip].forEach (name)->
			console.log "[#{counter}] #{name}"
			counter++

	showIpByname: (name)->
		counter = 1
		for ip, names of @map
			for name_ in names
				if name_.indexOf(name) >= 0
					console.log "[#{counter}] #{ip}"
					counter++
					break; 
		if counter is 1
			console.log "Not Found"
	fetch: ()->
		try 
			content = fs.readFileSync @path, 'utf-8'
			content = content.replace(/#.*/g, "").split(/[(\n|\r|(\r\n))|(\u0085)|(\u2028)|(\u2029)]+/)
			content.forEach (item)=>
				if not item
					return
				else
					try
						[ip, name] = item.split /[\s]+/
						@add ip, name
					catch e
						console.log e
						return
		catch e
			console.log e
			


hosts = new Hosts(hostsPath)
hosts.fetch()

cmd = process.argv[2]

if (/(list)|l|ls/).test cmd
	hosts.show()
if (/(get)|g/).test cmd
	arg = process.argv[3]
	if isIp arg
		hosts.showNameByIp arg
	else 
		hosts.showIpByname arg

