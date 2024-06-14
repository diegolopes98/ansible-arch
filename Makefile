build:
	podman build . -t archlab 

run:
	podman run --rm -it archlab

run-bash:
	podman run --rm -it archlab bash
