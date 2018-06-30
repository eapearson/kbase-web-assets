# check that the deploy config file is ok.
NGINX_CFG=/etc/nginx/nginx.conf

echo "Checking nginx config file..."

if [ ! -f "${NGINX_CFG}" ]
then
    echo "The nginx config was not found"
    echo "Target file is ${NGINX_CFG}"
    exit 1
fi

if grep -q "<no value>" ${NGINX_CFG}
then
    echo "nginx config contains <no value>, indicating that the docker run"
    echo "environment is missing a key used in the config template."
    echo "Target file is ${NGINX_CFG}"
    exit 1
fi

echo "OK. Execing nginx... Press Control-C to exit."

# start nginx
exec nginx