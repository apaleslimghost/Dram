σ = require \highland
ρ = require \peat

wrap-stream = (a)->
	| σ.is-stream a => a
	| otherwise     => σ [] ++ a

export
	with-status = (code, rest)-->
		σ [ρ.Status code] .concat wrap-stream rest

	ok = with-status 200
	not-found = with-status 404
	error = with-status 500

	with-header = (name, value, rest)-->
		σ [ρ.Header name, value] .concat wrap-stream rest

	redirect = (code, location, rest)-->
		rest
		|> with-status code
		|> with-header \Location location

	moved-permanently = redirect 301
	found = redirect 302
	see-other = redirect 303
	temporary-redirect = redirect 307
	permanent-redirect = redirect 308
