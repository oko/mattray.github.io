---
title: Upgrading InSpec Iggy for Terraform 0.12
---

[InSpec Iggy](https://github.com/mattray/inspec-iggy) is an [InSpec](https://www.inspec.io/) plugin for generating compliance controls and profiles from [Terraform](https://www.terraform.io/) `.tfstate` files and [AWS CloudFormation](https://aws.amazon.com/cloudformation/) templates. I originally wrote InSpec-Iggy with Terraform 0.11, but 0.12 has been out since [May of 2019]((https://www.hashicorp.com/blog/announcing-terraform-0-12/)) and makes a number of changes to the underlying `.tfstate` files, so I figured I'd document the upgrade process as I also wrote a corresponding [SysAdvent 2019](https://sysadvent.blogspot.com/) post.

# InSpec-Iggy

InSpec-Iggy (InSpec Generate -> "IG" -> "Iggy") generates InSpec controls by mapping Terraform and CloudFormation resources to InSpec resources and exports a profile that may be used from the `inspec` CLI or uploaded to [Chef Automate](https://automate.chef.io/).

# Taking Inventory

Version 0.6.0 was released in July of 2019 adding support for the GCP platform, external resource packs and negative testing. The [CHANGELOG](https://github.com/mattray/inspec-iggy/blob/master/CHANGELOG.md) tracks each release as well as the backlog of bugs and ideas for new features that need to be addressed. To start the upgrade process I created a new `0.7.0` branch and started following the [Development and Testing](https://github.com/mattray/inspec-iggy#development-and-testing) instructions to use a development version of the plugin and run the local tests.

## Initial Cleanups

The first step was to ensure that the tests were all passing, which they did.

    $ bundle exec rake test

Unfortunately the lint tests failed spectacularly and had been broken for awhile.

    $ bundle exec rake lint

To fix this I needed to upgrade the existing dependencies and sync up with the latest updates in the [InSpec codebase](https://github.com/inspec/inspec). InSpec recently updated to use [ChefStyle](https://github.com/chef/chefstyle) for formatting their code to use the same style as Chef. This resulted in a [rather large changeset](https://github.com/mattray/inspec-iggy/commit/29de194ac07b85f75eba6bf9b982f5f804779cdb), but since the tests were already working this was easy to test for regressions (there were none).

## Upgrading Testing with InSpec

Unit tests are useful, but I have a strong preference for integration testing especially since this is a plugin for another tool that moves quickly. I decided the best approach would be to use `inspec` to test my InSpec plugin's behavior. I wasn't aware of any techniques for using InSpec within a Rake task, so I fumbled around a bit to get this working:

```ruby
  require "tmpdir"
  desc "Run InSpec integration tests for check for interface changes"
  Rake::TestTask.new(:inspec) do |task|
    task.libs << "test"
    tmp_dir = Dir.mktmpdir
    sh("bundle exec gem build inspec-iggy.gemspec")
    sh("bundle exec inspec plugin install inspec-iggy-*.gem  --chef-license=accept")
    sh("bundle exec inspec exec test/inspec --reporter=progress --input tmp_dir='#{tmp_dir}'")
    FileUtils.remove_dir(tmp_dir)
    task.warning = false
  end
```

The usage of `tmpdir` is so that I can parse the `.tfstate` and `json` files in the [test/fixtures/](test/fixtures/) directory and validate that the commands are working as expected with actual output. The building of the inspec-iggy gem and the installation of the gem are to ensure that inspec-iggy is working in clean test environments (ie. [TravisCI](https://travis-ci.org/mattray/inspec-iggy/)). I've added a new [test/inspec](test/inspec/) profile for testing the various permutations of [inspec](), [inspec iggy](), [inspec cloudformation](), and [inspec terraform]().

# Upgrading Terraform

Iggy had been originally written and tested with Terraform 0.11, so it was time to install 0.12 and start looking through the changes. First up I figured I'd update to the latest version of the [AWS provider for Terraform](https://github.com/terraform-providers/terraform-provider-aws) and evaluate kicking off the [Basic Two-Tier AWS Architecture example](https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/two-tier) to see how the code behaved.

    cd examples/two-tier/
    okta_aws -a
    terraform init

From here I updated my `terraform.tfvars` with the following

    aws_region = "us-west-2"
    key_name = "mattray-terraform"
    public_key_path = "/Users/mattray/.ssh/id_rsa.pub"

I found that `ap-southeast-2` had some issues looking up the AMIs, so rather than debug Terraform I chose to switch to `us-west-2` which is better supported. The `key_name` needed to be unused and the `public_key_path` needed to refer to an existing public key??? `terraform apply` failed to connect via SSH (DEBUG THIS) but it did generate a `terraform.tfstate` file that could be used for testing.

## First Run:

```
$ bundle exec inspec terraform generate --resourcepath ~/ws/inspec-aws --platform aws -t terraform.tfstate --name aws-01
bundler: failed to load command: inspec (/Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/bin/inspec)
NoMethodError: undefined method `each' for nil:NilClass
  /Users/mattray/ws/inspec-iggy/lib/inspec-iggy/terraform/generate.rb:33:in `parse_resources'
  /Users/mattray/ws/inspec-iggy/lib/inspec-iggy/terraform/generate.rb:20:in `parse_generate'
  /Users/mattray/ws/inspec-iggy/lib/inspec-iggy/terraform/cli_command.rb:81:in `generate'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/thor-0.20.3/lib/thor/command.rb:27:in `run'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/thor-0.20.3/lib/thor/invocation.rb:126:in `invoke_command'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/thor-0.20.3/lib/thor.rb:387:in `dispatch'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/thor-0.20.3/lib/thor/invocation.rb:115:in `invoke'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/thor-0.20.3/lib/thor.rb:238:in `block in subcommand'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/thor-0.20.3/lib/thor/command.rb:27:in `run'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/thor-0.20.3/lib/thor/invocation.rb:126:in `invoke_command'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/thor-0.20.3/lib/thor.rb:387:in `dispatch'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/thor-0.20.3/lib/thor/base.rb:466:in `start'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/inspec-4.18.39/lib/inspec/base_cli.rb:33:in `start'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/gems/inspec-bin-4.18.39/bin/inspec:11:in `<top (required)>'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/bin/inspec:23:in `load'
  /Users/mattray/ws/inspec-iggy/.bundle/ruby/2.6.0/bin/inspec:23:in `<top (required)>'
```
This didn't start promisingly, but I figured that the internal .tfstate file format probably moved around a bit. First, I dropped a pry debug statement at `lib/inspec-iggy/terraform/generate.rb:33:in parse_resources`

      require 'pry'
      binding.pry

Rerunning the command dropped me into the Pry debugger. It looks like `modules` is no longer a top-level key for the `.tfstate` file and there are now `instances` within the resources, which gave me my [first patch](https://github.com/mattray/inspec-iggy/compare/0bbdae4f8431...678f3bd22e34).


# Azure

# GCP

# cinc-audit support


, I ensured that everything was currently working with the latest InSpec (4.18.39) from the [Chef Workstation 0.12.20](https://downloads.chef.io/chef-workstation/) with the existing tests.
