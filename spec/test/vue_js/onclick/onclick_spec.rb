require 'rails_vue_js_spec_helper'
include VueJsSpecUtils

describe "Onclick Component", type: :feature, js: true do

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
    expect(page).not_to have_content("some message")

    click_button 'click me'
    expect(page).to have_content("some message")
  end

  it "emits event with data" do
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
    expect(page).not_to have_content("some message")

    click_button 'click me'
    expect(page).to have_content("some message")
    expect(page).to have_content("some static data")
  end

  it "emits event with public_context used for isolated component rendering" do
    class SomeIsolatedComponentTriggeredByOnclick < Matestack::Ui::IsolatedComponent

      def response
        div class: "public-context-set-by-onclick" do
          plain "ID set by onclick: "
          plain public_context.id
        end
      end

      def authorized?
        true
      end

      register_self_as(:some_isolated_component_triggered_by_onclick)
    end
    class ExamplePage < Matestack::Ui::Page
      def response
        onclick emit: 'replace_isolated_component_content', public_context: { id: 42 } do
          button 'load 42 in isolated component'
        end
        some_isolated_component_triggered_by_onclick defer: true, replace_on: "replace_isolated_component_content"
      end
    end

    visit "/example"

    within ".public-context-set-by-onclick" do
      expect(page).not_to have_content("ID set by onclick: 42")
    end

    click_button 'load 42 in isolated component'
    
    within ".public-context-set-by-onclick" do
      expect(page).to have_content("ID set by onclick: 42")
    end

  end
end
