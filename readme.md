# Docker container for remote development
This container can be used to isolate you development enivronment from you host machine.
It targets debian based host machines.
## features
* Passes ssh-agent to the docker container to use your SSH keys
* DotNet sdk-7.0
* Uses host pfx file for asp dotnet https development

# Setup the ssh-agent
If required the ssh-agent must be started, this is correclty setup by default on Ubuntu.
`eval $(ssh-agent)`
'ssh-add'

# Setup the pfx file
For https support during asp dotnet development the PFX file needs to be setup properly.
To add the self signed development ssl certifcate to the Ubuntu certificate store run the next:
'$(repo_base/.resources/scrall/scrall.sh -e aspnet-httsp-dev)'
'cp ~/.aspnet/https/dotnet-devcert.pfx ./resources/'
