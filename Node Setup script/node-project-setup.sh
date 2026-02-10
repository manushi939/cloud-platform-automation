#!/bin/bash

# Function to prompt for GitHub credentials
prompt_github_credentials() {
  read -p "Enter the GitHub repository URL: " repo_url
  read -p "Enter your GitHub username: " github_username
  read -s -p "Enter your GitHub personal access token: " github_token
  echo
}

# Function to clone the repository
clone_repo() {
  echo "Cloning repository..."
  if [ -z "$project_name" ]; then
    if [ "$(ls -A $project_path)" ]; then
      project_dir="${project_path}/$(basename ${repo_url} .git)"
    else
      project_dir=${project_path}
    fi
  else
    project_dir=${project_path}/${project_name}
  fi

  mkdir -p ${project_dir}
  
  # Correct URL format for cloning
  git clone https://${github_username}:${github_token}@${repo_url#https://} ${project_dir}
  cd ${project_dir}
}

# Function to checkout a branch
checkout_branch() {
  git branch -a
  read -p "Enter the branch to checkout: " branch_name
  git checkout ${branch_name}
}

# Function to setup Node.js version using NodeSource
setup_node_version() {
  current_node_version=$(node --version)
  echo "Currently installed Node.js version: ${current_node_version}"

  read -p "Do you want to use this version? (y/n): " use_current_version
  if [ "$use_current_version" != "y" ]; then
    read -p "Enter the major version of Node.js to install (e.g., 16 or 18): " node_version

    curl -sL https://deb.nodesource.com/setup_${node_version}.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi
}

# Function to add environment variables
add_env_file() {
  echo "Paste your .env file content and press Ctrl+D when done:"
  cat > .env
}

# Function to install dependencies and build project
install_and_build() {
  if npm install; then
    echo "npm install succeeded."
  else
    echo "npm install failed, trying npm install --force."
    npm install --force
  fi

  if grep -q "\"build\"" package.json; then
    npm run build
  fi
}

# Function to start project with pm2
start_pm2() {
  read -p "Enter the name for the pm2 process: " pm2_name
  pm2 start index.js --name ${pm2_name}
}

# Function to setup pm2 log rotation if not already configured
setup_pm2_logrotate() {
  if pm2 describe pm2-logrotate &>/dev/null; then
    echo "pm2-logrotate is already configured. Skipping setup."
  else
    read -p "Enter the maximum size for each log file (e.g., 10M for 10MB): " max_size
    read -p "Enter the number of days to retain log files: " retain_days

    echo "Installing pm2-logrotate..."
    pm2 install pm2-logrotate
    echo "Configuring pm2-logrotate..."
    pm2 set pm2-logrotate:max_size ${max_size}
    pm2 set pm2-logrotate:retain ${retain_days}
  fi
}

# Function to setup pm2 startup script if not already configured
setup_pm2_startup() {
  echo "Setting up PM2 startup script..."
  sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
}

# Function to save pm2 processes
save_pm2_processes() {
  echo "Saving PM2 processes..."
  pm2 save
}

# Main script execution
project_path="/home/ubuntu"
read -p "Enter the name of the directory (leave empty to clone into /home/ubuntu): " project_name

prompt_github_credentials
clone_repo
checkout_branch

setup_node_version
add_env_file
install_and_build
start_pm2

setup_pm2_logrotate
setup_pm2_startup
save_pm2_processes

echo "Project setup and started with pm2."
