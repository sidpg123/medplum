#!/usr/bin/env bash

pushd packages/graphiql

# First deploy hashed files that are cached forever
# It is important to deploy these files first,
# because they are referenced by the index.html file.
# If a user attempts to download a hashed file that doesn't exist,
# it can cause a bad cache entry in CloudFront.

aws s3 cp dist/ s3://graphiql.medplum.com/ \
  --region us-east-1 \
  --recursive \
  --content-type "text/css" \
  --cache-control "public, max-age=31536000" \
  --exclude "*" \
  --include "*.css"

aws s3 cp dist/ s3://graphiql.medplum.com/ \
  --region us-east-1 \
  --recursive \
  --content-type "text/javascript" \
  --cache-control "public, max-age=31536000" \
  --exclude "*" \
  --include "*.js"

aws s3 cp dist/ s3://graphiql.medplum.com/ \
  --recursive \
  --content-type "application/json" \
  --cache-control "public, max-age=31536000" \
  --exclude "*" \
  --include "*.map"

aws s3 cp dist/ s3://graphiql.medplum.com/ \
  --region us-east-1 \
  --recursive \
  --content-type "text/plain" \
  --cache-control "public, max-age=31536000" \
  --exclude "*" \
  --include "*.txt"

# Now deploy named files that are not cached.
# These are small lightweight files that are not hashed.
# It is important to deploy these files last,
# because they reference the previously uploaded hashed files.

aws s3 cp dist/ s3://graphiql.medplum.com/ \
  --region us-east-1 \
  --recursive \
  --content-type "text/html" \
  --cache-control "no-cache" \
  --exclude "*" \
  --include "*.html"

popd
