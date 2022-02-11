# Onclick Component API

The `onclick` component renders an `a` tag that emits a client side event when the user clicks on it. Other component may react to this event.

The onclick component takes a block in order to define its appearance.

## Parameters

### emit - required

Takes a string or symbol. An event with this name will be emitted using the Matestack event hub.

**You currently cannot pass in an event payload.**

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
