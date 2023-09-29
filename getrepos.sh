#!/bin/bash

# Prompt the user for the organization name
read -p "Enter the GitHub organization name: " org_name

# Prompt the user for the maximum number of public repositories
read -p "Enter the maximum number of public repositories: " max_public_repos

# Calculate the value for max_pages
max_pages=$(( (max_public_repos / 30) + 1 ))

# Initialize an empty array to store all repository URLs
all_repo_urls=()

# Set the base URL
base_url="https://api.github.com/orgs/$org_name/repos?type=public&page="

# Use a loop to retrieve pages of repositories
for ((page_number = 1; page_number <= max_pages; page_number++)); do
  # Print a progress message
  echo "Fetching page $page_number..."

  # Construct the URL for the current page
  url="$base_url$page_number"

  # Retrieve repositories for the current page
  page_data=$(curl -s "$url")

  # Extract repository URLs and add them to the array
  repo_urls=($(echo "$page_data" | jq -r '.[].html_url'))

  # Append URLs to the all_repo_urls array
  all_repo_urls+=("${repo_urls[@]}")

  # Check if we've reached the last page
  if [ -z "$repo_urls" ]; then
    break
  fi
done

# Convert the array to a JSON array using jq
json_array=$(jq -n --argjson urls "$(printf '%s\n' "${all_repo_urls[@]}" | jq -R -s -c 'split("\n")[:-1]')" '$urls')

# Save the JSON array to a file
echo "$json_array" > all_public_repos.json

echo "All public repositories fetched and saved to all_public_repos.json."
