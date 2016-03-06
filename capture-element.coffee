#!/usr/bin/env phantomjs

page = require('webpage').create()
system = require 'system'

if system.args.length is 1
  console.log 'Usage: capture-element.coffee <URL> (filename) (#selector) (widthxheight)'
  phantom.exit 1
else
  # quit if this takes too long
  setTimeout ->
    phantom.exit(1)
  , 8000

  address = system.args[1]
  filename = system.args[2] || 'capture.png' 
  selector = system.args[3]

  page.paperSize = {
    format: 'A4'
    orientation: 'portrait'
    border: '0.4in'
  } if filename[-3..] is 'pdf'

  if system.args.length > 4
    [width, height] = system.args[4].split 'x'
    page.viewportSize = { width: width, height: height }

  page.open address, (status) ->
    if status isnt 'success'
      console.log 'ERROR: Failed to open URL'
    else
      clipRect = page.evaluate (s) ->
        return document.querySelector(s)?.getBoundingClientRect()
      , selector if selector?

      if !selector? || (page.clipRect = clipRect)
        page.render filename
        console.log "Rendered to #{filename}"
      else console.log "ERROR: Couldn't find a match for that selector"
    phantom.exit()
