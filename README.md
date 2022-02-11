[![Specs](https://github.com/matestack/matestack-ui-vuejs/workflows/specs/badge.svg)](https://github.com/matestack/matestack-ui-vuejs/actions)
[![Discord](https://img.shields.io/discord/771413294136426496.svg)](https://discord.com/invite/c6tQxFG)
[![Gem Version](https://badge.fury.io/rb/matestack-ui-vuejs.svg)](https://badge.fury.io/rb/matestack-ui-vuejs)
[![Docs](https://img.shields.io/badge/docs-matestack-blue.svg)](https://docs.matestack.io)
[![Twitter Follow](https://img.shields.io/twitter/follow/matestack.svg?style=social)](https://twitter.com/matestack)

![matestack logo](./logo.png)

# matestack-ui-vuejs | Vue.js 3 based reactivity system for Rails

Boost your productivity & easily create reactive web UIs in pure Ruby. Easily extend with pure JavaScript if required. No Opal involved.

## About

`matestack-ui-vuejs` ships all you need to build **reactive** UIs in **pure Ruby** orchestrating prebuilt Vue.js components with a simple Ruby DSL.

The prebuilt reactive components built **on top of Vue.js** are covering typical features of a reactive web UI, such as async form submission, dynamic page transitions or async partial UI updates. **No Opal involved**

If required, it can be easily extended with pure JavaScript.

### Why matestack-ui-vuejs?

`matestack-ui-vuejs` was created because modern web app development became more and more complex due to the rise of JavaScript frontend frameworks and the SPA frontend/REST API/JSON backend architecture. This sophisticated approach might be suitable for big teams and applications but is way to complex for most of small to medium sized teams and application scopes.

In contrast, `matestack-ui-vuejs` helps Rails developers creating modern, reactive web apps while focusing on **simplicity**, **developer happiness** and **productivity**:

* [x] Use Ruby’s amazing language features while creating your UI
* [x] Skip using templating engine syntax and write pure Ruby instead
* [x] Reduce the amount of required JavaScript in order to build reactive web UIs
* [x] Create a single application, managing the full stack from database to a reactive UI in pure Ruby
* [x] **Drastically reduce the complexity of building reactive web applications**

### What makes matestack-ui-vuejs different?

[Hotwire](https://hotwire.dev) and [Stimulus Reflex](https://docs.stimulusreflex.com) are awesome gems. They reduce the amount of required JavaScript when implementing reactive web UIs. They allow us to use more Rails and less JavaScript. **Great!**

Matestack, developed since 2018, goes even one step further: **Use more Ruby and less of everything else** (JavaScript, ERB/HAML/SLIM, CSS).

**Why?** Because Ruby is just beautiful! More Ruby = More developer happiness = Higher productivity

Additionally, most of `matestack-ui-vuejs` does not require Action Cable or Redis, but can optionally use the power of these tools.

## Compatibility

`matestack-ui-vuejs` requires `matestack-ui-core`

`matestack-ui-vuejs` is tested against:

* Rails 7.0.1 + Ruby 3.0.0 + Vue.js 3.2.26
* Rails 6.1.1 + Ruby 3.0.0 + Vue.js 3.2.26
* Rails 6.1.1 + Ruby 2.7.2 + Vue.js 3.2.26
* Rails 6.0.3.4 + Ruby 2.6.6 + Vue.js 3.2.26
* Rails 5.2.4.4 + Ruby 2.6.6 + Vue.js 3.2.26

Rails versions below 5.2 are not officially supported.

Vue.js 2.x is supported when using the Compat build of Vue.js

## Documentation/Installation

Documentation can be found [here](https://docs.matestack.io/matestack-ui-vuejs)

## Getting started

A getting started guide can be found [here](https://docs.matestack.io/matestack-ui-vuejs/getting-started/hello-world)

## Changelog

Changelog can be found [here](./CHANGELOG.md)

## Community

As a low-barrier feedback channel for our early users, we have set up a Discord server that can be found [here](https://discord.com/invite/c6tQxFG). You are very welcome to ask questions and send us feedback there!

## Contribution

We are happy to accept contributors of any kind! In order to make it as easy and fun as possible to contribute to `matestack-ui-vuejs`, we would like to onboard contributors personally! Best way to become a contributor: Ping us on Discord! We will schedule a video call with you and show you, how and what to work on :)

## Feature walk-through

### 1. Use reactive UI components in pure Ruby

Matestack's generic, reactive components can be placed on your UI with a simple Ruby DSL. While putting these generic components in your UI code, you inject some configuration in order to adjust the behaviour to your needs. This enables you to create reactive UIs without touching JavaScript!

*Behind the scenes:* When calling a reactive component with the Ruby DSL, Matestack will render a special component tag with a bunch of attributes to the resulting, server-side rendered HTML. Within the browser, Vue.js will pick up these component tags and mount the JavaScript driven components on it.

**Toggle parts of the UI based on events**

`matestack-ui-vuejs` offers an event hub. Reactive components can emit and receive events through this event hub. "onclick" and "toggle" calling two of these reactive core components. "onclick" emits an event which causes the body of the "toggle" component to be visible for 5 seconds in this example.

`app/matestack/components/some_component.rb`

```ruby
class Components::SomeComponent < Matestack::Ui::Component

  def response
    onclick emit: "some_event" do
      button "click me"
    end
    toggle show_on: "some_event", hide_after: 5000 do
      plain "Oh yes! You clicked me!"
    end
  end

end
```

**Call controller actions without JavaScript**

Core components offer basic dynamic behaviour and let you easily call controller actions and react to server responses on the client side without full page reload. The "action" component is configured to emit an event after successfully performed an HTTP request against a Rails controller action, which is received by the "toggle" component, displaying the success message.

`app/matestack/components/some_component.rb`

```ruby
class Components::SomeComponent < Matestack::Ui::Component

  def response
    action my_action_config do
      button "click me"
    end
    toggle show_on: "some_event", hide_after: 5000 do
      plain "Success!"
    end
  end

  def my_action_config
    {
      path: some_rails_route_path,
      method: :post,
      success: {
        emit: "some_event"
      }
    }
  end

end
```

#### Dynamically handle form input without JavaScript

Create dynamic forms for ActiveRecord Models (or plain objects) and display server side responses, like validation errors or success messages, without relying on a full page reload. Events emitted by the "form" component can be used to toggle parts of the UI.

`app/matestack/components/some_component.rb`

```ruby
class Components::SomeComponent < Matestack::Ui::Component

  def response
    matestack_form my_form_config do
      form_input key: :some_model_attribute, type: :text
      button "click me", type: :submit
    end
    toggle show_on: "submitted", hide_after: 5000 do
      span class: "message success" do
        plain "created successfully"
      end
    end
    toggle show_on: "failed", hide_after: 5000 do
      span class: "message failure" do
        plain "data was not saved, please check form"
      end
    end
  end

  def my_form_config
    {
      for: MyActiveRecordModel.new,
      path: some_rails_route_path,
      method: :post,
      success: {
        emit: "submitted"
      },
      failure: {
        emit: "failed"
      }
    }
  end

end
```

**Implement asynchronous, event-based UI rerendering in pure Ruby**

Using Matestack's built-in event system, you can rerender parts of the UI on client side events, such as form or action submissions. Even server side events pushed via ActionCable may be received! The "async" component requests a new version of its body at the server via an HTTP GET request after receiving the configured event. After successful server response, the DOM of the "async" component gets updated. Everything else stays untouched.

`app/matestack/components/some_component.rb`

```ruby
class Components::SomeComponent < Matestack::Ui::Component

  def response
    matestack_form my_form_config do
      #...
    end
    #...
    async rerender_on: "submitted", id: "my-model-list" do
      ul do
        MyActiveRecordModel.last(5).each do |model|
          li model.some_attribute
        end
      end
    end
  end

  def my_form_config
    {
      #...
      success: {
        emit: "submitted"
      },
      failure: {
        emit: "failed"
      }
    }
  end

end
```

**Manipulate parts of the UI via ActionCable**

"async" rerenders its whole body - but what about just appending the element to the list after successful form submission? The "cable" component can be configured to receive events and data pushed via ActionCable from the server side and just append/prepend new chunks of HTML (ideally rendered through a component) to the current "cable" component body. Updating and deleting is also supported!

`app/matestack/components/some_component.rb`

```ruby
class Components::SomeComponent < Matestack::Ui::Component

  def response
    matestack_form my_form_config do
      #...
    end
    #...
    cable prepend_on: "new_element_created", id: "some-cable-driven-list" do
      MyActiveRecordModel.last(5).each do |model|
        Components::SomeListItemComponent.call(content: model.some_content)
      end
    end
  end

end
```

`app/controllers/some_controller.rb`

```ruby
# within your controller action handling the form input
ActionCable.server.broadcast("matestack_ui_core", {
  event: "new_element_created",
  data: Components::SomeListItemComponent.call(content: model.some_content) # or plain HTML
})
```

### **2. Easily extend with Vue.js**

Matestack's dynamic parts are built on Vue.js. If you want to implement custom dynamic behaviour, you can simply create your own Vue components and use them along Matestack's components. It's even possible to interact with Matestack's components using the built-in event bus.

`app/matestack/components/some_component.rb`

```ruby
class Components::SomeComponent < Matestack::Ui::Component

  def response
    Components::MyVueJsComponent.call()
    toggle show_on: "some_event", hide_after: "3000" do
      span class: "message success" do
        plain "event triggered from custom vuejs component"
      end
    end
  end

end
```

`app/matestack/components/my_vue_js_component.rb`

```ruby
class Components::MyVueJsComponent < Matestack::Ui::VueJsComponent

  vue_name "my-vue-js-component"

  def response
    div class: "my-vue-js-component" do
      button "@click": "vc.increaseValue"
      br
      plain "{{ vc.dynamicValue }}!"
    end
  end

end
```

`app/matestack/components/my_vue_js_component.js`

```javascript
import MatestackUiVueJs from 'matestack-ui-vuejs'

const myComponent = {
  mixins: [MatestackUiVueJs.componentMixin],
  template: MatestackUiVueJs.componentHelpers.inlineTemplate,
  data: () => {
    return {
      dynamicValue: 0
    };
  },
  methods: {
    increaseValue(){
      this.dynamicValue++
      MatestackUiVueJs.eventHub.$emit("some_event")
    }
  }
}

export default myComponent

// and then in your application pack file you register the component like:

appInstance.component('my-vue-js-component', myComponent) /
```

### 3. Create whole SPA-like apps in pure Ruby

The last step in order to leverage the full Matestack power: Create a Matestack layout (\~Rails layout) and Matestack page (Rails \~view) classes (as seen on `matestack-ui-core`) and implement dynamic page transitions with components coming from `matestack-ui-vuejs` without any custom JavaScript implementation required.

**Create your layouts and views in pure Ruby**

The layout class is used to define a layout, usually containing some kind of header, footer and navigation. The page class is used to define a view. Following the same principles as seen on components, you can use components (core or your own) in order to create the UI. The `matestack_vue_js_app` `page_switch` and `transition` components enable dynamic page transition, replacing the yielded content with new serverside rendered content rendered by the requested page.

`app/matestack/some_app/some_layout.rb`

```ruby
class SomeApp::SomeLayout < Matestack::Ui::Layout

  def response
    h1 "My App"
    matestack_vue_js_app do
      nav do
        transition path: page1_path do
          button "Page 1"
        end
        transition path: page2_path do
          button "Page 2"
        end
      end
      main do
        div class: "container" do
          page_switch do
            yield
          end
        end
      end
    end
  end

end
```

`app/matestack/some_app/pages/page1.rb`

```ruby
class SomeApp::Pages::Page1 < Matestack::Ui::Page

  def response
    div class: "row" do
      div class: "col" do
        plain "Page 1"
      end
    end
  end

end
```

`app/matestack/some_app/pages/page2.rb`

```ruby
class SomeApp::Pages::Page2 < Matestack::Ui::Page

  def response
    div class: "row" do
      div class: "col" do
        plain "Page 2"
      end
    end
  end

end
```

**Layouts and pages are referenced in your Rails controllers and actions**

Instead of referencing Rails layouts and views on your controllers, you just use apps and pages as substitutes. Work with controllers, actions and routing as you're used to! Controller hooks (e.g. devise's authenticate\_user) would still work!

`app/controllers/some_controller.rb`

```ruby
class SomeController < ApplicationController

  include Matestack::Ui::Core::Helper

  matestack_layout SomeApp::SomeLayout

  def page1
    render SomeApp::Page1
  end

  def page2
    render SomeApp::Page2
  end

end
```

`app/config/routes.rb`

```ruby
Rails.application.routes.draw do

  root to: 'some#page1'

  get :page1, to: 'some#page1'
  get :page2, to: 'some#page2'

end
```

**Use CSS animations for fancy page transition animations**

Use Matestack's css classes applied to the wrapping DOM structure of a page in order to add CSS animiations, whenever a page transition is performed. You can even inject a loading state element, enriching your page transition effect.

`app/matestack/some_app/some_layout.rb`

```ruby
class SomeApp::SomeLayout < Matestack::Ui::Layout

  def response
    h1 "My App"
    matestack_vue_js_app do
      nav do
        transition path: page1_path do
          button "Page 1"
        end
        transition path: page2_path do
          button "Page 2"
        end
      end
      main do
        div class: "container" do
          page_switch do
            yield
          end
        end
      end
    end
  end

  def loading_state_element
    div class: 'some-loading-element-styles'
  end

end
```

`app/assets/stylesheets/application.scss`

```scss
.matestack-page-container{

  .matestack-page-wrapper {
    opacity: 1;
    transition: opacity 0.2s ease-in-out;

    &.loading {
      opacity: 0;
    }
  }

  .loading-state-element-wrapper{
    opacity: 0;
    transition: opacity 0.3s ease-in-out;

    &.loading {
      opacity: 1;
    }
  }

}
```

## License

`matestack-ui-vuejs` is an Open Source project licensed under the terms of the [MIT license](./LICENSE)
