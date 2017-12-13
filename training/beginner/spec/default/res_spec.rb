require 'spec_helper'

describe file('/tmp/test1') do
  it { should exist }
  it { should be_mode 644 }
  its(:content) { should match /test1/ }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/tmp/dir1') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/tmp/dir1/test2') do
  it { should be_symlink }
  it { should be_linked_to '/tmp/test1' }
end
