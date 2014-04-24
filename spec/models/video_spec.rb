require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  # 1. Where you cannot find a single video
  
  # 2. Where you can find one
  # 3. Where you can find multiple videos.
end
