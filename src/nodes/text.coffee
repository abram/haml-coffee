Node  = require('./node.coffee')

{escapeQuotes} = require('../util/text.coffee')

# Text node that contains everything that cannot be detected as
# other node. This is normally plain text to be inserted into the
# template.
#
module.exports = class Text extends Node

  # Evaluate the text node.
  #
  evaluate: -> @opener = @markText(escapeQuotes(@expression))
