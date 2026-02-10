#!/bin/bash

# GitHub and GitLab configurations
GITHUB_OWNER='yudiz-solutions'
GITHUB_ACCESS_TOKEN=''
GITLAB_BASE_URL='https://gitlab.fantasywl.in/api/v4'
GITLAB_ACCESS_TOKEN=''
GITLAB_NAMESPACE_ID='' #Add your gitlab username

# Define repositories
repositories=(
  "fansportiz-web-panel"
  "fansportiz-admin-panel"
  # Add more repositories in the same format if needed
)

# Array to store GitHub repository IDs
github_repo_ids=()

# Function to fetch GitHub repository IDs using `gh` CLI
fetch_github_repo_ids() {
  for repo_name in "${repositories[@]}"
  do
    # Fetch repository ID using GitHub CLI `gh`
    repo_id=$(gh api -H "Accept: application/vnd.github.v3+json" repos/$GITHUB_OWNER/$repo_name | jq -r .id)
    github_repo_ids+=("$repo_id")
  done
}

# Function to import GitHub repositories into GitLab
import_github_repos_to_gitlab() {
  headers=(
    "Private-Token: $GITLAB_ACCESS_TOKEN"
    "Content-Type: application/json"
  )

  successful_imports=()
  failed_imports=()

  for repo_id in "${github_repo_ids[@]}"
  do
    data=$(cat <<EOF
{
  "personal_access_token": "$GITHUB_ACCESS_TOKEN",
  "repo_id": $repo_id,
  "target_namespace": "$GITLAB_NAMESPACE_ID"
}
EOF
)

    # Perform GitLab import
    response=$(curl -s -X POST -H "${headers[0]}" -H "${headers[1]}" --data "$data" "$GITLAB_BASE_URL/import/github")

    if [[ $(echo "$response" | jq -r '.id') != "null" ]]; then
      echo "Repository with ID $repo_id imported successfully."
      successful_imports+=("$repo_id")
    else
      echo "Failed to import repository with ID $repo_id."
      echo "Response: $response"
      failed_imports+=("$repo_id")
    fi
  done

  # Print summary of imports
  echo -e "\n--- Summary ---"
  echo "Successful Imports:"
  for repo_id in "${successful_imports[@]}"
  do
    echo "- Repository ID: $repo_id"
  done

  echo -e "\nFailed Imports:"
  for repo_id in "${failed_imports[@]}"
  do
    echo "- Repository ID: $repo_id"
  done
}

# Fetch GitHub repository IDs using `gh` CLI
fetch_github_repo_ids

# Import GitHub repositories into GitLab
import_github_repos_to_gitlab
