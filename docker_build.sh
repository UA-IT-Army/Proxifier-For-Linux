#!/bin/sh

PROXIFIER_DIR=${1-:"."}
cd ${PROXIFIER_DIR}

source /etc/os-release

FLAVOUR=${FLAVOUR:-""}
OS_IMAGE=${OS_IMAGE:-""}

guess_flavour(){
  for f in ${ID} ${ID_LIKE}
  do
    file_name="Dockerfile.${f}"
    [ -r ${file_name} ] && FLAVOUR=${f}
  done
  echo "Flavour guessed: ${FLAVOUR}"
}

guess_image(){
  case ${ID} in
    debian|ubuntu|fedora|centos)
        OS_IMAGE="${ID}:${VERSION_ID}"
        ;;
    kali)
        OS_IMAGE="kalilinux/kali-rolling:${VERSION_ID}"
        ;;
  esac
}

[ -z "${FLAVOUR}" ] && guess_flavour
[ -z "${OS_IMAGE}" ] && guess_image
echo "Flavour: ${FLAVOUR}"
echo "Image: ${OS_IMAGE}"
FLAVOUR=${FLAVOUR:-debian}
OS_IMAGE=${OS_IMAGE:-debian}


# FLAVOUR=${FLAVOUR:-debian}
# OS_IMAGE=${OS_IMAGE:-debian}

docker build -t proxifier -f Dockerfile.${FLAVOUR} .
docker build --build-arg BASE=${OS_IMAGE} -t proxifier -f Dockerfile.${FLAVOUR} .
docker run --rm --name=proxifier -d proxifier sleep 600
docker cp proxifier:/srv/app .
tar -czf proxifier.tgz -C app usr