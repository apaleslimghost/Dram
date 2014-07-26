# Dram [![Build Status](https://travis-ci.org/quarterto/Dram.svg)](https://travis-ci.org/quarterto/Dram)

Expressive response generators for Oban. Inspired by [Play! Framework](http://www.playframework.com/)'s [Results](http://www.playframework.com/documentation/2.0/api/java/play/mvc/Results.html) class.

`npm install dram`

## Example

```javascript
var handle = require('oban');
var resp   = require('dram');
var http   = require('http');

http.createServer(handle(function(req) {
	return resp.ok('hello world').withHeader('X-Powered-By', 'Oban');
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
#### `simple :: Body → Result`
Wraps any body-like object (String, Buffer, Array of String or Buffer, Stream of String or Buffer) in Result, so it can be chained.
#### `with-status :: StatusCode → Result → Result`
Adds the HTTP status to the Result. Can be called as a chained method on Results. Partially applied as:
```haskell
ok ≡ with-status 200
not-found ≡ with-status 404
error ≡ with-status 500
```
#### `with-header :: Name → Value → Result → Result`
Adds the HTTP header to the result.  Can be called as a chained method on Results.

#### `redirect :: StatusCode → URI → Result → Result`
Sets 3XX status and Location header. Partially applied as:
```haskell
moved-permanently ≡ redirect 301
found ≡ redirect 302
see-other ≡ redirect 303
temporary-redirect ≡ redirect 307
permanent-redirect ≡ redirect 308
```

#### `type :: ContentType → Result → Result`
Shorthand for `with-header 'content-type'`.

#### `json`, `html`, `text`
Shorthand for `type 'application/json'`, `type 'text/html'` and `type 'text/plain'` respectively.

#### `with-cookie :: Name → Value → CookieOptions → Request → Request`
Serialises a cookie value using [cookie](https://github.com/defunctzombie/node-cookie), and does `with-header 'set-cookie'` with it. For information on the possible options, see [cookie's documentation](https://github.com/defunctzombie/node-cookie#more).

#### `with-session-cookie :: Name → Value → Request → Request`
Set a cookie with no expiry (or other options).

## Licence
MIT
