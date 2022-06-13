# Devise

Devise is one of the most popular gems for authentication. Find out more about Devise [here](https://github.com/plataformatec/devise/).

In order to integrate it fully in Matestack apps and pages we need to adjust a few things. This guide explains what exactly needs to be adjusted.

## Devise helpers

We can access devise helper methods inside our controllers, apps, pages and components like we would normally do. In case of our user model this means we could access `current_user` or `user_signed_in?` in apps, pages and components.

For example:

```ruby
class ExamplePage < Matestack::Ui::Page

  def response
    plain "Logged in as #{current_user.email}" if user_signed_in?
    plain "Hello World!"
  end

end
```

In our controller we also use devise like it is described by devise documentation. For example checking a user is authenticated before he can access a specific controller by calling `authenticate_user!` in a before action.

```ruby
class ExampleController < ApplicationController
  before_action :authenticate_user!

  def index
    render ExamplePage
  end

end
```

## Devise sign in

Using the default devise sign in views should work without a problem, but you can't use Matestack's features on the. If we want to take advantage of them, you can setup the views like shown below:

First we create a custom sign in page containing a form with email and password inputs.

`app/matestack/sessions/sign_in.rb`

```ruby
class Sessions::SignIn < Matestack::Ui::Page

  def response
    h1 'Sign in'
    matestack_form form_config do
      form_input label: 'Email', key: :email, type: :email
      form_input label: 'Password', key: :password, type: :password
      button text: 'Sign in', type: :submit
    end
    toggle show_on: 'sign_in_failure' do
      plain 'Your email or password is not valid.'
    end
  end

  private

  def form_config
    {
      for: :user,
      method: :post,
      path: user_session_path(format: :json),
      success: {
        redirect: { # or transition, if your app layout does not change
          follow_response: true # or static path
        }
      },
      failure: {
        emit: 'sign_in_failure'
      }
    }
  end

end
```

and a minimal layout:

`app/matestack/sessions/layout.rb`

```ruby
class Sessions::Layout < Matestack::Ui::Layout

  def response
    matestack_vue_js_app do
      page_switch do
        yield
      end
    end
  end

end

```

This page displays a form with an email and password input. The default required parameters for a devise sign in. It also contains a `toggle` component which gets shown when the event `sign_in_failure` is emitted. This event gets emitted in case our form submit was unsuccessful as we specified it in our `form_config` hash. If the form is successful our app will make a transition to the page the server would redirect to.

In order to render our sign in page when someone tries to access a route which needs authentication or visits the sign in page we must override devise session controller in order to render our page. We do this by configuring our routes to use a custom controller.

`app/config/routes.rb`

```ruby
Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

end
```

Override the `new` action in order to render our sign in page and set the correct Matestack app in the controller.

`app/controllers/users/sessions_controller.rb`

```ruby
class Users::SessionsController < Devise::SessionsController

  respond_to :html, :json

  # override in order to render a page
  def new
    render Sessions::SignIn, matestack_layout: Sessions::Layout
  end

end
```

{% hint style="info" %}
You can adpat the above shown example in order to implement all other Devise views in Matestack if you need them.
{% endhint %}

## Devise sign out

Creating a sign out button in Matestack is very straight forward. We use matestacks [`action` component](../built-in-reactivity/call-server-side-actions/action-component-api.md) to create a sign out button. See the example below:

```ruby
action sign_out_config do
  button 'Sign out'
end
```

```ruby
def sign_out_config
  {
     method: :get,
     path: destroy_admin_session_path,
     success: {
       redirect: {
         follow_response: true
       }
     }
  }
end
```

Notice the `method: :get` in the configuration hash. We use a http GET request to sign out, because the browser will follow the redirect send from devise session controller and then Matestack tries to load the page where we have been redirected to. When we would use a DELETE request the action we would be redirected to from the browser will be also requested with a http DELETE request, which will result in a rails routing error. Therefore we use GET and need to configure devise accordingly by changing the `sign_out_via` configuration parameter.

`config/initializers/devise.rb`

```ruby
# The default HTTP method used to sign out a resource. Default is :delete.
config.sign_out_via = :get
```
