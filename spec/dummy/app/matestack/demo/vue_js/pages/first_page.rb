class Demo::VueJs::Pages::FirstPage < Matestack::Ui::Page
  include Matestack::Ui::VueJs::Components::Collection::Helper

  def prepare
    my_collection_id = "my-first-collection"
    current_order = get_collection_order(my_collection_id)
    my_base_query = DummyModel.all.order(current_order)
    @my_collection = set_collection({
                                      id: my_collection_id,
                                      data: my_base_query
                                    })
  end

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

    hr

    collection_component_demo
  end

  private

  def collection_component_demo
    heading size: 2, text: "My Collection"
    ordering
    content
  end

  def ordering
    collection_order @my_collection.config do
      plain "sort by:"
      collection_order_toggle key: :title do
        button do
          plain "title"
          collection_order_toggle_indicator key: :title,
                                            default: ' created_at',
                                            slots: {
                                              asc: method(:asc_indicator),
                                              desc: method(:desc_indicator)
                                            }
        end
      end
    end
  end

  def asc_indicator
    unescaped " &#8593;"
  end

  def desc_indicator
    plain ' desc'
  end

  def content
    async rerender_on: "my-first-collection-update", id: "my-collection" do
      collection_content @my_collection.config do
        ul do
          @my_collection.paginated_data.each do |dummy|
            li class: "item" do
              plain dummy.title
              plain " "
              plain dummy.description
            end
          end
        end
      end
    end
  end

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
