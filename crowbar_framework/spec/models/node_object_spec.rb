#
# Copyright 2011-2013, Dell
# Copyright 2013-2014, SUSE LINUX Products GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe NodeObject do
  describe "finders" do
    describe "interface" do
      [
        :all,
        :find,
        :find_all_nodes,
        :find_nodes_by_name,
        :find_node_by_alias,
        :find_node_by_public_name,
        :find_node_by_name,
        :find_node_by_name_or_alias,
      ].each do |method|
        it "responds to #{method}" do
          NodeObject.should respond_to(method)
        end
      end
    end

    describe "all" do
      it "returns all nodes" do
        nodes = NodeObject.all
        nodes.should_not be_empty
        nodes.all? { |n| n.is_a?(NodeObject) }.should be true
      end
    end

    describe "find_nodes_by_name" do
      it "returns nodes with a given name only" do
        nodes = NodeObject.find_nodes_by_name("testing.crowbar.com")
        nodes.should_not be_empty
        nodes.all? { |n| n.name =~ /testing/ }.should be true
      end
    end

    describe "find_node_by_name" do
      it "returns nodes matching name" do
        node = NodeObject.find_node_by_name("testing")
        node.should_not be_nil
        node.name.should =~ /testing/
      end
    end

    describe "find_node_by_alias" do
      it "returns nodes matching alias" do
        node = NodeObject.find_node_by_alias("testing")
        node.should_not be_nil
        node.alias.should == "testing"
      end
    end
  end

  describe "license_key" do
    describe "assignment" do
      let(:node) { NodeObject.find_node_by_name("testing") }
      let(:key) { "a key" }

      it "sets the key if the platform requires one" do
        CrowbarService.stubs(:require_license_key?).returns(true)
        node.license_key = key
        node.license_key.should == key
      end

      it "leaves it blank if platform does not need a key" do
        CrowbarService.stubs(:require_license_key?).returns(false)
        node.license_key = key
        node.license_key.should be_blank
      end
    end
  end
end
