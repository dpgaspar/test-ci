set -eo pipefail

SHA=$(git rev-parse HEAD)
REPO_NAME="test"

if [[ "${GITHUB_EVENT_NAME}" == "pull_request" ]]; then
  REFSPEC=$(echo "${GITHUB_HEAD_REF}" | sed 's/[^a-zA-Z0-9]/-/' | head -c 20)
  PR_NUM=$(echo "${GITHUB_REF}" | sed 's:refs/pull/::' | sed 's:/merge::')
  LATEST_TAG="pr-${PR_NUM}"
elif [[ "${GITHUB_EVENT_NAME}" == "release" ]]; then
  REFSPEC=$(echo "${GITHUB_REF}" | sed 's:refs/tags/::' | head -c 20)
  LATEST_TAG="${REFSPEC}"
else
  REFSPEC=$(echo "${GITHUB_REF}" | sed 's:refs/heads/::' | sed 's/[^a-zA-Z0-9]/-/' | head -c 20)
  LATEST_TAG="${REFSPEC}"
fi

if [[ "${REFSPEC}" == "master" ]]; then
  LATEST_TAG="latest"
fi

cat<<EOF
  Rolling with tags:
  - ${REPO_NAME}:${SHA}
  - ${REPO_NAME}:${REFSPEC}
  - ${REPO_NAME}:${LATEST_TAG}
EOF

ls -R

