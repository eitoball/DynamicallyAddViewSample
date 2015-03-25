class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    self.contentView = R::Layout::Activity_main
    @container_view = findViewById(R::Id::Root_view)

    b = findViewById(R::Id::Btn_add_new_item)
    b.onClickListener = self

    @items = {}
  end

  ITEMS = %w{ 電話: メール: 住所: }.map { |e| e.toString }

  def onClick(v)
    case v.getId
    when R::Id::Btn_add_new_item
      onAddNewItemClicked(v)
    when R::Id::Btn_add_new_row
      onAddNewClicked(v)
    when R::Id::Btn_delete
      onDeleteClicked(v)
    end
  end

  def onAddNewItemClicked(v)
    @dialog = Android::App::AlertDialog::Builder.new(self)
      .setTitle('追加する項目を選択してください')
      .setSingleChoiceItems(ITEMS, -1, DialogOnClickListener.new(self))
      .create
    @dialog.show
  end

  def onAddNewClicked(v)
    row_container = v.parent
    textv = row_container.findViewById(R::Id::Textv_item)
    item_type = textv.text.toString
    inflate_edit_row(item_type, '', 0)
  end

  def onDeleteClicked(v)
    row_view = v.parent
    row_container = row_view.parent
    type = row_container.findViewById(R::Id::Textv_item).text.toString
    if row_container.childCount == 3
      @container_view.removeView(row_container)
      @items.remove(type)
    else
      row_container.removeView(row_view)
      @items.get(type).fields.remove(row_view)
    end
  end

  def inflate_edit_item(type)
    edit_item = EditItem.new

    inflater = getSystemService(Android::Content::Context::LAYOUT_INFLATER_SERVICE)
    item_view = inflater.inflate(R::Layout::Row_container, nil)
    b = item_view.findViewById(R::Id::Btn_add_new_row)
    b.onClickListener = self
    edit_item.layout = item_view
    edit_item.type = type
    @items[type] = edit_item

    textv = item_view.findViewById(R::Id::Textv_item)
    textv.text = type

    @container_view.addView(item_view, @container_view.childCount - 1)
  end

  def inflate_edit_row(item_type, data, select)
    inflater = getSystemService(Android::Content::Context::LAYOUT_INFLATER_SERVICE)
    row_view = inflater.inflate(R::Layout::Row, nil)
    b = row_view.findViewById(R::Id::Btn_delete)
    b.onClickListener = self
    edit_text = row_view.findViewById(R::Id::Edit_text)
    spinner = row_view.findViewById(R::Id::Spinner_category)
    item_layout = @items.get(item_type).layout
    @items.get(item_type).fields.add(row_view)

    if data && !data.empty?
      edit_text.text = data
    else
      spinner.selection = select
    end
    item_layout.addView(row_view, item_layout.childCount - 1)
  end
end
