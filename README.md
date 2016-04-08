# awsstubs

This repository demonstrates how to get started with AWS clint stubs for the AWS SDK for Ruby, version ~> 2. The lib code is functional but is intended only as support for the RSpec tests that demonstrate the AWS client stubs features.

## Features

The code demonstrates how to:

* create stubbed response data using both Ruby hashes and native AWS structs
* use the `Aws.config` to globally stub the classes and methods specified
* use the `stub_responses` argument to construct stub AWS client instances
* leverage both stubbing strategies

## Installation

You can run the code locally (provided you install the pre-requisites on your own), or you can use the Vagrantfile provided. Using Vagrant and a Vagrantfile is beyond the scope of this repository and can be [found here](https://www.vagrantup.com/docs/getting-started).

`vagrant up` - will create a VM with all prerequisite installations. (Remember, the code synch is to the guest's /vagrant folder.)

In order to run the sample code, use bundler to install the dependencies. From the root of the repository folder:

`bundle install`

## Usage

The sample code is essentially RSpec tests. The AWS APIs referenced and used are all stubbed, so even if you have provided credentials, none of this code will access or affect your AWS account in any way. From the root of the repository folder:

`rake` - to use the output format specified in the Rakefile

`rspec spec -f {format option}` - to use whatever format you like

If you want to edit the specs to test-drive them more thoroughly, and you're keen on instant gratification, use the following command to monitor your changes and automatically re-run the specs. From the root of the repository folder:

`bundle exec guard`

When either (1) the spec file or (2) the underlying class file are saved, this will trigger a re-run of the tests according to the Guardfile.

## License

[MIT](https://github.com/stelligent/aws-stubs-intro/blob/master/LICENSE.md)
