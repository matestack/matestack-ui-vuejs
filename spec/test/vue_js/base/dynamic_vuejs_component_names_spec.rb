require 'rails_vue_js_spec_helper'
include VueJsSpecUtils

describe "Component", type: :feature, js: true do

  before :all do
    module Pages end
    class ComponentTestController < ActionController::Base
      include Matestack::Ui::Core::Helper
      layout "application_vue_js"
      matestack_layout VueJsLayout

      def my_action
        render Pages::ExamplePage
      end
    end

    Rails.application.routes.append do
      scope "component_dynamic_vuejs_component_name_spec" do
        get '/component_test', to: 'component_test#my_action', as: 'dynamic_vue_js_component_test_action'
      end
    end
    Rails.application.reload_routes!
  end

  describe "dynamic components are associated" do

    it "with a vue js component with a name derived from the component class name" do
      # the vue.js component 'my-test-component' is defined in `spec/dummy/assets/javascripts/test/components.js`
      class MyTestComponent < Matestack::Ui::VueJsComponent
        vue_name 'my-test-component'

        def response
          div id: "my-component" do
            plain "dynamic component"
            plain "{{vc.dynamic_value}}"
          end
        end

        register_self_as(:test_component)
      end


      class Pages::ExamplePage < Matestack::Ui::Page
        def response
          div id: "div-on-page" do
            test_component
          end
        end
      end

      visit "component_dynamic_vuejs_component_name_spec/component_test"
      expect(page).to have_xpath('//div[@id="div-on-page"]/matestack-component-template/div[@id="my-component" and contains(.,"dynamic component")]')
      expect(page).to have_xpath('//div[@id="div-on-page"]/matestack-component-template/div[@id="my-component" and contains(.,"foo")]')
      sleep 0.5
      expect(page).to have_xpath('//div[@id="div-on-page"]/matestack-component-template/div[@id="my-component" and contains(.,"dynamic component")]')
      expect(page).to have_xpath('//div[@id="div-on-page"]/matestack-component-template/div[@id="my-component" and contains(.,"my-test-component: bar")]')
    end

    it "with a vue js component named manually" do
      # the vue.js component 'test-component' is defined in `spec/dummy/assets/javascripts/test/components.js`
      class MyTestComponent < Matestack::Ui::VueJsComponent
        vue_name "test-component"

        def response
          div id: "my-component" do
            plain "dynamic component"
            plain "{{vc.dynamic_value}}"
          end
        end

        register_self_as(:test_component)
      end


      class Pages::ExamplePage < Matestack::Ui::Page
        def response
          div id: "div-on-page" do
            test_component
          end
        end
      end

      visit "component_dynamic_vuejs_component_name_spec/component_test"
      expect(page).to have_xpath('//div[@id="div-on-page"]/matestack-component-template/div[@id="my-component" and contains(.,"dynamic component")]')
      expect(page).to have_xpath('//div[@id="div-on-page"]/matestack-component-template/div[@id="my-component" and contains(.,"foo")]')
      sleep 0.5
      expect(page).to have_xpath('//div[@id="div-on-page"]/matestack-component-template/div[@id="my-component" and contains(.,"dynamic component")]')
      expect(page).to have_xpath('//div[@id="div-on-page"]/matestack-component-template/div[@id="my-component" and contains(.,"test-component: bar")]')
    end
  end

end
