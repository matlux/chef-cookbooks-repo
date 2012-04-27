pocketknife and Chef for Apps Repo Tutorial
===========================================

 This is a Chef Cookbook repo that containts very simple examples of an application deployment with [pocketknife](https://github.com/matlux/pocketknife) and Chef-solo, powered by [Opscode Chef](http://www.opscode.com/chef/).

This repo can also be used with Chef-solo on its own.

This tutorial expects you to install the 'matlux' version of the Pocketknife tool to work. Appart from some aspects, most of the following can easily be used with the original version of the Pocketknife.

Pre-requisites
--------------

Install the software on the machine you'll be running `pocketknife` on, this is a computer that will deploy configurations to other computers:

* Install Ruby: http://www.ruby-lang.org/
* Install Rubygems: http://rubygems.org/
* Install chef-solo: http://wiki.opscode.com/display/chef/Installing+Chef+Client+and+Chef+Solo

Install Pocketknife ('matlux' version)
--------------------------------------

* Install Ruby: http://www.ruby-lang.org/
* Install Rubygems: http://rubygems.org/
* Install `archive-tar-minitar`: `gem install archive-tar-minitar` - pocketknife dependency.
* Install `rye`: `gem install rye` - pocketknife dependency.
* `cd /path/of/your/choice`
* `git clone git://github.com/matlux/pocketknife.git`
* `export PATH=/path/of/your/choice/pocketknife:$PATH` - add pocketknife to your PATH

Clone 'matlux' Cookbooks Repository
-----------------------------------

* `cd /path/of/your/choice`
* `git clone git://github.com/matlux/pocketknife.git`
* `cd pocketknifeRepo`

1st Cookbook: the classic "Helloworld"
------------------------------------

All you need to do is to define a new node using the `chef` JSON syntax for [runlist](http://wiki.opscode.com/display/chef/Setting+the+run_list+in+JSON+during+run+time) and [attributes](http://wiki.opscode.com/display/chef/Attributes). For example, to define a node with the hostname `henrietta.swa.gov.it` create the `nodes/henrietta.swa.gov.it.json` file, and add the contents below so it uses the `myapp1` role and overrides its attributes to specify how many slots are available (not yet implemented in reality):

    {
      "run_list": [
        "role[uat]",
        "recipe[helloworld]"
      ],
      "myapp": {
          "instanceNumber": 3
        }
    }

Call the file `henrietta.swa.gov.it` inside the `nodes` directory` or your version of a [hostname.domain].
    

Operations on remote nodes will be performed using SSH. You should consider [configuring ssh-agent](http://mah.everybody.org/docs/ssh) so you don't have to keep typing in your passwords.

Finally, deploy your configuration to the remote machine and see the results. For example, lets deploy the above configuration to the `henrietta.swa.gov.it` host, which can be abbreviated as `henrietta` when calling `pocketknife`:

    pocketknife henrietta

When deploying a configuration to a node, `pocketknife` will check whether Chef and its dependencies are installed. It something is missing, it will prompt you for whether you'd like to have it install them automatically.

To always install Chef and its dependencies when they're needed, without prompts, use the `-i` option, e.g. `pocketknife -i henrietta`. Or to never install Chef and its dependencies, use the `-I` option, which will cause the program to quit with an error rather than prompting if Chef or its dependencies aren't installed.

If something goes wrong while deploying the configuration, you can display verbose logging from `pocketknife` and Chef by using the `-v` option. For example, deploy the configuration to `henrietta` with verbose logging:

    pocketknife -v henrietta

Once the program has executed you can verify that it has executed correctly by log into the remote computer and run the application as follow:

    ssh henrietta.swa.gov.it
    cd ~/chefwork/helloworld/bin
    ./start.sh

    > Helloworld

There you are you're application is deployed and behaving correctly.

Setup a user
------------

This version of pocketknife does not require to run chef-solo as root. You can run it as any user you like as long as its able to carry out what needs to be done in the recipe. This is ideal in a deployment scenario when the application developers often don't have root acces on the boxes they need to deploy onto.

Optional arguments:

    --user myuser

    --password passwordFile


password file format:

    myuser: mypassword

2nd Cookbook: an elastic 'myapp1' application
------------------------------------------

This application is elastic, it request 2 instances ("instanceReq") per node and assumes 3 slots are available ("instanceNumber").

You will see a myapp1 role is already defined inside the `roles` directory that describe common behavior and attributes of the "myapp" component using JSON syntax using [chef's documentation](http://wiki.opscode.com/display/chef/Roles#Roles-AsJSON).

Override cookbooks in the `site-cookbooks` directory. This has the same structure as `cookbooks`, but any files you put here will override the contents of `cookbooks`. This is useful for storing the original code of a third-party cookbook in `cookbooks` and putting your customizations in `site-cookbooks`.

Define roles in the `roles` directory that describe common behavior and attributes of your computers using JSON syntax using [chef's documentation](http://wiki.opscode.com/display/chef/Roles#Roles-AsJSON). For example, define a role called `myapp1` by creating a file called `roles/myapp1.json` with this content:

    {
      "name": "myapp1",
      "chef_type": "role",
      "json_class": "Chef::Role",
      "run_list": [
        "recipe[myapp]"
      ],
      "override_attributes": {
        "myapp": {
          "instanceReq": 2
        }
      }
    }

All you need to do is to define a new node using the `chef` JSON syntax for [runlist](http://wiki.opscode.com/display/chef/Setting+the+run_list+in+JSON+during+run+time) and [attributes](http://wiki.opscode.com/display/chef/Attributes). For example, to define a node with the hostname `henrietta.swa.gov.it` create the `nodes/henrietta.swa.gov.it.json` file, and add the contents below so it uses the `myapp1` role and overrides its attributes to specify how many slots are available (not yet implemented in reality):

    {
      "run_list": [
        "role[uat]",
        "role[myapp1]"
      ],
      "myapp": {
          "instanceNumber": 3
        }
    }

    Call the file `henrietta.swa.gov.it` or your version of a [hostname.domain]. You will find an example in this project called `nodes/vr01.local.json` as an example.
    
What is interesting to understand is that `myapp1` is a top level component that you are interested to install on a machine. `myapp1` happens to use a commonly used sub-component called `myapp` which is a recipe. `myapp` has two sort of `attributes` (i.e. variables): those that are always true (closely bound to the `myapp` recipe) and those that are environmnet specific. Let's have a look at the chef-cookbooks-repo/cookbooks/myapp/attributes/default.rb file.


This is specific to UAT:

    default["UAT"]["myapp"]["base_port"] = 8080
    default["UAT"]["myapp"]["base_ssl_port"] = 8443

This is specific to DEV:

    default["DEV"]["myapp"]["base_port"] = 8079
    default["DEV"]["myapp"]["base_ssl_port"] = 8443

This is generic to any environment:

    default["myapp"]["message"] = "hello world"
    default["myapp"]["java_options"] = "-Xmx128M -Djava.awt.headless=true"
    default["myapp"]["role_sub_dir"] = "myapp"
    default["myapp"]["user"] = "vr"
    default["myapp"]["group"] = "vr"

If a node uses the role `uat` it means the `myapp` recipe will use the `UAT` variables so environment and recipe are orthogonal to one another. It is very good to recipe re-use across environments. The benefit of this pattern is that one tested on a couple of environments it is easy to add an additional environment. Only the set of environment specific variable needs to be filled in to enable a new environment.

Finally, deploy your configuration to the remote machine and see the results. For example, lets deploy the above configuration to the `henrietta2.swa.gov.it` host, which can be abbreviated as `henrietta` when calling `pocketknife`:

    pocketknife vr02

If you really need to debug on the remote machine, you may be interested about some of the commands and paths:

* `chef-solo-apply` (/tmp/usr/local/sbin/chef-solo-apply) will apply the configuration to the machine. You can specify `-l debug` to make it more verbose. Run it with `-h` for help.
* `csa` (/tmp/usr/local/sbin/csa) is a shortcut for `chef-solo-apply` and accepts the same arguments.
* `/tmp/etc/chef/solo.rb` contains the `chef-solo` configuration settings.
* `/tmp/etc/chef/node.json` contains the node-specific configuration, like the `runlist` and attributes.
* `/tmp/var/local/pocketknife` contains the `cookbooks`, `site-cookbooks` and `roles` describing your configuration.

Contributing
------------

This software is published as open source at https://github.com/matlux/pocketknife

You can view and file issues for this software at https://github.com/matlux/pocketknife/issues

If you'd like to contribute code or documentation:

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
* Submit a pull request using github, this makes it easy for me to incorporate your code.

Copyright
---------

Copyright (c) 2012 Mathieu Gauthron. See `LICENSE.txt` for further details.
