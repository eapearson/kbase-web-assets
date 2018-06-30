# run-image.bash
# A bash script to run the image for local development

function usage() {
    echo 'Usage: run-image.sh <env> <net>'
    echo '  <env> is the deploy environment, either dev, ci, next, appdev or prod'
    echo '  <net> is the docker custom network'
}

environment=$1
if [ -z "$environment" ]; then 
    echo "ERROR: argument 1, 'environment', not provided"
    usage
    exit 1
fi

network=$2
if [ -z "$network" ]; then 
    echo "ERROR: argument 2, 'network', not provided"
    usage
    exit 1
fi

root=$(git rev-parse --show-toplevel)
config_mount="${root}/config/deploy"
branch=$(git symbolic-ref --short HEAD 2>&1)

if [ ! -e "${config_mount}/${environment}.env" ]; then
    echo "ERROR: environment (arg 1) does not resolve to a config file in ${config_mount}/${environment}.env"
    usage
    exit 1
fi

echo "CONFIG MOUNT: ${config_mount}"
echo "ENVIRONMENT : ${environment}"
echo "NETWORK     : ${network}"
echo "BRANCH      : ${branch}"

kbase_module=kbase-web-assets
image_base="kbase/kbase-web-assets"
image_tag="${branch}"

echo "Running image ${image_base}:${image_tag}"
echo ":)"

#   -p 8080:80 \

docker run \
  --rm \
  --env-file ${config_mount}/${environment}.env \
  --name=${kbase_module} \
  --network=${network} \
  ${image_base}:${image_tag} 
