require 'spec_helper'

describe Picture, type: :model do
  it { is_expected.to have_many(:comments).dependent :destroy }
  it { is_expected.to belong_to :user }
end
