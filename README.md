# MSSQL (SQL Server) ODBC AWS Lambda layer

This is a small project for building and deploying the `mssql-odbc` drivers as AWS Lambda layer.
You can leverage this layer to build AWS Lambda python serverless applications to connect with a MSSQL (SQL Server) database.

## Prerequisites

You will need to have the following running on your local environment in order to successfully perform the steps:

- A POSIX compatible shell (e.g. `sh`, `zsh`, `ksh` or `bash`)
- Docker installed
- The `zip` utility installed and available on the `PATH`
- The `aws` CLI installed and available on the `PATH`
- Also, you have set up the `aws` CLI so you can make calls to the target AWS environment

## Usage

You need to perform two steps in order to install this AWS Lambda layer:

1. **Building** _(not required if you just want to use the precompiled `layer.zip` in this repository)_
2. **Deploying**

### Building

You will need to build this AWS Lambda layer by invoking `sh build.sh` or when chmod-ed with the executable flag (like `0750`) simply by invoking `./build.sh`.

This build script will make use of the `lambci/lambda` Docker container so the environment looks almost identical to the AWS Lambda running environment.

After the `build.sh` script finishes, you will end up with a zip archive called: `layer.zip`. This zip archive contains:

- The compiled version of `unixODBC` (with the right paths e.g. `/opt` in place)
- The `msodbcsql17` driver which has been obtained from the official Microsoft YUM repository
- A `odbcinst.ini` file ready for use

### Deploying

The prerequisite for this step is that you have the artifact `layer.zip` ready to be shipped to AWS.

You have basically two options to have this artifact in place:

1. Run the [Build](#Building) yourself
2. Download the precompiled `layer.zip` that has been uploaded to this repository

Also, before running the actual deployment script, you might want to export the environment variables with the AWS environment you want to deploy to. This, for instance, can be done quite easiliy with the [awsume](https://github.com/trek10inc/awsume) script from `trek10inc`.

When you are ready to deploy this AWS Lambda layer, you will need to invoke `sh deploy.sh` or otherwise if the executable flag has been set, simply by invoking `./deploy.sh`.

The deployment script will perform the following:

- Upload the `layer.zip` to AWS
- Create a AWS Lambda layer named `mssql-odbc` and making it compatible for runtime `python3.7`

**Done: you are now able to use the AWS Lambda layer from within your AWS Lambda serverless application / script!**
