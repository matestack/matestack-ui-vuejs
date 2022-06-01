# Isolated Component API

Matestack's concept of isolated components has a lot in common with `async` components. Isolated components can be deferred or asynchronously rerendered like `async` components. In difference to `async` components, isolated components are resolved completely independently from the rest of the UI. If an isolated component gets rerendered or loaded, Matestack will directly render this component without touching the surrounding UI implementation. `async` - in contrast - is executing the surrounding UI implementation in order to render the relevant UI part. On complex UIs this makes a difference performance wise!

### Differences to simple components

Your isolated components can by design not

* yield components passed in by using a block
* yield slots passed in by using slots
* simply get options injected by surrounding context

They are meant to be `isolated` and resolve all data independently! That's why they can be rendered completely separate from the rest of the UI.

Furthermore isolated components have to be authorized independently. See below.

### Differences to the `async` component

The [`async` component](https://github.com/matestack/matestack-ui-core/tree/829eb2f5a7483ef4b78450a5429589ec8f8123e8/docs/reactive\_components/600-isolated/docs/api/100-components/core/async.md) offers pretty similar functionalities enabling you to define asynchronous rendering. The important difference is that rerendering an `async` component requires resolving the whole page on the serverside, which can be performance critical on complex pages. An isolated component bypasses the page and can therefore offer high performance rerendering.

Using the `async` component does NOT require you to create a custom component:

```ruby
class Home < Matestack::Ui::Page
  def response
    h1 'Welcome'
    async id: "some-unique-id", rerender_on: "some-event" do
      div id: 'my-async-wrapper' do
        plain I18n.l(DateTime.now)
      end
    end
  end
end
```

Using an isolated component does require you to create a custom component:

```ruby
class Home < Matestack::Ui::Page
  def response
    h1 'Welcome'
    MyIsolatedComponent.call(rerender_on: "some-event")
  end
end
```

Isolated components should be used on complex UIs where `async` rerendering would be performance critical or you simply wish to create cleaner and more decoupled code.

To create an isolated component you need to create a component which inherits from `Matestack::Ui::IsolatedComponent`. Implementing your component is straight forward. As always you implement a `response` method which defines what gets rendered.

```ruby
class MyIsolatedComponent < IsolatedComponent

  def response
    div class: 'time' do
      paragraph text: DateTime.now
    end
  end

  def authorized?
    true
  end

end
```

And use it with the `:defer` or `:rerender_on` options which work the same on `async` components.

```ruby
def response
  MyIsolatedComponent.call(defer: 1000, rerender_on: 'update-time')
end
```

## Authorize

When asynchronously rendering isolated components, these HTTP calls are actually processed by the controller action responsible for the corresponding page rendering. One might think, that the optional authorization and authentication rules of that controller action should therefore be enough for securing isolated component rendering.

But that's not true. It would be possible to hijack public controller actions without any authorization in place and request isolated components which are only meant to be rendered within a secured context.

That's why we enforce the usage of the `authorized?` method to make sure, all isolated components take care of their authorization themselves.

If `authorized?` returns `true`, the component will be rendered. If it returns `false`, the component will not be rendered.

This might sound complicated, but it is not. For example using devise you can access the controller helper `current_user` inside your isolated component, making authorization implementations as easy as:

```ruby
def authorized?
  current_user.present?
end
```

A public isolated component therefore needs an `authorized?` method simply returning `true`.

You can create your own isolated base components with their `authorized` methods for your use cases and thus keep your code DRY.

## Options

All options below are meant to be injected to your isolated component like:

```ruby
class Home < Matestack::Ui::Page
  def response
    heading size: 1, text: 'Welcome'
    MyIsolatedComonent.call(defer: 1000, #...)
  end
end
```

### defer

The option defer lets you delay the initial component rendering. If you set defer to a positive integer or `true` the isolate component will not be rendered on initial page load. Instead it will be rendered with an asynchronous request only resolving the isolate component.

If `defer` is set to `true` the asynchronous requests gets triggered as soon as the initial page is loaded.

If `defer` is set to a positive integer (including zero) the asynchronous request is delayed by the given amount in ms.

### rerender\_on

The `rerender_on` option lets you define events on which the component will be rerenderd asynchronously. Events on which the component should be rerendered are specified via a comma seperated string, for example `rerender_on: 'event_one, event_two`.

### rerender\_delay

The `rerender_delay` option lets you specify a delay in ms after which the asynchronous request is emitted to rerender the component. It can for example be used to smooth out loading animations, preventing flickering in the UI for fast responses.

### init\_on

With `init_on` you can specify events on which the isolate components gets initialized. Specify events on which the component should be initially rendered via a comma seperated string. When receiving a matching event the isolate component is rendered asynchronously. If you also specified the `defer` option the asynchronous rerendering call will be delayed by the given time in ms of the defer option. If `defer` is set to `true` the rendering will not be delayed.

### replace\_on

Similar to `rerender_on`. Difference: When using `rerender_on`, the content of the isolated component will be visible until the new content was fetched from the server. When using `replace_on`, the content of the isolated component will be hidden immediately when receiving the event
.
The `replace_on` option lets you define events on which the component will be replaced asynchronously. Events on which the component should be replaceed are specified via a comma seperated string, for example `replace_on: 'event_one, event_two`.

### public\_options (will be deprecated in the future! please use public_context instead)

You can pass data as a hash to your custom isolate component with the `public_options` option. This data is inside the isolate component accessible via a hash with indifferent access, for example `public_options[:item_id]`. All data contained in the `public_options` will be passed as json to the corresponding Vue.js component, which means this data is visible on the client side as it is rendered in the Vue.js component config. So be careful what data you pass into `public_options`!

### public\_context

You can pass data as a hash to your custom isolate component with the `public_context` option. This data is inside the isolate component accessible via an OpenStruct, for example `public_context.item_id`. All data contained in the `public_context` will be passed as json to the corresponding Vue.js component, which means this data is visible on the client side as it is rendered in the Vue.js component config. So be careful what data you pass into `public_context`!

Due to the isolation of the component the data needs to be stored on the client side as to encapsulate the component from the rest of the UI. For example: You want to render a collection of models in single components which should be able to rerender asynchronously without rerendering the whole UI. Since we do not rerender the whole UI there is no way the component can know which of the models it should rerender. Therefore passing for example the id in the public\_options hash gives you the possibility to access the id in an async request and fetch the model again for rerendering. See below for examples.

## DOM structure, loading state and animations

Isolated components will be wrapped by a DOM structure like this:

```markup
<div class="matestack-isolated-component-container">
  <div class="matestack-isolated-component-wrapper">
    <div class="matestack-isolated-component-root" >
      hello!
    </div>
  </div>
</div>
```

During async rendering a `loading` class will automatically be applied, which can be used for CSS styling and animations:

```markup
<div class="matestack-isolated-component-container loading">
  <div class="matestack-isolated-component-wrapper loading">
    <div class="matestack-isolated-component-root" >
      hello!
    </div>
  </div>
</div>
```

Additionally you can define a `loading_state_element` within the component class like:

```ruby
class MyIsolatedComponent < Matestack::Ui::IsolatedComponent
  def response
    div id: 'my-isolated-wrapper' do
      plain "hello"
    end
  end

  def authorized?
    true
  end

  def loading_state_element
    div class: "loading-spinner" do
      plain "spinner..."
    end
  end
end
```

which will then render to:

```markup
<div class="matestack-isolated-component-container">
  <div class="loading-state-element-wrapper">
    <div class="loading-spinner">
      spinner...
    </div>
  </div>
  <div class="matestack-isolated-component-wrapper">
    <div class="matestack-isolated-component-root">
      <div id="my-isolated-wrapper">
        hello!
      </div>
    </div>
  </div>
</div>
```

and during async rendering request:

```markup
<div class="matestack-isolated-component-container loading">
  <div class="loading-state-element-wrapper loading">
    <div class="loading-spinner">
      spinner...
    </div>
  </div>
  <div class="matestack-isolated-component-wrapper loading">
    <div class="matestack-isolated-component-root" >
      hello!
    </div>
  </div>
</div>
```

## Examples

### Simple Isolate

Create a custom component inheriting from the isolate component

```ruby
class MyIsolatedComponent < Matestack::Ui::IsolatedComponent

  def response
    div id: 'my-isolated-wrapper' do
      plain I18n.l(DateTime.now)
    end
  end

  def authorized?
    true
    # check access here using current_user for example when using Devise
    # true means, this isolated component is public
  end

end
```

And use it on your page

```ruby
class Home < Matestack::Ui::Page

  def response
    h1 'Welcome'
    MyIsolatedComponent.call()
  end

end
```

This will render a h1 with the content welcome and the localized current datetime inside the isolated component. The isolated component gets rendered with the initial page load, because the defer options is not set.

### Simple Deferred Isolated

```ruby
class Home < Matestack::Ui::Page

  def response
    h1 'Welcome'
    MyIsolatedComponent.call(defer: true)
    MyIsolatedComponent.call(defer: 2000)
  end

end
```

By specifying the `defer` option both calls to the custom isolated components will not get rendered on initial page load. Instead the component with `defer: true` will get rendered as soon as the initial page load is done and the component with `defer: 2000` will be rendered 2000ms after the initial page load is done. Which means that the second component will show the datetime with 2s more on the clock then the first one.

### Rerender On Isolate Component

```ruby
class Home < Matestack::Ui::Page

  def response
    h1 'Welcome'
    MyIsolatedComponent.call(rerender_on: 'update_time')
    onclick emit: 'update_time' do
      button 'Update Time!'
    end
  end

end
```

`rerender_on: 'update_time'` tells the custom isolated component to rerender its content asynchronously whenever the event `update_time` is emitted. In this case every time the button is pressed the event is emitted and the isolated component gets rerendered, showing the new timestamp afterwards. In contrast to async components only the `MyIsolated` component is rendered on the server side instead of the whole UI.

### Rerender Isolated Component with a delay

```ruby
class Home < Matestack::Ui::Page

  def response
    h1 'Welcome'
    MyIsolatedComponent.call(rerender_on: 'update_time', rerender_delay: 300)
    onclick emit: 'update_time' do
      button 'Update Time!'
    end
  end

end
```

The `MyIsolated` component will be rerendered 300ms after the `update_time` event is emitted

### Initialize isolated component on a event

```ruby
class Home < Matestack::Ui::Page

  def response
   h1 'Welcome'
    MyIsolatedComponent.call(init_on: 'init_time')
    onclick emit: 'init_time' do
      button 'Init Time!'
    end
  end

end
```

With `init_on: 'init_time'` you can specify an event on which the isolated component should be initialized. When you click the button the event `init_time` is emitted and the isolated component asynchronously requests its content.

### Use custom data (public_context) in isolated components

Like described above it is possible to use custom data in your isolated components. Just pass them as a hash to `public_context` and use them in your isolated component. Be careful, because `public_context` are visible in the raw html response from the server as they get passed to a Vue.js component.

Lets render a collection of models and each of them should rerender when a user clicks a corresponding refresh button. Our model is called `Match`, representing a soccer match. It has an attribute called score with the current match score.

At first we create a custom isolated component.

```ruby
class Components::Match::IsolatedScore < Matestack::Ui::IsolatedComponent

  def prepare
    @match = Match.find_by(public_context.id)
  end

  def response
    div class: 'score' do
      plain @match.score
    end
    onclick emit: "update_match_#{@match.id}" do
      button 'Refresh'
    end
  end

  def authorized?
    true
    # check access here using current_user for example when using Devise
    # true means, this isolated component is public
  end

end
```

Now we create our page which will render a list of matches.

```ruby
class Match::Pages::Index < Matestack::Ui::Page

  def response
    Match.all.each do |match|
      Components::Match::IsolatedScore.call(public_context: { id: match.id }, rerender_on: "update_match_#{match.id}")
    end
  end

end
```

This page will render a match\_isolated\_score component for each match. If one of the isolated components gets rerendered we need the id in order to fetch the correct match. Because the server only resolves the isolated component instead of the whole UI, it does not know which match exactly is requested unless the client requests a rerender with the match id. This is why `public_context` is passed to the client side Vue.js component. So if match 2 should be rerendered the client requests the match\_isolated\_score component with `public_context: { id: 2 }`. With this information our isolated component can fetch the match from the database and rerender itself in isolation.

### Emitting an event and set the public_context for an isolated component

The above described `public_context` can also be set by an `onclick` component:

```ruby
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

end

class ExamplePage < Matestack::Ui::Page

  def response
    onclick emit: 'replace_isolated_component_content', public_context: { id: 42 } do
      button 'load 42 in isolated component'
    end
    # somewhere else on the UI
    SomeIsolatedComponentTriggeredByOnclick.call(defer: true, replace_on: "replace_isolated_component_content")
  end

end
```
