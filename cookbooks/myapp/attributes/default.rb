#
# Cookbook Name:: jetty
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# touched

default["UAT"]["myapp"]["base_port"] = 8080
default["UAT"]["myapp"]["base_ssl_port"] = 8443

default["DEV"]["myapp"]["base_port"] = 8079
default["DEV"]["myapp"]["base_ssl_port"] = 8443

default["myapp"]["message"] = "hello world"
default["myapp"]["java_options"] = "-Xmx128M -Djava.awt.headless=true"
default["myapp"]["role_sub_dir"] = "myapp"
default["myapp"]["user"] = "vr"
default["myapp"]["group"] = "vr"
