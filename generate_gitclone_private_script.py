import json
import os

# Prompt the user for the filename
file_name = input("Enter the filename for the shell script (without .sh extension): ")
script_path = f"./{file_name}.sh"

# Read the JSON file
with open('../GET/all_private_repos.json', 'r') as file:
    urls = json.load(file)

# Generate the shell script content
with open(script_path, 'w') as script:
    for url in urls:
        script.write(f'git clone {url}\n')

# Make the shell script executable
os.chmod(script_path, 0o755)