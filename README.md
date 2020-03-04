# Looker CI/CD with Github Actions Workshop
## Learning Objectives
By the end of this workshop
- You will be able to use Terraform to quickly create Looker environments for testing purposes.
- You will create an isolated Development environment and a Production environment in less than 10 minutes.
- You will configure Github Actions to automatically run data tests and the content validator each time someone makes a commit to their personal branch on Dev.
- You will also configure Github Actions to watch for commits to branches beginning with the word _release_, and when it finds them, to automatically deploy their contents to Prod.

This workshop will aim to improve your understanding of Looker data tests, various command line skills, your Git knowledge, your understanding of the configuration-as-code paradigm, and it will introduce you to a bit of Python. You will finish the workshop with a clearer idea of how to support customers who want to build complex development workflows including CI/CD-like functionality.

The overall goal of the session is to be able to advise customers about a best practice approach for code and content migration.

## What's Possible
### Run Data Tests and Leave Annotations On Failing Tests
![Visual Overview](github-actions-data-tests-integration.gif)

### Deploy Release Branches to Production Automatically
![Visual Overview](github-actions-deploy-to-prod.gif)

### Update remote_dependency `ref` Value By Tracking Hub Commits
[![Visual Overview](https://github.com/drewgillson/looker-fruit-basket/raw/master/.github/workflows/github-actions-update-remote-dependency-ref.gif)](https://github.com/drewgillson/looker-fruit-basket/blob/master/.github/workflows/update_remote_dependency_ref.yml)

## Prerequisites
* Ensure you have SSH keys in `~/.ssh`. If you don't have any you will need to [generate](https://help.github.com/en/enterprise/2.18/user/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) a keypair.
* [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

## Setup Instructions
1. First, fork this repository and check it out to your local computer, then edit `variables.tf` to set your own Looker license key and technical contact email.

2. Run `aws-azure-login --profile="sandbox"` to refresh your AWS API credentials. Follow the [instructions on Guru](https://app.getguru.com/card/iozzGyeT/Setup-for-AWS-API-Creds-Through-Lookery-SSO) to install the aws-azure-login utility.

3. Now, create your DEV and PROD Looker instances by running these Terraform commands in the working directory:
```
    terraform init
    terraform apply
```
4. After your instances are ready, log into the Looker UI and manually create a database connection on both DEV and PROD:
    - Name: internal
    - Dialect: MySQL
    - Host: 127.0.0.1
    - Username: looker
    - Password: _use generated password found at the bottom of Terraform output_
    - Persistent Derived Tables: yes
    - Temp Database: looker_tmp

5. On your PROD instance, create a blank project called 'production'
    - Configure the project to use a git bare repository

6. On your DEV instance, create a project called 'dev' using the Git Repository URL [git://github.com/drewgillson/my_fruit_basket.git](https://github.com/drewgillson/my_fruit_basket) as the starting point
    - Create a new repository in your own Github account
    - Go to the dev Project Settings page and reset the git connection
    - Point the project to your new repository and ensure you give the Deploy Key write access

7. On your DEV instance, create API keys for your user. You will need the client ID and secret in the next step.

8. On your Github project's Settings > Secrets page, set values for the following secrets, which get used by the Python and Bash code within the Actions. You can find the values for your public and private key by inspecting the contents of the files in your `~/.ssh` directory. You need to use the same key that Terraform used.

    | Secret                  | Example Value                                             |
    |-------------------------|-----------------------------------------------------------|
    | LOOKERSDK_API_VERSION   | 3.1                                                       |
    | LOOKERSDK_BASE_URL      | https://ec2-0-0-0-0.us-west-2.compute.amazonaws.com:19999 |
    | LOOKERSDK_CLIENT_ID     | AaBbCcDdEe                                                |
    | LOOKERSDK_CLIENT_SECRET | 1234567890                                                |
    | LOOKERSDK_VERIFY_SSL    | False                                                     |
    | PRIVATE_KEY             | -----BEGIN RSA PRIVATE KEY----- ...                       |
    | PUBLIC_KEY              | ssh-rsa A1B2C3D4E5F6 ...                                  |
    | PROJECT_ID              | dev                                                       |

9. Configure Github Actions by placing the contents of the `github` directory in this repository into a `.github` directory in your new forked repository. It might be easiest to do this within the Github UI. You need to create four files:
    - [.github/actions/requirements.txt](https://raw.githubusercontent.com/drewgillson/looker-ci-cd-with-actions/master/github/actions/requirements.txt)
    - [.github/actions/run_data_tests_and_content_validator.py](https://raw.githubusercontent.com/drewgillson/looker-ci-cd-with-actions/master/github/actions/run_data_tests_and_content_validator.py)
    - [.github/workflows/deploy_to_production.yml](https://raw.githubusercontent.com/drewgillson/looker-ci-cd-with-actions/master/github/workflows/deploy_to_production.yml)
    - [.github/workflows/run_data_tests_and_content_validator.yml](https://raw.githubusercontent.com/drewgillson/looker-ci-cd-with-actions/master/github/workflows/run_data_tests_and_content_validator.yml)

## Exercises
You're ready to play!

1. Commit a breaking change to your personal development branch (hint: just change the assertion expression on line 12 of `fruit_store.model.lkml` to a different fruit); then observe how Github Actions runs data tests automatically and will insert a comment above any failing `test` structures. Try to understand why we have to check the commit message using the [contains](https://help.github.com/en/actions/reference/contexts-and-expression-syntax-for-github-actions#functions) function on line 49 of [run_data_tests_and_content_validator.yml](https://github.com/drewgillson/looker-ci-cd-with-actions/blob/master/github/workflows/run_data_tests_and_content_validator.yml#L49)

2. Create a new branch called 'release/YYYYMMDD' and observe how Github Actions automatically promotes your new release branch to Prod. This strategy would require a release coordinator to cut a release branch outside of Looker based on the feedback from their UAT team.
