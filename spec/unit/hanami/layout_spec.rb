RSpec.describe Hanami::Layout do
  include_context 'reload configuration'

  describe 'rendering from layout' do
    it 'renders partial' do
      rendered = IndexView.render(format: :html)
      expect(rendered).to match %(<div id="sidebar"></div>)
    end
  end

  it "raises subclassed error if template isn't found" do
    Hanami::View.unload!

    class MissingLayout
      include Hanami::Layout
    end

    begin
      Hanami::View.load!
    rescue => error
      expect(error).to be_a(Hanami::View::MissingTemplateLayoutError)
      expect(error.message).to eq("Can't find layout template 'MissingLayout'")
      expect(error.class).to be < Hanami::View::Error
    end
  end

  # Bug https://github.com/hanami/view/issues/153
  it 'can be rendered directly' do
    rendered = LocalsLayout.new({ format: :html }, "contents").render

    expect(rendered).to include("Locals")
    expect(rendered).to include("contents")
  end

  # Bug https://github.com/hanami/view/issues/153
  # See https://github.com/hanami/view/pull/156
  it 'can be rendered directly (legacy signature)' do
    template = Hanami::View::Template.new("spec/support/fixtures/templates/locals.html.haml")
    layout = LocalsLayout.new(template, {})
    rendered = layout.render

    expect(rendered).to include("Locals")
    expect(rendered).to include("<body>\n\n</body>")
  end

  it 'concrete methods are available in layout template' do
    rendered = Store::Views::Home::Index.render(format: :html)
    expect(rendered).to match %(script)
    expect(rendered).to match %(yeah)
  end

  it 'methods defined in layout are available from the view' do
    rendered = Store::Views::Home::Index.render(format: :html)
    expect(rendered).to match %(Joe Blogs)
  end

  it 'renders content to return value from view' do
    rendered = Store::Views::Products::Show.render(format: :html)
    expect(rendered).to match %(Product)
    expect(rendered).to match %(<script src="/javascripts/product-tracking.js"></script>)
  end

  it 'renders content to return value from layout' do
    rendered = Store::Views::Products::Show.render(format: :html)
    expect(rendered).to match %(Product)
    expect(rendered).to match %(<meta name="hanamirb-version" content="0.3.1">)
  end

  it 'renders optional content from layout' do
    rendered = Store::Views::Products::Show.render(format: :html, flash: { notice: "Product successfully updated" })
    expect(rendered).to match %(<div class="flash-notice">Product successfully updated</div>)
  end

  describe 'disable layout in view' do
    it 'return NullLayout' do
      expect(DisabledLayoutView.layout).to eq Hanami::View::Rendering::NullLayout
    end
  end

  it "renders right partial scopes with method defined in view" do
    rendered = PartialAndLayout::Views::Home::Index.render(format: :html, name: "Hanami")
    expect(rendered).to match(%(Presented Hanami\n    Inside partial, Presented Hanami\n\n    Inside partial, Overwritten Hanami))
  end

  it "renders right layout scope with method defined in layout" do
    rendered = PartialAndLayout::Views::Home::Show.render(format: :html, name: "Hanami")
    expect(rendered).to match(%(Layout Hanami\n    Inside partial, Layout Hanami\n\n    Inside partial, Overwritten Hanami))
  end

  it "renders partials from another folders with relative path" do
    rendered = PartialAndLayout::Views::Home::New.render(format: :html, name: "Hanami")
    expect(rendered).to match(%(Hanami\n    Inside partial, Hanami\n\n    <p>Rendering another partial</p>\nInside partial, Hanami\nHi))
  end
end
