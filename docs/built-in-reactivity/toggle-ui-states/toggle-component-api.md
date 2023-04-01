# Toggle Component API

The `toggle` component allows us to react to events and toggle the UI state.

## Parameters

The `toggle` component accepts the following parameters:

### show\_on - optional

The `show_on` option lets us define an event on which the component gets shown. The content is still rendered on init pageload, but simply hidden in the browser until the event is emitted.

```ruby
toggle show_on: 'my_event' do
  div id: 'my-div' do
    plain 'I was not here before the event'
  end
end
```

You can pass in multiple, comma-separated events on which the component should be shown.

```ruby
toggle show_on: 'my_event, some_other_event' do
  div id: 'my-div' do
    plain 'I was not here before any of the events'
  end
end
```

### hide\_on - optional

The `hide_on` option lets us define an event on which the component gets hidden.

```ruby
toggle hide_on: 'my_event' do
  div id: 'my-div' do
    plain 'You will not see me after the event'
  end
end
```

You can pass in multiple, comma-separated events on which the component should be hidden.

```ruby
toggle hide_on: 'my_event, some_other_event' do
  div id: 'my-div' do
    plain 'You will not see me after any of the events'
  end
end
```

### hide\_after - optional

The `hide_after` option lets us define a timespan in milliseconds after which the component gets hidden.

```ruby
toggle hide_after: 1000 do
  div id: 'my-div' do
    plain 'I will be hidden after 1000ms'
  end
end
```

### init\_show - optional

The `init_show` option lets us define if the content should be shown initially.

By default the content is shown initially unless `show_on` is defined.

`init_show` is therefore only used in a context like this:

```ruby
toggle show_on: "my_show_event", hide_on: 'my_hide_event', init_show: true do
  div id: 'my-div' do
    plain "I'm initially shown and then can be toggled based on events"
  end
end
```

## Examples

### Show on event

On our example page, we wrap a simple timestamp in an toggle component and tell it to show up when the event `my_event` gets triggered.

```ruby
class ExamplePage < Matestack::Ui::Page

  def response
    toggle show_on: 'my_event' do
      div id: 'my-div' do
        plain "#{DateTime.now.strftime('%Q')}"
      end
    end
  end

end
```

Only _After_ our event was fired is the timestamp visible on our page!

### Hide on event

On our example page, we wrap a simple timestamp in an toggle component and tell it to hide itself when the event `my_event` gets triggered.

```ruby
class ExamplePage < Matestack::Ui::Page

  def response
    toggle hide_on: 'my_event' do
      div id: 'my-div' do
        plain "#{DateTime.now.strftime('%Q')}"
      end
    end
  end

end
```

As expected, the timestamp is only visible _before_ our event was fired and is hidden/invisible _after_ the event!

### Hide after + show on event

On our example page, we wrap a simple timestamp in an toggle component and tell it to show up when the event `my_event` gets triggered and be hidden after 1000 milliseconds.

```ruby
class ExamplePage < Matestack::Ui::Page

  def response
    toggle show_on: 'my_event', hide_after: 1000 do
      div id: 'my-div' do
        plain "#{DateTime.now.strftime('%Q')}"
      end
    end
  end

end
```

In this case, the timestamp is only visible _after_ our event was fired, but just for a certain amount of time. After the specified time is up, it gets hidden!

### Show on event with event payload

On our example page, we wrap some plaintext in our toggle component around a placeholder for the event message.

```ruby
class ExamplePage < Matestack::Ui::Page

  def response
    toggle show_on: 'my_event' do
      div id: 'my-div' do
        plain "{{vc.event.data.message}}"
      end
    end
  end

end
```

As an example, we can fire the following event:

```javascript
MatestackUiVueJs.eventHub.$emit("my_event", { message: "test!" })
```

As a result, the event message gets shown _after_ our event was fired!

### Combine show\_on/hide\_on

If you combine `show_on` and `hide_on`, you can toggle the view state of the `toggle` component explicitly.

By default, the content is initially hidden until the show event is emitted when `show_on` is applied.

```ruby
toggle show_on: "my_show_event", hide_on: 'my_hide_event' do
  div id: 'my-div' do
    plain 'You will not see me after the event'
  end
end
```

If you want to display the content initially, simply add `init_show: true`

```ruby
toggle show_on: "my_show_event", hide_on: 'my_hide_event', init_show: true do
  div id: 'my-div' do
    plain 'You will not see me after the event'
  end
end
```
