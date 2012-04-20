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

* Install `pocketknife`: `gem install pocketknife` - this will install the original pocketknife from Igal (and more importantly) all its dependencies.
* cd /path/of/your/choice/
* Clone my repo: git clone git://github.com/matlux/pocketknife.git
* cd ..
* mv pocketknife pocketknife_alt

make sure in the rest of this tutorial you call pocketknife from the github clone rather than the pocketknife installed on gem. That's why you need to call the pocketknife with a canonical path to the git repo:

    /path/of/your/choice/pocketknife_alt/bin/pocketknife

Clone 'matlux' Cookbooks Repository
-----------------------------------

* `cd /path/of/your/choice`
* `git clone git://github.com/matlux/pocketknife.git`
* `cd ..`
* `mv pocketknife pocketknife_alt`
* `cd /path/of/your/choice/pocketknifeRepo`

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

    Call the file `henrietta.swa.gov.it` or your version of a [hostname.domain]. You can use `nodes/vr01.local.json` as an example.
    

Operations on remote nodes will be performed using SSH. You should consider [configuring ssh-agent](http://mah.everybody.org/docs/ssh) so you don't have to keep typing in your passwords.

Finally, deploy your configuration to the remote machine and see the results. For example, lets deploy the above configuration to the `henrietta.swa.gov.it` host, which can be abbreviated as `henrietta` when calling `pocketknife`:

    /path/of/your/choice/pocketknife_alt/bin/pocketknife henrietta

When deploying a configuration to a node, `pocketknife` will check whether Chef and its dependencies are installed. It something is missing, it will prompt you for whether you'd like to have it install them automatically.

To always install Chef and its dependencies when they're needed, without prompts, use the `-i` option, e.g. `pocketknife -i henrietta`. Or to never install Chef and its dependencies, use the `-I` option, which will cause the program to quit with an error rather than prompting if Chef or its dependencies aren't installed.

If something goes wrong while deploying the configuration, you can display verbose logging from `pocketknife` and Chef by using the `-v` option. For example, deploy the configuration to `henrietta` with verbose logging:

    /path/of/your/choice/pocketknife_alt/bin/pocketknife -v henrietta


    

2nd Cookbook: an elastic 'myapp1' application
------------------------------------------

This application is elastic, it request 2 instances ("instanceReq") per node and assumes 3 slots are available ("instanceNumber").

You will see a myapp1 role is already defined inside the `roles` directory that describe common behavior and attributes of the "myapp" component using JSON syntax using [chef's documentation](http://wiki.opscode.com/display/chef/Roles#Roles-AsJSON). For example, define a role called `ntp_client` by creating a file called `roles/ntp_client.json` with this content:

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

    Call the file `henrietta.swa.gov.it` or your version of a [hostname.domain]. You can use `nodes/vr01.local.json` as an example.
    
 Follow the same procedure as in the 'helloworld' example to test it.

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
