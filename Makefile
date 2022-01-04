image:
	DOCKER_BUILDKIT=1 docker build -f Dockerfile -t opencl-cts context/

run: image
	docker run -it --rm --device /dev/dri:/dev/dri opencl-cts

all: run
