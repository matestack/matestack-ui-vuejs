require 'rails_vue_js_spec_helper'
include VueJsSpecUtils

describe "Onclick Component", type: :feature, js: true, aggregate_failures: true do

  context 'when given a single event' do
    context 'as a symbol' do
      it "emits event" do
        class ExamplePage < Matestack::Ui::Page
          def response
            onclick emit: :show_message do
              button 'click me'
            end
            toggle show_on: 'show_message' do
              plain "some message"
            end
          end
        end
    
        visit "/example"
        within 'body' do        
          expect(page).not_to have_content("some message")
      
          click_button 'click me'
  
          expect(page).to have_content("some message")
        end
      end
    end

    context 'as a string' do
      it "emits event" do
        class ExamplePage < Matestack::Ui::Page
          def response
            onclick emit: 'show_message' do
              button 'click me'
            end
            toggle show_on: 'show_message' do
              plain "some message"
            end
          end
        end
    
        visit "/example"
        within 'body' do        
          expect(page).not_to have_content("some message")
      
          click_button 'click me'
  
          expect(page).to have_content("some message")
        end
      end
    end
  
    context 'when provided data' do
      it "emits event with provided data" do
        class ExamplePage < Matestack::Ui::Page
          def response
            onclick emit: 'show_message', data: "some static data" do
              button 'click me'
            end
            toggle show_on: 'show_message' do
              plain "some message"
              br
              plain "{{vc.event.data}}"
            end
          end
        end
    
        visit "/example"
        within 'body' do          
          expect(page).not_to have_content("some message")

          click_button 'click me'

          expect(page).to have_content("some message")
          expect(page).to have_content("some static data")
        end
      end
    end
  end

  context 'when given multiple comma-separated events' do
    it "emits all events" do
      class ExamplePage < Matestack::Ui::Page
        def response
          onclick emit: 'show_message, show_alert' do
            button 'click me'
          end
          toggle show_on: 'show_message' do
            plain "some message"
          end
          toggle show_on: 'show_alert' do
            plain "some alert"
          end
        end
      end
  
      visit "/example"
      within 'body' do        
        expect(page).not_to have_content("some message")
        expect(page).not_to have_content("some alert")
  
        click_button 'click me'

        expect(page).to have_content("some message")
        expect(page).to have_content("some alert")
      end
    end

    context 'when provided data' do
      it "emits all events with provided data" do
        class ExamplePage < Matestack::Ui::Page
          def response
            onclick emit: 'show_message, show_alert', data: "some static data" do
              button 'click me'
            end
            toggle show_on: 'show_message' do
              plain "some message"
              br
              plain "{{vc.event.data}}"
            end
            toggle show_on: 'show_alert' do
              plain "some alert"
              br
              plain "{{vc.event.data}}"
            end
          end
        end
    
        visit "/example"

        within 'body' do          
          expect(page).not_to have_content("some message")
          expect(page).not_to have_content("some alert")
  
          click_button 'click me'

          expect(page).to have_content("some message")
          expect(page).to have_content("some alert")
          expect(page).to have_content("some static data").twice
        end
      end
    end
    
  end
  
end
