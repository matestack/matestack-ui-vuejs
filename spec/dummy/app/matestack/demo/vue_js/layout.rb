class Demo::VueJs::Layout < Matestack::Ui::Layout

  def response
    h1 "Demo VueJs App"

    matestack_vue_js_app do

      paragraph do
        plain "play around! --> spec/dummy/app/matestack/demo/vue_js/app.rb"
      end

      nav do
        transition path: demo_vue_js_first_page_path,
                   emit: "page_1_clicked" do
          button "First Page"
        end
        transition path: demo_vue_js_second_page_path,
                   emit: "page_2_clicked, bonus_page_2_clicked" do
          button "Second Page"
        end
      end

      div do
        toggle show_on: "page_1_clicked" do
          plain "`page_1_clicked`` emitted from transition component"
        end

        toggle show_on: "page_2_clicked" do
          plain "`page_2_clicked`` emitted from transition component"
        end

        toggle show_on: "bonus_page_2_clicked" do
          plain "`bonus_page_2_clicked was also emitted from the transition component"
        end
      end

      main do
        # TODO: inject optional loading state element here?
        page_switch do
          yield
        end
      end

    end
  end

end
