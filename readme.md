# Dram [![Build Status](https://travis-ci.org/quarterto/Dram.svg)](https://travis-ci.org/quarterto/Dram)

Expressive response generators for Oban. Inspired by [Play! Framework](http://www.playframework.com/)'s [Results](http://www.playframework.com/documentation/2.0/api/java/play/mvc/Results.html) class.

`npm install dram`

## Example

```javascript
var handle = require('oban');
var resp   = require('dram');
var http   = require('http');

http.createServer(handle(function(req) {
	var o = resp.ok('hello world')
	return resp.withHeader('X-Powered-By', 'Oban', o);
})).listen(8000);
```

```bash
$ telnet localhost 8000
GET /
HTTP/1.1 200 OK
...snip...
X-Powered-By: Oban

hello world
```

## API
### `with-status :: StatusCode → Result → Result`
Adds the HTTP status to the Result. Partially applied as:
```haskell
ok ≡ with-status 200
not-found ≡ with-status 404
error ≡ with-status 500
```
### `with-header :: Name → Value → Result → Result`
Adds the HTTP header to the result.

### `redirect :: StatusCode → URI → Result → Result`
Sets 3XX status and Location header. Partially applied as:
```haskell
moved-permanently ≡ redirect 301
found ≡ redirect 302
see-other ≡ redirect 303
temporary-redirect ≡ redirect 307
permanent-redirect ≡ redirect 308
```

## Licence
MIT
