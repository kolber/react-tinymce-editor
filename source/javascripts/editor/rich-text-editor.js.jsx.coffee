#= require ./rich-text-editor-controls
EditorControls = window.RichTextEditorControls

window.RichTextEditor = React.createClass
  getInitialState: ->
    id: "id#{Math.floor(Math.random()*5000)}"
    editor: false
    activeButtons:
      bold: false
      italic: false
      link: false
      quote: false
    buttonTags:
      bold: "strong"
      italic: "em"
      link: "a"
      quote: "blockquote"

  componentWillReceiveProps: (nextProps) ->
    if nextProps.contentBody != undefined && nextProps.contentBody.length == 0
      if nextProps.contentBody != @props.contentBody
        @state.editor.setContent('') if @state.editor

  nodechange: (e) ->
    activeButtons =
      bold: false
      italic: false
      link: false
      quote: false
    for button, tag of @state.buttonTags
      if @tag_is_or_descends_from(e, tag)
        activeButtons[button] = true
    @setState activeButtons: activeButtons

  tag_is_or_descends_from: (e, target_tagname, return_element) ->
    if e.element.tagName.toLowerCase() is target_tagname
      if return_element is true
        return e.element
      else
        return true
    i = 0
    while i < e.parents.length
      if e.parents[i].tagName.toLowerCase() is target_tagname
        if return_element is true
          return e.parents[i]
        else
          return true
      i++
    false

  contentChange: ->
    return unless @state && @state.editor
    content = @state.editor.getContent()
    @props.onKeyUp(content) if @props.onKeyUp
    @state.textarea.val content
    @state.textarea.trigger 'change'
    $(document).trigger("textareaUpdated", [@state.editor.getContent(format: 'text')]);

  setupEditor: (editor) ->
    editor.on "init", @contentChange
    editor.on "change", @contentChange
    editor.on "keydown", @contentChange
    editor.on "nodechange", @nodechange

  componentDidMount: ->
    editor = tinyMCE.createEditor(@state.id, {
      object_resizing: false
      plugins: ["paste", "placeholder"]
      selector: "textarea"
      setup: @setupEditor
      theme: "anise"
      height: 200
      autoresize_min_height: 200
      valid_elements: "p,br,ol,ul,li,a[!href],strong/b,em/i,img[src],blockquote"
    })
    editor.render()
    @setState
      editor: editor
      textarea: $(@refs.textarea.getDOMNode())

  render: ->
    `<div className="field fieldtype_richtext">
      <div className="editor">
        <EditorControls editor={this.state.editor} contentChangeCallback={this.contentChange} activeButtons={this.state.activeButtons} />
        <textarea ref="textarea" id={this.state.id} placeholder={this.props.placeholder}>{this.props.body}</textarea>
      </div>
    </div>`
