.PHONY: plt hard_deploy


plt:
	mix dialyzer.plt
	dialyzer --add_to_plt --plt scripture.plt --output_plt scripture.plt _build/dev/lib/plug/ebin _build/dev/lib/ecto/ebin

hard_deploy:
	mix edeliver build release --branch=deployment \
	&& mix edeliver deploy release to production \
	&& mix edeliver restart production
