require 'spec_helper'

describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('collectd') do
  it { should be_installed }
end

describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('collectd') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/httpd/conf.d/collectd.conf') do
  it { should exist }
end

describe port(80) do
  it { should be_listening }
end
