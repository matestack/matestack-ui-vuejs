require 'rails_vue_js_spec_helper'
include VueJsSpecUtils

describe "Toggle Component", type: :feature, js: true, aggregate_failures: true do

  context 'given single or multiple events' do
    it 'shows on any of the events' do
      class ExamplePage < Matestack::Ui::Page
        def response
          toggle show_on: "my_event", id: 'toggle-div' do
            div id: "my-div" do
              plain "#{DateTime.now.strftime('%Q')}"
            end
          end
          toggle show_on: "multi_event_1, multi_event_2", id: 'toggle-second-div' do
            div id: "my-second-div" do
              plain "#{DateTime.now.strftime('%Q')}"
            end
          end
        end
      end
  
      visit "/example"
      expect(page).not_to have_selector "#my-div"
      expect(page).not_to have_selector "#my-second-div"
  
      page.execute_script('MatestackUiVueJs.eventHub.$emit("my_event")')
      expect(page).to have_selector "#my-div"
      expect(page).not_to have_selector "#my-second-div"
  
      page.execute_script('MatestackUiVueJs.eventHub.$emit("multi_event_2")')
      expect(page).to have_selector "#my-div"
      expect(page).to have_selector "#my-second-div"
  
      visit "/example"
      expect(page).not_to have_selector "#my-second-div"
  
      page.execute_script('MatestackUiVueJs.eventHub.$emit("multi_event_1")')
      expect(page).to have_selector "#my-second-div"
    end
    
    it "hides on any of the events" do
      class ExamplePage < Matestack::Ui::Page
        def response
          toggle hide_on: "my_event", id: 'toggle-div' do
            div id: "my-div" do
              plain "#{DateTime.now.strftime('%Q')}"
            end
          end
          toggle hide_on: "multi_event_1, multi_event_2", id: 'toggle-second-div' do
            div id: "my-second-div" do
              plain "#{DateTime.now.strftime('%Q')}"
            end
          end
        end
      end
  
      visit "/example"
      expect(page).to have_selector "#my-div"
      expect(page).to have_selector "#my-second-div"
  
      page.execute_script('MatestackUiVueJs.eventHub.$emit("my_event")')
      expect(page).not_to have_selector "#my-div"
      expect(page).to have_selector "#my-second-div"
  
      page.execute_script('MatestackUiVueJs.eventHub.$emit("multi_event_2")')
      expect(page).not_to have_selector "#my-div"
      expect(page).not_to have_selector "#my-second-div"
  
      visit "/example"
      expect(page).to have_selector "#my-second-div"
  
      page.execute_script('MatestackUiVueJs.eventHub.$emit("multi_event_1")')
      expect(page).not_to have_selector "#my-second-div"
    end
  end

  context 'on a show_on/hide_on combination' do
    it "isn't initially shown by default" do
      class ExamplePage < Matestack::Ui::Page
        def response
          toggle show_on: "my_show_event", hide_on: "my_hide_event", id: 'toggle-div' do
            div id: "my-div" do
              plain "#{DateTime.now.strftime('%Q')}"
            end
          end
        end
      end
  
      visit "/example"
      expect(page).not_to have_selector "#my-div"
  
      page.execute_script('MatestackUiVueJs.eventHub.$emit("my_show_event")')
      expect(page).to have_selector "#my-div"
  
      page.execute_script('MatestackUiVueJs.eventHub.$emit("my_hide_event")')
      expect(page).not_to have_selector "#my-div"
    end

    context 'with init_show configured' do
      it 'is shown initially' do
        class ExamplePage < Matestack::Ui::Page
          def response
            toggle show_on: "my_show_event", hide_on: "my_hide_event", init_show: true, id: 'toggle-div' do
              div id: "my-div" do
                plain "#{DateTime.now.strftime('%Q')}"
              end
            end
          end
        end
    
        visit "/example"
        expect(page).to have_selector "#my-div"
    
        page.execute_script('MatestackUiVueJs.eventHub.$emit("my_hide_event")')
        expect(page).not_to have_selector "#my-div"
    
        page.execute_script('MatestackUiVueJs.eventHub.$emit("my_show_event")')
        expect(page).to have_selector "#my-div"
      end
    end
  end

  context 'provided a show_on/hide_after combination' do
    it 'hides after the show_on event in the specified number of milliseconds' do
      class ExamplePage < Matestack::Ui::Page
        def response
          toggle show_on: "my_event", hide_after: 1000, id: 'toggle-div' do
            div id: "my-div" do
              plain "#{DateTime.now.strftime('%Q')}"
            end
          end
        end
      end
  
      visit "/example"
      expect(page).not_to have_selector "#my-div"
  
      page.execute_script('MatestackUiVueJs.eventHub.$emit("my_event")')
      expect(page).to have_selector "#my-div"
  
      sleep 1
      expect(page).not_to have_selector "#my-div"
    end
  end

  context 'when the event is emitted with a payload' do
    context 'and the component configured show_on' do
      it 'shows on the event and has access to the payload' do
        class ExamplePage < Matestack::Ui::Page
          def response
            toggle show_on: "my_event", id: 'toggle-div' do
              div id: "my-div" do
                plain "{{vc.event.data.message}}"
              end
            end
          end
        end
    
        visit "/example"
        expect(page).not_to have_content "test!"
    
        page.execute_script('MatestackUiVueJs.eventHub.$emit("my_event", { message: "test!" })')
        expect(page).to have_content "test!"
      end
    end
  end

end
