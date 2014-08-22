require 'spec_helper'

describe MenuHelper do
  context 'Menu' do
    it 'must start with home menu items if mxit request?' do
      helper.menu_items.should include(['Home', root_path, id: 'home'])
    end

    context 'grouped_menu_items' do
      it 'returns 2 links in separate items if they are longer 20 chars' do
        new_game_item = ['new game', '/p', id: 'new_game']
        buy_item = ['buy asdasdasdasdasdasd', '/q', id: 'buy']
        helper.menu_item(*new_game_item)
        helper.menu_item(*buy_item)
        helper.grouped_menu_items.should include([buy_item])
      end
    end
  end
end
