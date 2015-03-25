class DialogOnClickListener
  def initialize(delegate)
    @delegate = delegate
  end

  def onClick(dialog, which)
    dialog.dismiss
    item = MainActivity::ITEMS[which]
    @delegate.inflate_edit_item(item)
    @delegate.inflate_edit_row(item, '', 0)
  end
end
