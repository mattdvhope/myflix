require 'spec_helper'

describe Invitation do
  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:recipient_email) }
  it { should validate_presence_of(:message) }

  it_behaves_like "tokenable" do # from 'support/shared_examples.rb'
    let(:object) { Fabricate(:invitation) }
  end
end
