image_base="kbase/kbase-web-assets"
branch=$(git symbolic-ref --short HEAD 2>&1)
image_tag="${branch}"

docker run -it ${image_base}:${image_tag} /bin/bash
