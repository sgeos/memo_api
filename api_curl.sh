#!/bin/sh

reset() {
  HOST="http://localhost:8080"
  SCOPE=api
  ROUTE=memos
  METHOD="GET"
  FLAGS=""
  HEADERS="Content-Type: application/json"
  ID=""
  TITLE=""
  BODY=""
  EMAIL="user@host.org"
  PASSWORD="password"
}

usage() {
  reset
  echo "Usage:  ${0} [options]"
  echo "Options:"
  echo "  -o HOST : set URL host, defaults to \"${HOST}\""
  echo "  -s SCOPE : set URL scope, defaults to \"${SCOPE}\""
  echo "  -r ROUTE : set URL route, defaults to \"${ROUTE}\""
  echo "  -X METHOD : set HTTP method, defaults to \"${METHOD}\""
  echo "  -f FLAGS : set flags passed to curl, defaults to \"${FLAGS}\""
  echo "  -H HEADERS : set HTTP headers, defaults to \"${HEADERS}\""
  echo "  -i ID : set memo id, defaults to \"${ID}\""
  echo "  -t TITLE : set memo title, defaults to \"${TITLE}\""
  echo "  -b BODY : set memo body, defaults to \"${BODY}\""
  echo "  -e EMAIL : set user email, defaults to \"${EMAIL}\""
  echo "  -p PASSWORD : set user password, defaults to \"${PASSWORD}\""
  echo "  -h : display this help"
  echo "Examples:"
  echo "  ${0} -X POST -r \"users\" -e \"user@host.org\" -p \"password\""
  echo "  ${0} -X GET"
  echo "  ${0} -X GET -i 7"
  echo "  ${0} -X POST -t \"Memo Title\" -b \"Memo body here.\""
  echo "  ${0} -X PATCH -t \"Patched title.\" -i 7"
  echo "  ${0} -X PATCH -b \"Patched body.\" -i 7"
  echo "  ${0} -X PUT -t \"New Title\" -b \"New body.\" -i 7"
  echo "  ${0} -X DELETE -i 7"
  exit ${1}
}

reset
while getopts "o:s:r:X:f:H:i:t:b:e:p:h" opt
do
  case "${opt}" in
    o) HOST="${OPTARG}" ;;
    s) SCOPE="${OPTARG}" ;;
    r) ROUTE="${OPTARG}" ;;
    X) METHOD="${OPTARG}" ;;
    H) FLAGS="${OPTARG}" ;;
    H) HEADERS="${OPTARG}" ;;
    i) ID="${OPTARG}" ;;
    t) TITLE="${OPTARG}" ;;
    b) BODY="${OPTARG}" ;;
    e) EMAIL="${OPTARG}" ;;
    p) PASSWORD="${OPTARG}" ;;
    h) usage 1 ;;
    \?) usage 2 ;;
  esac
done
shift $(expr ${OPTIND} - 1)

case "${METHOD}_${ROUTE}" in
  PATCH_memos)
    # if defined replace individual fields with
    # JSON fragments followed by a comma and space
    TITLE=${TITLE:+"\"title\": \"${TITLE}\", "}
    BODY=${BODY:+"\"body\": \"${BODY}\", "}
    # strip trailing comma and space
    PAYLOAD="$(echo "${TITLE}${BODY}" | sed 's/, $//g')"
    # complete JSON payload
    PAYLOAD="{\"memo\": {${PAYLOAD}}}"
    ;;
  *_memos)
    PAYLOAD='{"memo": {"title": "'"${TITLE:-(no title)}"'", "body": "'"${BODY:-(no body)}"'"}}'
    ;;
  PATCH_users)
    EMAIL=${EMAIL:+"\"email\": \"${EMAIL}\", "}
    PASSWORD=${PASSWORD:+"\"password\": \"${PASSWORD}\", "}
    PAYLOAD="$(echo "${EMAIL}${PASSWORD}" | sed 's/, $//g')"
    PAYLOAD="{\"user\": {${PAYLOAD}}}"
    ;;
  *_users|*_register)
    PAYLOAD='{"user": {"email": "'"${EMAIL:-(no email)}"'", "password": "'"${PASSWORD:-(no password)}"'"}}'
    ;;
  *)
    PAYLOAD='{}'
    ;;
esac

case "${METHOD}" in
  GET)
    curl ${FLAGS} -H "${HEADERS}" -X ${METHOD} "${HOST}/${SCOPE}/${ROUTE}${ID:+"/${ID}"}"
    ;;
  POST)
    curl ${FLAGS} -H "${HEADERS}" -X ${METHOD} -d "${PAYLOAD}" "${HOST}/${SCOPE}/${ROUTE}" 
    ;;
  PUT)
    curl ${FLAGS} -H "${HEADERS}" -X ${METHOD} -d "${PAYLOAD}" "${HOST}/${SCOPE}/${ROUTE}/${ID:?'No ID specified.'}" 
    ;;
  PATCH)
    curl ${FLAGS} -H "${HEADERS}" -X ${METHOD} -d "${PAYLOAD}" "${HOST}/${SCOPE}/${ROUTE}/${ID:?'No ID specified.'}" 
    ;;
  DELETE)
    curl ${FLAGS} -H "${HEADERS}" -X ${METHOD} "${HOST}/${SCOPE}/${ROUTE}/${ID:?'No ID specified.'}"
    ;;
  *)
    usage 2
    ;;
esac
echo ""
echo ""
echo "${METHOD}_${ROUTE}"
echo "${PAYLOAD}"
echo ""

