σ = require \highland
ρ = require \peat
oreo = require \cookie

wrap-stream = (a)->
	| σ.is-stream a => a
	| otherwise     => σ [] ++ a

to-method = (fn)->
	(...args)-> fn ...args, this

methods = -> {[k, to-method v] for k, v of it}

enhance = (import methods {
	with-header, with-status, with-cookie, with-cookie-simple
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

	with-cookie = (k, v, opts, rest)-->
		with-header \set-cookie (oreo.serialize k, v, opts), rest

	with-cookie-simple = (k, v, rest)-->
		with-cookie k, v, null, rest

	redirect = (code, location, rest)-->
		enhance wrap-stream rest
		.with-status code
		.with-header \Location location

	moved-permanently = redirect 301
	found = redirect 302
	see-other = redirect 303
	temporary-redirect = redirect 307
	permanent-redirect = redirect 308
