# Cable Component API

The `cable` component enables us to update the DOM based on events and data pushed via ActionCable without a browser reload.

Please read the [ActionCable Guide](../../integrations/action-cable.md) if you need help setting up ActionCable for your project, and make sure you have set up ActionCable correctly. The following code snippet is crucial to make the `cable` component work correctly:

`app/javascript/channels/matestack_ui_core_channel.js`

```javascript
import MatestackUiVueJs form 'matestack-ui-core';

consumer.subscriptions.create("MatestackUiVueJsChannel", {
  //...
  received(data) {
    MatestackUiVueJs.eventHub.$emit(data.event, data)
  }
});
```

A `cable` component renders a Vue.js driven cable component initially containing content specified by a block.

Imagine something like this:

```ruby
class Page < Matestack::Ui::Page

  def response
    cable id: 'foo' [...] do
      # this block will be rendered as initial content and may be
      # modified on the client side later upon receiving defined events
      DummyModel.all.each do |instance|
        ListComponent.call(item: instance)
      end
    end
  end
end
```

```ruby
class ListComponent < Matestack::Ui::Component

  required :item

  def response
    # make sure to define an unique ID on the root element of your component
    # the declared ID may be used later on to update or delete this component on the client side
    div id: "item-#{context.item.id}", class: "row" do
      #...
    end
  end

end
```

Please note: When rendering a list of items, we recommend to use a custom component for each item. This makes it easy to render unique items on the server side and push them via ActionCable to the client. Technically, it is also possible to use another component or a simple html string. Any given html will be used to update the item.

## Parameters

### id - required

Expects an unique string that identifies the `cable` component

### **append\_on**

Expects a string that matches the event which will be emitted via ActionCable on the serverside. Event payload data in form of HTML will be **appended** to the current cable component DOM.

In your app, page or component:

```ruby
cable id: 'foo', append_on: "model_created" do
  DummyModel.all.each do |instance|
    ListComponent.call(item: instance)
  end
end
```

In your controller:

```ruby
ActionCable.server.broadcast("matestack_ui_core", {
  event: "model_created",
  data: ListComponent.call(item: @new_model_instance)
})
```

`data` can also be an array of components.

### prepend\_on

Expects a string that matches the event which will be emitted via ActionCable on the serverside. Event payload data in form of HTML will be **prepended** to the current cable component DOM.

In your app, page or component:

```ruby
cable id: 'foo', prepend_on: "model_created" do
  DummyModel.all.each do |instance|
    ListComponent.call(item: instance)
  end
end
```

In your controller:

```ruby
ActionCable.server.broadcast("matestack_ui_core", {
  event: "model_created",
  data: ListComponent.call(item: @new_model_instance)
})
```

`data` can also be an array of components.

### replace\_on

Expects a string that matches the event which will be emitted via ActionCable on the serverside. Event payload data in form of HTML will **replace** the whole current cable component DOM.

In your app, page or component:

```ruby
cable id: 'foo', replace_on: "model_created" do
  DummyModel.all.each do |instance|
    ListComponent.call(item: instance)
  end
end
```

In your controller:

```ruby
ActionCable.server.broadcast("matestack_ui_core", {
  event: "model_created",
  data: ListComponent.call(item: @new_model_instance)
})
```

`data` can also be an array of components.

### update\_on

Expects a string that matches the event which will be emitted via ActionCable on the serverside. Event payload data in form of HTML will **update** a specific element iditified by its root ID within the current cable component DOM.

In your app, page or component:

```ruby
cable id: 'foo', append_on: "model_created" do
  DummyModel.all.each do |instance|
    ListComponent.call(item: instance)
  end
end
```

In your controller:

```ruby
ActionCable.server.broadcast("matestack_ui_core", {
  event: "model_created",
  data: matestack_component(:list_component, item: @new_model_instance)
})
```

`data` can also be an array of components.

### delete\_on

Expects a string that matches the event which will be emitted via ActionCable on the serverside. Event payload data in form of a string containing the ID will **remove** a specific element identified by its root ID within the current cable component DOM.

In your app, page or component:

```ruby
cable id: 'foo', delete_on: "model_deleted" do
  DummyModel.all.each do |instance|
    ListComponent.call(item: instance)
  end
end
```

In your controller:

```ruby
ActionCable.server.broadcast("matestack_ui_core", {
  event: "model_deleted",
  data: "item-#{params[:id]}"
})
```

`data` can also be an Array of ID-strings.

## Examples



###

Imagine a list of Todo Items and a above that list a form to create new Todos, implemented like this:

```ruby
class MyPage < Matestack::Ui::Page

  def response
    matestack_form method: :post, path: create_action_rails_route_path do
      form_input key: :title, type: :text
      button "submit"
    end

    Todo.all.each do |instance|
      TodoComponent.call(todo: instance)
    end
  end

end
```

```ruby
class TodoComponent < Matestack::Ui::Component

  required :todo

  def response
    div id: "todo-#{context.todo.id}", class: "row" do
      div class: "col" do
        plain context.todo.title
      end
    end
  end

end
```

After form submission, the form resets itself dynamically, but the list will not get updated with the new todo instance. You can now decide, if you want to use `async` or `cable` in order to implement that reactivity. `async` could react to an event emitted by the `form` and simply rerender the whole list without any further implementation. Wrapping the list in a correctly configured `async` component would be enough!

But in this case, we do not want to rerender the whole list every time we submitted the form, because - let's say - the list will be quite long and rerendering the whole list would be getting slow. We only want to add new items to the current DOM without touching the rest of the list. The `cable` component enables you to do exactly this. The principle behind it: After form submission the new component is rendered on the serverside and than pushed to the clientside via ActionCable. The `cable` component receives this event and will than - depending on your configuration - append or prepend the current list on the UI. Implementation would look like this:



### Appending elements

_adding elements on the bottom of the list_

```ruby
class MyPage < Matestack::Ui::Page

  def response
    matestack_form method: :post, path: create_action_rails_route_path do
      form_input key: :title, type: :text
      button "submit"
    end

    cable id: "my-cable-list", append_on: "new_todo_created" do
      Todo.all.each do |instance|
        TodoComponent.call(todo: instance)
      end
    end
  end

end
```

and on your controller:

```ruby
def create
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

Please notice that we recommend to use a component for each list item. With a component for each item it is possible to easily render a new list item within the `create` action and push it to the client. But it is possible to also use another component or a html string. Any given html will be appended to the list.

### Prepending elements

_adding elements on the top of the list_

Prepending works pretty much the same as appending element, just configure your `cable` component like this:

```ruby
cable id: "my-cable-list", prepend_on: "new_todo_created" do
  Todo.all.each do |instance|
    TodoComponent.call(todo: instance)
  end
end
```

### Updating elements

_updating existing elements within the list_

Now imagine you want to update elements in your list without browser reload because somewhere else the title of a todo instance was changed. You could use `async` for this as well. Esspecially because `async` can react to serverside events pushed via ActionCable as well. But again: `async` would rerender the whole list... and in our usecase we do not want to this. We only want to update a specific element of the list. Luckily the implementation for this features does not differ from the above explained ones!

Imagine somewhere else the specific todo was updated via a form targeting the following controller action:

```ruby
def update
  @todo = Todo.find(params[:id])
  @todo.update(todo_params)

  unless @todo.errors.any?
    ActionCable.server.broadcast("matestack_ui_core", {
      event: "todo_updated",
      data: TodoComponent.call(todo: @todo)
    })
    # respond to the form PUT request (needs to be last)
    render json: { }, status: :ok
  end
end
```

Again, the controller action renders a new version of the component and pushes that to the clientside. Nothing changed here! We only need to tell the `cable` component to react properly to that event:

```ruby
cable id: "my-cable-list", update_on: "todo_updated" do
  Todo.all.each do |instance|
    TodoComponent.call(todo: instance)
  end
end
```

Please notice that it is mandatory to have a unique ID on the root element of each list item. The `cable` component will use the ID found in the root element of the pushed component in order to figure out, which element of the current list should be updated. In our example above we used `div id: "todo-#{todo.id}"` as the root element of our `todo_component` used for each element in the list.

### Removing elements

_removing existing elements within the list_

Well, of course we want to be able to remove elements from that list without rerendering the whole list, as `async` would do. The good thing: We can tell the `cable` component to delete elements by ID:

```ruby
cable id: "my-cable-list", delete_on: "todo_deleted" do
  Todo.all.each do |instance|
    TodoComponent.call(todo: instance)
  end
end
```

Imagine somewhere else the following destroy controller action was targeted:

```ruby
def destroy
  @todo = Todo.find(params[:id])

  if @todo.destroy
    ActionCable.server.broadcast("matestack_ui_core", {
      event: "todo_deleted",
      data: "todo-#{params[:id]}"
    })
    # respond to the DELETE request (needs to be last)
    render json: { }, status: :deleted
  end
end
```

After deleting the todo instance, the controller action pushes an event via ActionCable, now including just the ID of the element which should be removed. Notice that this ID have to match the ID used on the root element of the component. In our example above we used `div id: "todo-#{todo.id}"` as the root element of our `todo_component` used for each element in the list.

### Replacing the whole component body

Now imagine a context in which the whole `cable` component body should be updated rather than just adding/updating/deleting specific elements of a list. In an online shop app this could be the shopping cart component rendered on the top right. When adding a product to the cart, you might want to update the shopping cart component in order to display the new amount of already included products.

The component may look like this:

```ruby
class ShoppingCart < Matestack::Ui::Component

  def response
    div id: "shopping-cart", class: "some-fancy-styling" do
      icon "some-shopping-cart-icon"
      span count, class: "some-badge"
      transition path: shopping_cart_path do
        button "to my cart"
      end
    end
  end

  def count
    # some logic returning the amount of products in the users cart (saved on serverside)
    current_user.cart.products_count
  end

end
```

Imagine somewhere else the following controller action was targeted when adding a product to the cart:

```ruby
def add_to_cart
  @product = Product.find(params[:id])
  current_user.cart.add(@product) #some logic adding the product to the users cart (saved on serverside)

  ActionCable.server.broadcast("matestack_ui_core", {
    event: "shopping_cart_updated",
    data: ShoppingCart.call()
  })
  render json: { }, status: :ok
end
```

and on your UI class (probably your app class):

```ruby
cable id: "shopping-cart", replace_on: "shopping_cart_updated" do
  ShoppingCart.call()
end
```

### Event data as Array

All above shown examples demonstrated how to push a single component or ID to the `cable` component. In all usecases it's also possble to provide an Array of components/ID-strings, e.g.:

```ruby
ActionCable.server.broadcast("matestack_ui_core", {
  event: "todo_updated",
  data: [
    ShoppingCart.call(todo: @todo1),
    ShoppingCart.call(todo: @todo2)
  ]
})
```
