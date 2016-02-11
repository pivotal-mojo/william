require 'rails_helper'

describe ApplicationHelper do
  describe '.status_class' do
    it 'is full when greater than or equal to 80%' do
      expect(helper.status_class(4, 5)).to eq('full')
    end

    it 'is warning when less than 80% and greater than or equal to 50%' do
      expect(helper.status_class(799, 1000)).to eq('warning')
      expect(helper.status_class(1, 2)).to eq('warning')
    end

    it 'is critical when less than 50% and greater than 0%' do
      expect(helper.status_class(499, 1000)).to eq('critical')
      expect(helper.status_class(1, 1000)).to eq('critical')
    end

    it 'is empty when 0%' do
      expect(helper.status_class(0, 1)).to eq('empty')
    end
  end
end