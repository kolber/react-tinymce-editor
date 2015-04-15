window.RichTextEditorControls = React.createClass
  mixins: [React.addons.LinkedStateMixin]

  getInitialState: ->
    linkBarOpen: false
    linkValue: ""
    imageBarOpen: false
    imageValue: ""

  makeBold: (e) ->
    e.preventDefault();
    @props.editor.execCommand("bold", true)
    @updateEditor()

  makeItalic: (e) ->
    e.preventDefault();
    @props.editor.execCommand("italic", true)
    @updateEditor()

  makeQuote: (e) ->
    e.preventDefault();
    @props.editor.formatter.toggle("blockquote")
    @updateEditor()

  insertLink: (e) ->
    e.preventDefault() if e
    selected = @props.editor.selection.getContent( format: 'text' )
    @props.editor.execCommand('mceInsertContent', false, "<a href='#{@state.linkValue}'>#{if selected.length > 0 then selected else @state.linkValue}</a>")
    @setState
      linkBarOpen: false
      linkValue: ""
    @updateEditor()

  insertImage: (e) ->
    e.preventDefault() if e
    @props.editor.insertContent("<img src='#{@state.imageValue}' alt=''>");
    @setState
      imageBarOpen: false
      imageValue: ""
    @updateEditor()

  updateEditor: ->
    @props.contentChangeCallback()
    @props.editor.focus()

  openImageBar: (e) ->
    e.preventDefault();
    @setState imageBarOpen: true
  closeImageBar: (e) ->
    e.preventDefault();
    @setState imageBarOpen: false

  openLinkBar: (e) ->
    e.preventDefault();
    if @props.activeButtons['link']
      @props.editor.formatter.remove("link");
    else
      @setState linkBarOpen: true
  closeLinkBar: (e) ->
    e.preventDefault();
    @setState linkBarOpen: false

  linkInputKeyUp: (e) ->
    if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13))
      e.preventDefault()
      @insertLink(e)

  imageInputKeyUp: (e) ->
    if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13))
      e.preventDefault()
      @insertImage(e)

  linkBar: ->
    if @state.linkBarOpen
      `<div>
        <div className="editor-bar editor-bar-link fixed-right">
          <span className="fixed-right__left">
             <input className="form-control" ref="linkInput" onKeyPress={this.linkInputKeyUp} placeholder="Please enter your URL" valueLink={this.linkState('linkValue')} />
           </span>
           <span className="fixed-right__right">
             <button className="button" onClick={this.insertLink}>Insert link</button>
             <a href="#" className="button button--link button--compressed" onClick={this.closeLinkBar}><i className="fa fa-fw fa-remove" /></a>
           </span>
         </div>
         <div className="editor-bar__shade" onClick={this.closeLinkBar} />
       </div>`
    else ``

  imageBar: ->
    if @state.imageBarOpen
      `<div>
        <div className="editor-bar editor-bar-link fixed-right">
          <span className="fixed-right__left">
             <input className="form-control" ref="linkInput" onKeyPress={this.imageInputKeyUp} placeholder="Please enter the URL of your image" valueLink={this.linkState('imageValue')} />
           </span>
           <span className="fixed-right__right">
             <button className="button" onClick={this.insertImage}>Insert image</button>
             <a href="#" className="button button--link button--compressed" onClick={this.closeImageBar}>&times;</a>
           </span>
         </div>
         <div className="editor-bar__shade" onClick={this.closeImageBar} />
       </div>`
    else ``

  componentDidUpdate: ->
    if linkInput = @refs.linkInput
      input = React.findDOMNode(linkInput)
      input.focus()
      # Move cursor to the end
      input.selectionStart = input.selectionEnd = input.value.length

  render: ->
    boldActiveClass = if @props.activeButtons['bold'] then "active" else ""
    italicActiveClass = if @props.activeButtons['italic'] then "active" else ""
    linkActiveClass = if @props.activeButtons['link'] then "link active" else "link"
    quoteActiveClass = if @props.activeButtons['quote'] then "active" else ""
    `<div>
       <div className="editor-controls">
         <button onClick={this.makeBold} className={boldActiveClass} title="Bold"><i className="fa fa-fw fa-bold" /></button>
         <button onClick={this.makeItalic} className={italicActiveClass} title="Italic"><i className="fa fa-fw fa-italic" /></button>
         <button onClick={this.makeQuote} className={quoteActiveClass} title="Blockquote"><i className="fa fa-fw fa-quote-right" /></button>
         <button onClick={this.openLinkBar} className={linkActiveClass} title="Insert link">
           <i className="fa fa-fw fa-link" />
           <i className="fa fa-fw fa-unlink" />
         </button>
         <button onClick={this.openImageBar} title="Insert image">
           <i className="fa fa-fw fa-image" />
         </button>
       </div>
       {this.linkBar()}
       {this.imageBar()}
     </div>`
