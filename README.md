Size.IO Ruby API
==========

The Size.IO Ruby API is a library which allows easy integration of the Size.IO platform into any Ruby application.  It can leverage a local [size-io/size-proxy](https://github.com/size-io/size-proxy) proxy server or connect directly to the cloud platform.

Supplemental Platform API documentation and code samples are available at **http://size.io/developer**

## Pre-requisites

Depending on how you want to publish events to the platform, you may need to install an additional Ruby gems.  It is recommended that you install [size-io/size-proxy](https://github.com/size-io/size-proxy) if possible:  this will provided the fastest and most efficient level of throughput.

Using [size-io/size-proxy](https://github.com/size-io/size-proxy):

 * `multi_json`
 * Gem options, in most to least recommended order: `oj`, `yajl`, `json`, `json_pure`. Will fallback to `okjson` if necessary.

Direct access to the platform (no proxy) requires [web-socket-ruby](https://github.com/gimite/web-socket-ruby)

## Using the Ruby API

### UDP Proxy Event Publishing

Using the UDP interface to a running [size-io/size-proxy](https://github.com/size-io/size-proxy) is definitely the fastest and cheapest way to publish events to the platform. These have essentially zero performance impact.

```ruby
client = Size::Client.new :connector=>:proxy, :interface=>:udp, :host=>'localhost', :port=>6120
client.publish "api.get", 1
```

### TCP Proxy Event Publishing

Using the TCP interface to a running [size-io/size-proxy](https://github.com/size-io/size-proxy) is still pretty fast and has the added benefit of complaining if for some reason it cannot connect to the proxy server.  On a LAN or local machine it will have pretty much no measurable impact on performance.

```ruby
client = Size::Client.new :connector=>:proxy, :interface=>'tcp', :host=>'localhost', :port=>6120
client.publish "api.get", 1
```

### Redis Proxy Event Publishing

@TODO: This.

### Direct Access to the Platform

If you operate in an environment where you cannot install a local [size-io/size-proxy](https://github.com/size-io/size-proxy), you can publish events to the platform directly by consuming the [WebSocket Event Publisher API](http://size.io/developer/api/publish/websocket).  This requires that [web-socket-ruby](https://github.com/gimite/web-socket-ruby) be installed. Simply configure the proxy settings to use `wss://api.size.io/v1.0`, set an Access Token and publish the event like normal.  Depending on ambient Internet conditions, this may have a measurable impact on performance, though no different than any other RESTful API out there.

```ruby
client = Size::Client.websocket :url=>'wss://api.size.io/v1.0', :access_token=>'00000000-0000-0000-0000-000000000000'
client.publish "api.get", 1
```

## Annotated Examples

Initialize a new proxy client
```ruby
client = Size::Client.new :connector=>:proxy, :interface=>:udp, :host=>'localhost', :port=>6120
```

`:interface` may be `tcp` or `udp` (or as symbols: `:tcp` and `:udp`)
```ruby
client = Size::Client.new :connector=>:proxy, :interface=>'tcp', :host=>'localhost', :port=>6120
```

There's also a shortcut initializer
```ruby
client = Size::Client.proxy :interface=>'tcp', :host=>"127.0.0.1", :port=>6120
```

`:interface` defaults to `tcp` and may be left out
```ruby
client = Size::Client.proxy :host=>'localhost', :port=>6120
```

Initialize a new websocket client
```ruby
client = Size::Client.new :connector=>:websocket, :url=>'wss://api.size.io/v1.0'
```

This too has a shortcut
```ruby
client = Size::Client.websocket :url=>'wss://api.size.io/v1.0'
```

The access token can be provided as a param
```ruby
client = Size::Client.proxy :host=>'localhost', :port=>6120, :access_token=>'00000000-0000-0000-0000-000000000000'
client = Size::Client.websocket :url=>'wss://api.size.io/v1.0', :access_token=>'00000000-0000-0000-0000-000000000000'
```

If it's left out, it will be automatically read from the SIZE_PUBLISHER_TOKEN environment variable.
These are functionally identical.
```ruby
client = Size::Client.proxy :host=>'localhost', :port=>6120, :access_token=>ENV['SIZE_PUBLISHER_TOKEN']
client = Size::Client.proxy :host=>'localhost', :port=>6120
```

Publish an event
```ruby
client.publish "api.get", 1
```

You can also use a symbol for the key
```ruby
client.publish :some_key, 5
```

The time defaults to the now() [based on the platform's clock]. You can override it though:
```ruby
client.publish "api.get", 1, Time.now
```

Or send the time as an epoch in milliseconds
```ruby
client.publish "api.get", 1, 1341619112013
```

If you need global access to the Size client, use a global variable
```ruby
$size = Size::Client.proxy :host=>'localhost', :port=>6120
$size.publish "api.get", 1
```