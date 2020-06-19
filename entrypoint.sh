#!/bin/bash

function stripPWD() {
	sed -E "s/$(pwd|sed 's/\//\\\//g')\///"
}

function stripSwiftInfoExtras() {
    sed -E "/.*^\* .*/d"
}

function addEscapedNewlines() {
    sed -E "s/$/\\\\n/"
}

SWIFTINFO_OUTPUT="$(swiftinfo -v | stripPWD | stripSwiftInfoExtras | addEscapedNewlines)"
SWIFTINFO_OUTPUT="${SWIFTINFO_OUTPUT:-SwiftInfo run failed; see Action log}"

echo "::set-output name=swiftinfo-output::"$SWIFTINFO_OUTPUT""

echo "$SWIFTINFO_OUTPUT"

PR_NUM=$(echo "$GITHUB_REF" | tr -d -c 0-9);
jq -nc "{\"body\": \"$SWIFTINFO_OUTPUT\"}" | \
curl -sL  -X POST -d @- \
-H "Content-Type: application/json" \
-H "Authorization: token $INPUT_TOKEN" \
"https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$PR_NUM/comments"
