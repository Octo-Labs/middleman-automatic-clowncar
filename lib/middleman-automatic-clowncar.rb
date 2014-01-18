require "middleman-core"

require "middleman-automatic-clowncar/version"

::Middleman::Extensions.register(:automatic_clowncar) do
  require "middleman-automatic-clowncar/extension"
  ::Middleman::AutomaticClowncar::Extension

  #require "middleman-automatic-clowncar/thumbnailer-extension"
  #::Middleman::AutomaticClowncar::Thumbnailer


end

