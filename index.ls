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
	simple = enhance . wrap-stream
	with-status = (code, rest)-->
		first = true
		enhance <| wrap-stream rest .flat-map (x)->
			if first
				first := false
				if x instanceof ρ.Status
					[ρ.Status code]
				else [
					ρ.Status code
					x
				]
			else [x]

	ok = with-status 200
	not-found = with-status 404
	error = with-status 500

	with-header = (name, value, rest)-->
		σ [ρ.Header name, value] .concat wrap-stream rest |> enhance

	type = with-header \content-type

	json = ok . type \application/json
	html = ok . type \text/html
	text = ok . type \text/plain

	redirect = (code, location, rest)-->
		enhance wrap-stream rest
		.with-status code
		.with-header \Location location

	moved-permanently = redirect 301
	found = redirect 302
	see-other = redirect 303
	temporary-redirect = redirect 307
	permanent-redirect = redirect 308
