# Draggable & DropZone Components API

## Examples

```ruby
def response
  div class: "row" do
    div class: "col-4" do
      list_partial(status: :open)
    end
    div class: "col-4" do
      list_partial(status: :in_progress)
    end
    div class: "col-4" do
      list_partial(status: :done)
    end
  end
end

def list_partial(status:)
  dummy_models = DummyModel.send(status)
  h4 status.to_s.camelcase
  async rerender_on: "moved", id: "#{status}-dummies" do
    if dummy_models.empty?
      # if no data is on this list, render a bigger drop zone with position 0
      drop_zone drop_zone_config(
        status: status,
        position: 0,
        css_class: "increased-height"
      )
    else
      drop_zone drop_zone_config(status: status, position: 0)
      dummy_models.each_with_index do |dummy_model, index|
        dummy_model_partial(dummy_model)
        # render a drop zone after each item, enabling sorting within this list
        drop_zone drop_zone_config(
          status: status,
          position: dummy_model.id
        )
        if index != dummy_models.size - 1
          drop_zone drop_zone_config(
            status: status,
            position: dummy_model.id
          )
        else
          # render a bigger drop_zone after the last item on the list
          drop_zone drop_zone_config(
            status: status,
            position: dummy_model.id,
            css_class: "increased-height"
          )
        end
      end
    end
  end
end

def dummy_model_partial(dummy_model)
  draggable(
    draggable_id: dummy_model.id, # required
    drag_key: "dummy_model" # required
    ) do
    div class: "card" do
      div class: "card-body" do
        plain dummy_model.title
      end
    end
  end
end

def drop_zone_config(status:, position:, css_class: "")
  {
    method: :put, # required
    path: demo_vue_js_example_drop_path, # required
    data: { status: status, position: position }, # required data for the update action
    drag_key: "dummy_model", # required, has to match the drag_key from the draggable component
    success: { emit: "moved" }, # required, trigger rerendering of lists
    class: "dropzone #{css_class}", # optional: css styling
    highlight_class: "highlight", # optional: css styling highlighting a drop zone
    hover_class: "hover" # optional: used in css animation on drag hover
  }
end
```

```scss
.dropzone {
  min-height: 5px;
  transition: min-height 0.1s ease;
  &.hover {
    min-height: 50px;
  }
  &.increased-height{
    min-height: 300px;
  }
}
```

```ruby
def example_drop
  @dummy_model = DummyModel.find(drop_params[:draggable_id])

  if @dummy_model.update(status: drop_params[:status])
    render json: {
      message: 'Dummy model was successfully moved.'
    }, status: :created
  else
    render json: {
      errors: @dummy_model.errors,
      message: 'Dummy model could not be moved.'
    }, status: :unprocessable_entity
  end
end

private

def drop_params
  params.permit(:draggable_id, :status)
end
```
