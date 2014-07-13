σ = require \highland
ρ = require \peat

wrap-stream = (a)->
	| σ.is-stream a => a
	| otherwise     => σ [] ++ a

to-method = (fn)->
	(...args)-> fn ...args, this

enhance = (import {
	with-status: to-method with-status
	with-header: to-method with-header
})

export
	with-status = (code, rest)-->
		first = true
		wrap-stream rest
		.consume (err, x, push, next)->
			if err
				push err
				next!
			else if first
				if x instanceof ρ.Status
					push null ρ.Status code
					next!
				else
					push null ρ.Status code
					push null x
					next!
				first := false
			else
				push null x
				next!
		|> enhance

	ok = with-status 200
	not-found = with-status 404
	error = with-status 500

	with-header = (name, value, rest)-->
		σ [ρ.Header name, value] .concat wrap-stream rest |> enhance

	redirect = (code, location, rest)-->
		enhance wrap-stream rest
		.with-status code
		.with-header \Location location

	moved-permanently = redirect 301
	found = redirect 302
	see-other = redirect 303
	temporary-redirect = redirect 307
	permanent-redirect = redirect 308
