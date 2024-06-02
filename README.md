# get_repos_urls
A script to extract public repos of an organization

## .sh scripts

* `getrepos.sh`: To generate a list of all the URLs of public repos of a given GitHub account, in a json file.  
* `get-priv-repos.sh`: If you have access to a GutHub organization it retrieves a list of URLs of such repos, in a json file.  
* `generate_gitclone_script.py`: From the fomer .json file generated above with `getrepos.sh` this creates a .sh file, with the designated name, to clone all those repos.  
* `generate_gitclone_private_script.py`: From the fomer .json file generated above with `get-priv-repos.sh` this creates a .sh file, with the designated name, to clone all those repos.  