# Onclick Component API

The `onclick` component renders an `a` tag that emits a client side event when the user clicks on it. Other components may react to this event.

The `onclick` component takes a block in order to define its appearance.

## Parameters

### emit - required

Takes a String or Symbol. An event with this name will be emitted using the Matestack event hub.

**Note**: You can pass in multiple, comma-separated events that you want emitted.

### data - optional

Takes an Object. This is the payload that is emitted with the event.

### **\&block - required**

The passed in block defines the appearance of the `onclick` component. The UI structure defined in this block will be wrapped with an `a` tag.

## Examples

### Emitting an event (using a String) which triggers an asynchronous rerendering via `async`

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

### Emitting an event (using a Symbol) which triggers an asynchronous rerendering via `async`

```ruby
class ExamplePage < Matestack::Ui::Page

  def response
    onclick emit: :abc do
      button "rerender something"
    end
    async rerender_on: "abc", id: "some-unique-id" do
      plain "Rerender this text when the 'abc' event is emitted #{DateTime.now}"
    end
  end

end
```

### Emitting _multiple events_ which trigger asynchronous rerenderings via `async`

```ruby
class ExamplePage < Matestack::Ui::Page

  def response
    onclick emit: "abc, def" do
      button "rerender something"
    end
    async rerender_on: "abc", id: "some-unique-id" do
      plain "Rerender this text when the 'abc' event is emitted #{DateTime.now}"
    end
    async rerender_on: "def", id: "some-other-unique-id" do
      plain "Rerender this text when the 'def' event is emitted #{DateTime.now}"
    end
  end

end
```

### Emitting an event _with payload_ which triggers an asynchronous rerendering via `async`

```ruby
class ExamplePage < Matestack::Ui::Page

  def response
    onclick emit: "abc", data: "sent!" do
      button "rerender something"
    end
    async rerender_on: "abc", id: "some-unique-id" do
      plain "Rerender this text when the 'abc' event is emitted #{DateTime.now}"
      plain "{{ vc.event.data }}"
    end
  end

end
```
