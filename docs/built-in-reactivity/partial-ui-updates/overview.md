# Overview

## `Async` component

An `async` component can be used to either defer some content on page loads or to rerender a parts of the UI on events. For example it's possible to rerender a table of data after a "reload" or "delete" button click or to defer rendering of complex components on inital page load and render these components asynchronously afterwards in order to increase the initial page load time.

Below you see an example, how `async` can be used to rerender a part of the UI via an event emitted by the `onclick` component. `async` will trigger the rendering of the whole surrounding page or view and just sending back the requested part to the frontend.&#x20;

```ruby
def response
  async id: 'rerendering-async', rerender_on: 'update-time' do
    paragraph DateTime.now
  end
  onclick emit: 'update-time' do
    button text: 'Update time'
  end
end
```

Read more:

{% content-ref url="async-component-api.md" %}
[async-component-api.md](async-component-api.md)
{% endcontent-ref %}

## `Cable` component

The `cable` component is designed to asynchronously manipulate its DOM based on ActionCable events and data triggered and rendered on the serverside. Imagine a list of Todos and a `form` below that list. After creating a new Todo, the new list item can be rendered on the serverside and pushed to the `cable` component, which can be configured to pre or append the current list with the new item:

```ruby
cable id: "my-cable-list", prepend_on: "new_todo_created" do
  Todo.all.each do |instance|
    TodoComponent.call(todo: instance)
  end
end
```

with a corresponding controller:

```ruby
def create
  # triggered by a matestack_form submission for example
  @todo = Todo.create(todo_params)

  unless @todo.errors.any?
    ActionCable.server.broadcast("matestack_ui_core", {
      event: "new_todo_created",
      data: TodoComponent.call(todo: @todo)
    })
    # respond to the form POST request (needs to be last)
    render json: { }, status: :created
  end
end
```

Furthermore you can update or remove items in that list using ActionCable events as well. The `cable` component again will only manipulate the specific DOM elements and not the whole list.

**Unlike the `async` component, the `cable` component does not request and rerender the whole list after receiving a specific event.** This requires more implementation effort but gives you more flexibility and performance while creating reactive UIs compared to the `async` component. As usual, no JavaScript is required at your end in order to implement this sophisticated reactivity.

### `cable` vs `async` component

`cable` and `async` might seem similar. They indeed can be used for similar use cases - imagine implementing a reactive list of todo items (using ActiveRecord) created via a `form` below the list. You can either use `async` or `cable` in order to create that reactive list!

But they work completely differently:

* An `async` component rerenders its whole body via a background HTTP GET request when receiving clientside or serverside events
* A `cable` component may receive serverside (ActionCable) events including...
  * serverside rendered HTML which is then used to append, prepend, or replace its body
  * serverside rendered HTML which is then used to update an existing element on the DOM reference by an ID
  * an ID which is then used to remove an existing element from the DOM

Furthermore:

* An `async` does not require any further setup. A Matestack UI class and a corresponding controller is all you need to implement.
* A `cable` component requires an ActionCable setup and ActionCable event emission on the serverside.

This means:

* `async` requires less implementation but will always simply request and rerender its whole body and therefore needs more computation time on the serverside
* `cable` requires more implementation but rerenders only very specific parts of UI and therefore needs less computation time on the serverside

If you specifically want to control how to rerender parts of the UI and worry about performance in your specific usecase, use `cable`!

If you just need a simple reactive UI and don't need to optimize for performance in your specific usecase, use `async`!

Read more:

{% content-ref url="cable-component-api.md" %}
[cable-component-api.md](cable-component-api.md)
{% endcontent-ref %}

## Isolated components

Matestack's concept of isolated components has a lot in common with `async` components. Isolated components can be deferred or asynchronously rerendered like `async` components. In difference to `async` components, isolated components are resolved completely independently from the rest of the UI. If an isolated component gets rerendered or loaded, Matestack will directly render this component without touching the surrounding UI implementation. `async` - in contrast - is executing the surrounding UI implementation in order to render the relevant UI part. On complex UIs this makes a difference performance wise!

Isolated components can not be called or used with a block like `async`, instead you need to create a component inheriting from `Matestack::Ui::IsolatedComponent`. Creation of the custom component works similar to other components, except you need to implement an `authorized?` method. As said above, isolated components are completely independent and could be called directly via an URL, therefore they need custom authorization.

Isolated components are perfectly when you have long runnning, complex database queries or business logic which concludes to slow page loads. Use an isolated component with the `:defer` option to keep your page loads fast and present the result to the user asynchronously.

Read more:

{% content-ref url="isolated-component-api.md" %}
[isolated-component-api.md](isolated-component-api.md)
{% endcontent-ref %}
