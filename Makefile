.PHONY: plt


plt:
	mix dialyzer.plt
	dialyzer --add_to_plt --plt scripture.plt --output_plt scripture.plt _build/dev/lib/plug/ebin _build/dev/lib/ecto/ebin

