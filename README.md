# Terraform Wrapper
*by Phil Davies on [Github](https://github.com/wonderphil)*

Simplifying terraform, aws and infra-as-code

## Forwarning:
Firstly I have written this a couple times because I wasn't happy with the complexity that terraform had, and my requirement was to make infra-as-code as easy for the Dev's, DevOps, Qa's and everyone else in the IT team I was in.  When I started writing the first version of this I was just a lonely old DevOps guy trying to change the world, I wrote it in ruby, which I had self-taught and thus I say this;  I probably did things in ways I shouldn't have or in ways that could be better, I am happy for pull request and I am happy for suggestions, either  to make it better or new features.

So far this is to build only on AWS and has only been tested on mac!

So that said, please use this as you please, all I ask is that you give credit where due.

**CONTRIBUTING**
 - **Document any change in behaviour**. Make sure the PR and any other relevant documentation are kept up-to-date.
    
 -   **Create topic branches**. Please don't ask me to pull from your master branch.
    
 -   **One pull request per feature**. If you want to do more than one thing, send multiple pull requests.

Right with that out of the way, lets get to the fun stuff

# General Terms Used
 - **Service** - A service is a reference to a group of apps/infra that provides some function.  i.e. a service could be built from multiple apps including backend and frontend.
 - 

# Files

### build_config.json
This json file is used to store some basic config used by all the terraform wrapper scripts.

`config_version` -  just used to track changes to config

`default_envs` -  provide an array of environments that you want built by default when generating new service i.e. `["prod", "staging", "uat", "qa", "dev"]`

`default_region` -  default region to build things in
  
`environment_prefix` -  This is used for finding aws creds, you might have standard environment called dev, in the creds file this might actually be something like `companyname-dev` so your prefix should be `companyname-`

`prod_profile` -  ????

`state_bucket` -  s3 bucket name of where the terraform state is stored

`state_kms` -  the kms key id that is used to encrypted the state bucket with 

`state_profile` -  The aws creds profile for your prod account, this account is used to keep terraform state data

`state_region` -  The region that the s3 bucket is kept, this is main for connecting to s3.

  
`tamplate_files` -  when generating a new service you want to have some defualt terraform config, something that people can start with.  This is an array of file names that must be in the `!Template` folder for the generate script to run. i.e. `["main.tf", "outputs.tf", "variables.tf"]`

`terraform_version` -  version of terraform that has been used to build verything, now days terraform will tell you as well when the version of config has been built with higher or lower version of terraform, but this is just a extra check.



### generate
Generate script is used to build out the base of a service.  It will first check if all the required setup is in place, this includes:
 - template folder exists and has base teamplates files*
 - checks that your aws creds are vaild and not expired**
 - checks that s3 in your production account has the terraform state bucket***

Once those checks are done, the script will ask for user input for *service name, owning team* and *basic description* of the service that is being built.

Next the action the script takes is to build the following folder layout:

```
repo-root
│ ...
│
└───services
│   │
│   └─── service_name (Generates from here down)
│        │  main.tf
│        │  outputs.tf
│        │  variables.tf
│        │  README.md
│        │  CHANGELOG.md
│        │
│        └─── config
│             │ backend.conf
│             │ env-region-terraform.tfvars
│             │ ...
│
│ ...
```

Next the action the script takes is to build the following folder layout:

After the folder layout and cofig files are created, it will run terraform to do two things:
1. create workspace with format of *env-region*
2. then do a terraform init

\* `build_config.json` should provide an array of template files needed in the template folder (*repo_root/services/!Template/*)

\*\* See requirements for aws creds below.

\*\*\* See manually built items below.

### build
Build is what does all the hard work.  This is what should make life better when using terraform.  The basis of this script was, at the time we had so many different configs for so many regions, for different apps, environments and it was a massive mess.  So to clean it up and make managable, we split config up in different layers.  Promblem now is every time someone runs terraform they need to remember to add each config file to the command and also had to remember to switch workspaces.  Come in build, build removes all that, now when someone wants to run terraform, all the need to know is what service they are building, which region and enviroment they are building in, build will then do the rest.


# Requirements for AWS Creds

As this is using ruby, it uses the AWS Ruby SDK and means all terraform wrapper scripts will look for:

```
 ~/.aws/config
 ~/.aws/credentials

```
The scripts are using the standard aws profile setup, this way you have lots of different account and not have to be play with your creds file.

Example creds file:

```
[profile somecompany-dev]
region = eu-west-1
aws_access_key_id = xxxxxxxxxx
aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxx
aws_session_token = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
aws_security_token = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

[profile somecompany-prod]
region = eu-west-1
aws_access_key_id = yyyyyyyyyyyy
aws_secret_access_key = yyyyyyyyyyyyyyyyyyyyyyyy
aws_session_token = yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
aws_security_token = yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
```


# License

Licensed under the MIT license, see the separate LICENSE file.
