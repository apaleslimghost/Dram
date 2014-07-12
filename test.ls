require! {
	dram: './index.js'
	'expect.js'
}

export 'Dram':
	'with-status':
		'adds a status part': (done)->
			dram.with-status 153 'hello' .to-array (xs)->
				expect xs.0 .to.have.property \code 153
				expect xs.1 .to.be 'hello'
				done!

