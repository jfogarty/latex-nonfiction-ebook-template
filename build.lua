-- make4ht build.lua — EPUB3 post-processing (2026 template)
local domfilter = require('make4ht-domfilter')

local filter = domfilter { function(dom)
  for _, nav in ipairs(dom:query('nav')) do
    if not nav:get_attribute('epub:type') then
      nav:set_attribute('epub:type', 'toc')
    end
  end
  return dom
end }

Make:match('html', filter)
Make:htlatex()
