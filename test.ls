require! {
	dram: './index.js'
	'expect.js'
}

export 'Dram':
	'simple':
		'just wraps': (done)->
			dram.simple 'hello' .to-array (xs)->
				expect xs.0 .to.be 'hello'
				done!

	'with-status':
		'adds a status part': (done)->
			dram.with-status 153 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \code 153
				expect xs.1 .to.be 'hello'
				done!

		'ok is with-status 200': (done)->
			dram.ok 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \code 200
				expect xs.1 .to.be 'hello'
				done!

		'not-found is with-status 404': (done)->
			dram.not-found 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \code 404
				expect xs.1 .to.be 'hello'
				done!

		'error is with-status 500': (done)->
			dram.error 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \code 500
				expect xs.1 .to.be 'hello'
				done!

	'with-header':
		'adds a header part': (done)->
			dram.with-header \foo \bar 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \name  \foo
				expect xs.0 .to.have.property \value \bar
				expect xs.1 .to.be 'hello'
				done!

	'type':
		'sets the content-type header': (done)->
			dram.type 'application/json' 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \name  \content-type
				expect xs.0 .to.have.property \value \application/json
				expect xs.1 .to.be 'hello'
				done!

	'redirect':
		'adds a status and a location header': (done)->
			dram.redirect 302 '/foo' 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \name  \Location
				expect xs.0 .to.have.property \value '/foo'
				expect xs.1 .to.have.property \code 302
				expect xs.2 .to.be 'hello'
				done!

		'found is redirect 302': (done)->
			dram.found '/foo' 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \name  \Location
				expect xs.0 .to.have.property \value '/foo'
				expect xs.1 .to.have.property \code 302
				expect xs.2 .to.be 'hello'
				done!

		'see-other is redirect 303': (done)->
			dram.see-other '/foo' 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \name  \Location
				expect xs.0 .to.have.property \value '/foo'
				expect xs.1 .to.have.property \code 303
				expect xs.2 .to.be 'hello'
				done!

		'temporary-redirect is redirect 307': (done)->
			dram.temporary-redirect '/foo' 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \name  \Location
				expect xs.0 .to.have.property \value '/foo'
				expect xs.1 .to.have.property \code 307
				expect xs.2 .to.be 'hello'
				done!
				
		'permanent-redirect is redirect 308': (done)->
			dram.permanent-redirect '/foo' 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \name  \Location
				expect xs.0 .to.have.property \value '/foo'
				expect xs.1 .to.have.property \code 308
				expect xs.2 .to.be 'hello'
				done!

	'chaining api':
		'can chain with-header': (done)->
			dram.ok 'hello' .with-header \foo \bar .to-array (xs)->
				expect xs.0 .to.have.property \name  \foo
				expect xs.0 .to.have.property \value \bar
				expect xs.1 .to.have.property \code 200
				expect xs.2 .to.be 'hello'
				done!
		'can chain with-status': (done)->
			dram.simple 'hello' .with-status 500 .to-array (xs)->
				expect xs.0 .to.have.property \code 500
				expect xs.1 .to.be 'hello'
				done!
		'can chain both of them': (done)->
			dram.simple 'hello' .with-status 500 .with-header \foo \bar .to-array (xs)->
				expect xs.0 .to.have.property \name  \foo
				expect xs.0 .to.have.property \value \bar
				expect xs.1 .to.have.property \code 500
				expect xs.2 .to.be 'hello'
				done!
		'can chain multiple with-status, and it replaces': (done)->
			dram.simple 'hello'
			.with-status 500
			.with-status 123
			.with-status 200
			.to-array (xs)->
				expect xs.0 .to.have.property \code 200
				expect xs.1 .to.be 'hello'
				done!
		'can chain multiple with-header, and it aggregates': (done)->
			dram.simple 'hello'
			.with-header \frob \snaf
			.with-header \baz  \quux
			.with-header \foo  \bar
			.to-array (xs)->
				expect xs.0 .to.have.property \name  \foo
				expect xs.0 .to.have.property \value \bar
				expect xs.1 .to.have.property \name  \baz
				expect xs.1 .to.have.property \value \quux
				expect xs.2 .to.have.property \name  \frob
				expect xs.2 .to.have.property \value \snaf
				expect xs.3 .to.be 'hello'
				done!

