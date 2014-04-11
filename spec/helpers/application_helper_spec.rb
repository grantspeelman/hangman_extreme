require 'spec_helper'

describe ApplicationHelper do
  context 'smart_link_to' do
    it 'should work like wiselink link' do
      helper.stub(:mxit_request?).and_return(false)
      helper.smart_link_to('new game', '/test', id: 'new_game').should ==
          link_to('new game', '/test', id: 'new_game', data: {push: true})
    end

    it 'should optimize for mxit if mxit request' do
      helper.stub(:mxit_request?).and_return(true)
      helper.smart_link_to('new game', '/hello', id: 'new_game').should ==
          link_to('new', '/hello', id: 'new_game') + ' game'
    end
  end
end
