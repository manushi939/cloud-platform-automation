#!/bin/bash

# AWS profile and region
PROFILE=""
REGION="eu-west-2"

# Lifecycle policy JSON
POLICY=$(cat <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep only the last 5 images, delete older ones",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
)

# Get all ECR repository names
REPOS=$(aws ecr describe-repositories \
  --query "repositories[].repositoryName" \
  --output text \
  --region "$REGION" \
  --profile "$PROFILE")

# Loop through each repository
for REPO in $REPOS; do
  echo "Checking $REPO..."

  # Check if a lifecycle policy is already applied
  if aws ecr get-lifecycle-policy \
    --repository-name "$REPO" \
    --region "$REGION" \
    --profile "$PROFILE" &> /dev/null; then
    echo "  ➤ Lifecycle policy already applied for $REPO"
  else
    echo "  ➤ Applying lifecycle policy to $REPO"
    aws ecr put-lifecycle-policy \
      --repository-name "$REPO" \
      --lifecycle-policy-text "$POLICY" \
      --region "$REGION" \
      --profile "$PROFILE"
  fi
done
