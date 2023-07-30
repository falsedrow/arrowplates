local textplates = require("__textplates__/textplates")

-- symbol_indexes is set based on textplates.symbols. That means a remote interface can not add new symbols.
-- Can get the types by using the remote interface, which is slick.
-- Can not get the indexes that way.
-- get_textplate_symbols has a comment implying that it's fine for other mods to call.
-- So we'll do that.

-- Then we need all the types.
-- textplates.types is just the base ones.
-- Option 1: Call the remote interface ourselves.
-- Option 2: Go looking for the items.

-- The problem is, that happens in control.
-- What about during data?
-- The textplates mod only registers its own prototypes, by iterating through textplates.types.
