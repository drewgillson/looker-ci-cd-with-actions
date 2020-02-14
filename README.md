Workshop objectives:

1. Find your SSH keys
2. Install Terraform
3. Create your DEV and PROD Looker instances
```
terraform init
terraform apply
# potentially create internal database connection automatically
```

On PROD:
1. Create the 'internal' database connection
    - Dialect: MySQL
    - Host: 127.0.0.1
    - Password: _generated password_
    - Persistent Derived Tables: yes
    - Temp Database: looker_tmp
2. Create a new blank project called 'production' on your PROD instance
3. Configure the project to use a git bare repository

On DEV:
1. Create the 'internal' database connection
    - Dialect: MySQL
    - Host: 127.0.0.1
    - Password: _generated password_
    - Persistent Derived Tables: yes
    - Temp Database: looker_tmp
2. Create a new project on your DEV instance using the Git Repository URL git://github.com/drewgillson/my_fruit_basket.git as the starting point
3. Create a new repository in your own Github account
4. Go to Project Settings to Reset Git Connection and point Looker to your new repository
    - Add Deploy Key
# 5. Turn on 'Pull Requests Required' and add deploy webhook to your new repository
#    - Paste Payload URL
#    - Disable SSL verification
6. Create API keys for your user
7. Configure the Github repo for your project
    - create LOOKERSDK secrets and PROJECT_ID secret and PRIVATE/PUBLIC_KEY secrets
    - set up Actions
8. Create a new branch called 'release/20200213'
9. Commit to the release branch and prove that Github Actions will land it on the Prod instance after tests pass