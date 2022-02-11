# Transition Component API

Matestack's `transition` component enables switching between pages without a full website reload. It works similar to links, but instead of reloading the complete website, including the layout like Rails usually does, it only asynchronously reloads the page without the layout and replaces it dynamically.

{% hint style="info" %}
Since `3.0.0` transitions require a wrapping `matestack_vue_js_app` component and a `page_switch` component as seen below
{% endhint %}

```ruby
class Shop::Layout < Matestack::Ui::Layout

  def response
    matestack_vue_js_app do # required to wrap transitions and page_switch
      nav do
        transition 'Matestack Shop', path: root_path
        transition 'Products', path: products_path
      end
      page_switch do # required to wrap the yield
        yield
      end
    end
  end

end
```

Let's add the products page which simply lists all products and adds a transition to their show page for each one.

```ruby
class Shop::Pages::Products::Index < Matestack::Ui::Page

  def response
    Products.all.each do |product|
      div do
        paragraph product.name
        transition 'Details', path: product_path(product)
      end
    end
  end

end
```

## Parameters

Except for `id` and `class`, the transition component can handle additional parameters:

### path - required

As the name suggests, the `path` expects a path within our application. If you want to route to a link outside our application, use the `a` method, rendering a typical HTML `a` tag

```ruby
transition path: page1_path do
  button 'Page 1'
end
```

If the path input is a **string** it just uses this string for the transition target.

You can also just use the Rails url helper methods directly. They will return a string which is then used as the transition target without any further processing.

### text

If the transition component receives a text via the first argument, it gets rendered as shown here:

```ruby
transition 'Click me for a transition', path: page1_path
```

```markup
<a href='my_example_app/page1'>Click me for a transition</a>
```

If no text is present, the transition component expects a block that it then _yields_ the usual way.

### delay

You can use this attribute if you want to delay the actual transition. It will not delay the `page_loading_triggered` event

```ruby
delay: 1000 # means 1000 ms
```

## Active class

The `transition` component automatically gets the `active` class on the clientside when the current path equals the target path.

When a sub page of a parent `transition` component is currently active, the parent `transition` component gets the `active-child` class. A sub page is recognized if the current path is included in the target path of the parent `transition` component:

Parent target: `/some_page`

Currently active: `/some_page/child_page` --> Parent gets `child-active`

Query params do not interfere with this behavior.

## Events

The `transition` component automatically emits events on:

* transition triggered by user action -> "page\_loading\_triggered"
* _optional client side delay via `delay` attribute_
* start to get new page from server -> "page\_loading"
* _server side/network delay_
* successfully received new page from server -> "page\_loaded"
* failed to receive new page from server -> "page\_loading\_error"

## DOM structure and loading state element

`app/matestack/example_app/layout.rb`

```ruby
class ExampleApp::Layout < Matestack::Ui::Layout

  def response
    #...
    main do
      page_switch do
        yield
      end
    end
    #...
  end

  def my_loading_state_slot
    span class: "some-loading-spinner" do
      plain "loading..."
    end
  end

end
```

which will render:

```markup
<main>
  <div class="matestack-page-container">
    <div class="loading-state-element-wrapper">
      <span class="some-loading-spinner">
        loading...
      </span>
    </div>
    <div class="matestack-page-wrapper">
      <div><!--this div is necessary for conditonal switch to async template via v-if -->
        <div class="matestack-page-root">
          your page markup
        </div>
      </div>
    </div>
  </div>
</end>
```

and during async page request triggered via transition:

```markup
<main>
  <div class="matestack-page-container loading">
    <div class="loading-state-element-wrapper loading">
      <span class="some-loading-spinner">
        loading...
      </span>
    </div>
    <div class="matestack-page-wrapper loading">
      <div><!--this div is necessary for conditonal switch to async template via v-if -->
        <div class="matestack-page-root">
          your page markup
        </div>
      </div>
    </div>
  </div>
</end>
```

You can use the `loading` class and your loading state element to implement CSS based loading state effects. It may look like this (scss):

```css
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

## Examples

The transition core component renders the HTML `<a>` tag and performs a page transition

### Perform transition from one page to another without full page reload

First, we define our routes (`config/routes.rb`) and the corresponding endpoints in our example controller:

```ruby
get 'my_example_app/page1', to: 'example_app_pages#page1', as: 'page1'
get 'my_example_app/page2', to: 'example_app_pages#page2', as: 'page2'
```

```ruby
class ExampleAppPagesController < ExampleController

  include Matestack::Ui::Core::Helper

  matestack_layout ExampleApp::Layout

  def page1
    render ExampleApp::Pages::ExamplePage
  end

  def page2
    render ExampleApp::Pages::SecondExamplePage
  end

end
```

Then, we define our example app layout with a navigation that consists of two transition components!

```ruby
class ExampleApp::Layout < Matestack::Ui::Layout

  def response
    h1 'My Example App Layout'
    matestack_vue_js_app do
      nav do
        transition path: page1_path do
          button 'Page 1'
        end
        transition path: page2_path do
          button 'Page 2'
        end
      end
      main do
        page_switch do
          yield
        end
      end
    end
  end

end
```

Lastly, we define two example pages for our example application:

```ruby
class ExampleApp::Pages::ExamplePage < Matestack::Ui::Page

  def response
    div id: 'my-div-on-page-1' do
      h2 'This is Page 1'
      plain "#{DateTime.now.strftime('%Q')}"
    end
  end

end
```

and

```ruby
class ExampleApp::Pages::SecondExamplePage < Matestack::Ui::Page

  def response
    div id: 'my-div-on-page-2' do
      h2 'This is Page 2'
      plain "#{DateTime.now.strftime('%Q')}"
    end
    transition path: page1_path do
      button 'Back to Page 1'
    end
  end

end
```

Now, we can visit our first example page via `localhost:3000/my_example_app/page1` and see our two buttons (`Page 1` and `Page 2`) and the content of page 1 (`My Example App Layout` and `This is Page 1`).

After clicking on the `Page 2`-button, we get transferred to our second page (`This is Page 2`) without re-loading the whole page.

If we then click the other button available (`Back to Page 1`), we get transferred back to the first page, again without re-loading the whole page. This behavior can save quite some request payload (and therefore loading time) as only the relevant content on a page gets replaced!
