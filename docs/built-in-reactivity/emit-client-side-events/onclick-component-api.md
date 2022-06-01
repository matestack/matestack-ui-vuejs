# Onclick Component API

The `onclick` component renders an `a` tag that emits a client side event when the user clicks on it. Other component may react to this event.

The onclick component takes a block in order to define its appearance.

## Parameters

### emit - required

Takes a string or symbol. An event with this name will be emitted using the Matestack event hub.

### data - optional

Specifies the event payload.

### public_context - optional

Specifies the public context provided for an isolated component somewhere else on the UI. See example below

### **\&block - required**

The passed in block defines the appearance of the onclick component. The while UI structure defined in this block will be wrapped with an `a` tag

## Examples

### Emitting an event which triggers an asynchronous rerendering via `async`

```ruby
class ExamplePage < Matestack::Ui::Page

  def response
    onclick emit: "abc" do
      button "rerender something"
    end
    async rerender_on: "abc", id: "some-unique-id" do
      plain "Rerender this text when the 'abc' event is emitted #{DateTime.now}"
    end
  end

end
```
### Emitting an event with payload

```ruby
class ExamplePage < Matestack::Ui::Page

  def response
    onclick emit: 'show_message', data: "some static data" do
      button 'click me'
    end
    toggle show_on: 'show_message' do
      plain "some message"
      br
      plain "{{vc.event.data}}" # --> "some static data"
    end
  end

end
```
### Emitting an event and set the public_context for an isolated component

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
