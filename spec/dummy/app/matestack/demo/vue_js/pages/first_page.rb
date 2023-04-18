class Demo::VueJs::Pages::FirstPage < Matestack::Ui::Page

  def response
    h2 "First page"

    paragraph do
      plain "play around! --> spec/dummy/app/matestack/demo/vue_js/pages/first_page.rb"
    end

    # you can call components on pages!
    Demo::VueJs::Components::StaticComponent.call(foo: "bar")

    onclick emit: "foo, bar" do
      button "emit foo and bar"
    end

    async rerender_on: "foo, bar", id: "some-async" do
      div do
        plain DateTime.now
      end
    end

    async show_on: "bar", id: "some-other-async" do
      div do
        plain DateTime.now
      end
    end

    hr

    toggle_component_demo
  end

  private

  def toggle_component_demo
    h3 'Explore the toggle component'

    onclick emit: "foo" do
      button "emit foo"
    end

    onclick emit: "bar", data: { message: "Boom!" } do
      button "emit bar"
    end

    toggle init_show: true, hide_on: "foo, bar" do
      plain "I render initially and hide on foo OR bar"
    end

    toggle show_on: "foo", hide_after: 2000 do
      plain "I'm shown on foo and hide in 2 seconds"
    end

    toggle show_on: "foo, bar" do
      plain "I'm shown on foo OR bar"
      plain "Event payload: {{ vc.event.data.message }}"
    end

    toggle show_on: "foo", hide_on: "bar" do
      plain "I'm shown on foo AND hidden on bar"
    end
  end
end
