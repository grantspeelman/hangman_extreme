require 'spec_helper'

describe ApplicationHelper do
  context 'smart_link_to' do
    it 'should optimize for mxit if mxit request' do
      helper.smart_link_to('new game', '/hello', id: 'new_game').should ==
          link_to('new', '/hello', id: 'new_game') + ' game'
    end
  end
end
