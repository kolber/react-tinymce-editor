#= require ./rich-text-editor
$(->
  RichTextEditor = window.RichTextEditor
  editor = $('#editor textarea')[0]
  React.render `<RichTextEditor placeholder={editor.placeholder} body={editor.value} />`, $('#editor')[0]
)
